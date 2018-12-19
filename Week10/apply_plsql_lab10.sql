/*
||  Name:           apply_plsql_lab10.sql
||  Author:         Hiram Todd
||  Date:           19 Nov 2018
||  Purpose:        Complete 325 Chapter 11 lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Open log file.
SPOOL apply_plsql_lab10.txt


SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET DEFINE ON

-- ... insert your solution here ...
/**************************************************************************************
Step 1: Create a base_t object type that maps to the following definition. 
(Don’t forget that you must drop all dependents before you drop a data type, 
and you may need to append the FORCE option when you drop object types.)
***************************************************************************************/
DROP TYPE base_t FORCE;

CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oname VARCHAR2(30)
  , name  VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
  , CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname (oname VARCHAR2)
  , MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

DESC base_t;

/***************************************************************************************
 Implement a base_t object body
****************************************************************************************/
CREATE OR REPLACE
  TYPE BODY base_t IS
 
    /* Override constructor. */
    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
    BEGIN
      self.oname := 'BASE_T';
      RETURN;
    END;
 
    /* Formalized default constructor. */
    CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT IS
    BEGIN
      /* Assign an oname value. */
      self.oname := oname;
      /* Assign a designated value or assign a null value. */
      IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
        self.name := name;
      END IF;
      RETURN;
    END;
 
    /* A getter function to return the name attribute. */
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN self.name;
    END get_name;
 
    /* A getter function to return the name attribute. */
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
      RETURN self.oname;
    END get_oname;
 
    /* A setter procedure to set the oname attribute. */
    MEMBER PROCEDURE set_oname
    ( oname VARCHAR2 ) IS
    BEGIN
      self.oname := oname;
    END set_oname;
 
    /* A to_string function. */
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN '['||self.oname||']';
    END to_string;
  END;
/

/**************************************************************************
Create a logger table, and logger_s sequence
***************************************************************************/
DROP TABLE logger;
DROP SEQUENCE logger_s;

/* Create logger TABLE */
CREATE TABLE logger
        ( logger_id NUMBER
        , log_text  BASE_T );
        
/* Create logger_s SEQUENCE */
CREATE SEQUENCE logger_s;
        
DESC logger;

/****************************** TEST CASE **********************************
Test the ability to create an instance of the base_t type with a default 
oname attribute value, set the instance value of the oname attribute to a 
new value, and get the instance value of the changed oname value with the 
following anonymous PL/SQL block:
***************************************************************************/
DECLARE
  /* Create a default instance of the object type. */
  lv_instance  BASE_T := base_t();
BEGIN
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');
 
  /* Set the oname value to a new value. */
  lv_instance.set_oname('SUBSTITUTE');
 
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/

/**************************************************************************
Insert a row into the logger table
***************************************************************************/
INSERT INTO logger
VALUES ( logger_s.NEXTVAL, base_t());

/**************************************************************************
Insert a base_t object instance with the a parameter-driven constructor
***************************************************************************/
DECLARE
  /* Declare a variable of the UDT type. */
  lv_base  BASE_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_base := base_t(
      oname => 'BASE_T'
    , name => 'NEW' );
 
    /* Insert instance of the base_t object type into table. */
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);
 
    /* Commit the record. */
    COMMIT;
END;
/

/**************************************************************************
Insert the row
***************************************************************************/
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';


/**************************************************************************************
Step 2: Create the item_t subtype by modeling its columns on the item table in the 
video store code and extending the base_t object type. You exclude any BFILE, BLOB, 
CLOB, and NCLOB columns from the item_t type definition. You should include overriding 
methods for the get_name and to_string functions
***************************************************************************************/
CREATE OR REPLACE 
    TYPE item_t UNDER base_t
        ( item_id               NUMBER
        , item_barcode          VARCHAR2(20)
        , item_type             NUMBER
        , item_title            VARCHAR2(60)
        , item_subtitle         VARCHAR2(60)
        , item_rating           VARCHAR2(8)
        , item_rating_agency    VARCHAR2(4)
        , item_release_date     DATE 
        , created_by            NUMBER
        , creation_date         DATE
        , last_updated_by       NUMBER
        , last_update_date      DATE
        , CONSTRUCTOR FUNCTION  item_t
            ( oname                 VARCHAR2
            , name                  VARCHAR2
            , item_id               NUMBER
            , item_barcode          VARCHAR2
            , item_type             NUMBER
            , item_title            VARCHAR2
            , item_subtitle         VARCHAR2
            , item_rating           VARCHAR2
            , item_rating_agency    VARCHAR2
            , item_release_date     DATE
            , created_by            NUMBER
            , creation_date         DATE
            , last_updated_by       NUMBER
            , last_update_date      DATE ) RETURN SELF AS RESULT
        , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
        , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
        INSTANTIABLE NOT FINAL;
/

DESC item_t;

/*************************************************************************************
Need to implement a item_t object body
**************************************************************************************/
CREATE OR REPLACE 
    TYPE BODY item_t IS

        /* Default constructor, implicitly available, but you should
       include it for those who forget that fact. */
        CONSTRUCTOR FUNCTION  item_t
            ( oname                 VARCHAR2
            , name                  VARCHAR2
            , item_id               NUMBER
            , item_barcode          VARCHAR2
            , item_type             NUMBER
            , item_title            VARCHAR2
            , item_subtitle         VARCHAR2
            , item_rating           VARCHAR2
            , item_rating_agency    VARCHAR2
            , item_release_date     DATE
            , created_by            NUMBER
            , creation_date         DATE
            , last_updated_by       NUMBER
            , last_update_date      DATE ) RETURN SELF AS RESULT IS
            BEGIN 
            /* Assign inputs to instance variables */
                self.oname := oname;
                
            /* Assign a designated value or assign a null value. */
            IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
                self.name := name;
            END IF;

                    /* Assign inputs to instance variables. */
                    self.item_id := item_id;
                    self.item_barcode := item_barcode;
                    self.item_type := item_type;
                    self.item_title := item_title;
                    self.item_subtitle := item_subtitle;
                    self.item_rating := item_subtitle;
                    self.item_rating_agency := item_rating_agency;
                    self.item_release_date := item_release_date;
                    self.created_by := created_by;
                    self.creation_date := creation_date;
                    self.last_updated_by := last_updated_by;
                    self.last_update_date := last_update_date;
                
                /* Return an instance of self. */
                RETURN;
            END;

            /* An overriding function for the generalized class. */
            OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
            BEGIN
                RETURN (self AS base_t).get_name();
            END get_name;
            
            /* An overriding function for the generalized class. */
            OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
            BEGIN
                RETURN (self AS base_t).to_string()||'.['||self.name||']';
            END to_string;
        END;
    
/

/*************************************************************************************
Create the contact_t subtype by modeling its columns on the contact table in the video 
store code. You exclude any BFILE, BLOB, CLOB, and NCLOB columns from the item_t type 
definition. You should include overriding methods for the get_name and to_string 
functions
**************************************************************************************/
CREATE OR REPLACE 
    TYPE contact_t UNDER base_t
        ( contact_id            NUMBER
        , member_id             NUMBER
        , contact_type          NUMBER
        , first_name            VARCHAR2(20)
        , middle_name           VARCHAR2(20)
        , last_name             VARCHAR2(20)
        , created_by            NUMBER
        , creation_date         DATE 
        , last_updated_by       NUMBER
        , last_update_date      DATE
        , CONSTRUCTOR FUNCTION  contact_t
            ( oname                 VARCHAR2
            , name                  VARCHAR2
            , contact_id            NUMBER
            , member_id             NUMBER
            , contact_type          NUMBER
            , first_name            VARCHAR2
            , middle_name           VARCHAR2
            , last_name             VARCHAR2
            , created_by            NUMBER
            , creation_date         DATE 
            , last_updated_by       NUMBER
            , last_update_date      DATE ) RETURN SELF AS RESULT
        , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
        , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
        INSTANTIABLE NOT FINAL;
/

DESC contact_t;

/*************************************************************************************
Implement a contact_t object body
**************************************************************************************/
CREATE OR REPLACE 
    TYPE BODY contact_t IS

    /* Default constructor, implicitly available, but you should
       include it for those who forget that fact. */
        CONSTRUCTOR FUNCTION contact_t
            ( oname                 VARCHAR2
            , name                  VARCHAR2
            , contact_id            NUMBER
            , member_id             NUMBER
            , contact_type          NUMBER
            , first_name            VARCHAR2
            , middle_name           VARCHAR2
            , last_name             VARCHAR2
            , created_by            NUMBER
            , creation_date         DATE
            , last_updated_by       NUMBER
            , last_update_date      DATE ) RETURN SELF AS RESULT IS
        BEGIN
        /* Assign inputs to instance variables. */    
        self.oname := oname;
                
                /* Assign a designated value or assign a null value. */
                IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
                    self.name := name;
                END IF;
                
                /* Assign inputs to instance variables. */  
                self.contact_id := contact_id;
                self.member_id := member_id;
                self.contact_type := contact_type;
                self.first_name := first_name;
                self.middle_name := middle_name;
                self.last_name := last_name;
                self.created_by := created_by;
                self.creation_date := creation_date;
                self.last_updated_by := last_updated_by;
                self.last_update_date := last_update_date;

                /* Return an instance of self. */
                RETURN;
            END;
            
            /* An overriding function for the generalized class. */
            OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
            BEGIN
                RETURN (self AS base_t).get_name();
            END get_name;
            
            /* An overriding function for the generalized class. */
            OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
            BEGIN
                RETURN (self AS base_t).to_string()||'.['||self.name||']';
            END to_string;
        END;
/

/************************************************************************************
Need to insert a row into the logger table with a item_t object instance and another 
row with a contact_t object instance
*************************************************************************************/
                
INSERT INTO logger
VALUES  ( logger_s.NEXTVAL
        , item_t( oname => 'ITEM_T'
                , name => 'NEW'
                , item_id => NULL
                , item_barcode => NULL
                , item_type => NULL
                , item_title => NULL
                , item_subtitle => NULL
                , item_rating => NULL
                , item_rating_agency => NULL
                , item_release_date => NULL
                , created_by => NULL
                , creation_date => NULL
                , last_updated_by => NULL
                , last_update_date => NULL ));
                
INSERT INTO logger
VALUES  ( logger_s.NEXTVAL
        , contact_t( oname => 'CONTACT_T'
                , name => 'NEW'
                , contact_id => NULL
                , member_id => NULL
                , contact_type => NULL
                , first_name => NULL
                , middle_name => NULL
                , last_name => NULL
                , created_by => NULL
                , creation_date => NULL
                , last_updated_by => NULL
                , last_update_date => NULL ));
                
                
/************************************** TEST CASE ***********************************
Need to insert a row into the logger table with a item_t object instance and another 
row with a contact_t object instance
*************************************************************************************/
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');

-- Close log file.
SPOOL OFF
