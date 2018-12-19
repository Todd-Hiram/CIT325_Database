/*
||  Name:          apply_plsql_lab7.sql
||  Date:          31 Oct 2018
||  Purpose:       Complete 325 Chapter 8 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- @@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/update_price_function.sql
-- 
-- @@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/contact_insert.sql
-- @@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/contact_insert_10g.sql
-- 
-- @@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/transaction_procedure.sql
-- 
-- @@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/insert_rental.sql
-- @@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/insert_rental_items.sql

SET SERVEROUTPUT ON SIZE UNLIMITED

@@/home/student/Data/cit325/lib/cleanup_oracle.sql
@@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab7.txt

-- ... insert your solution here ...
-- /*********************************************************************************/
-- Step 0: The nested instructions let you make your test cases automatic because you can run the create_video_store.sql script at the beginning of your lab solution
-- /*********************************************************************************/
-- 
-- /* Fix the table by first validating it’s state with this query */
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';


/* The nested instructions let you make your test cases automatic because you can run the create_video_store.sql script at the beginning of your lab solution */
UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';


/* A small anonymous block PL/SQL program lets you fix this mistake */
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/


/* It should update four rows, and you can verify the update with the following query */
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';


/* This is for the beginning to create the initial procedure during iterative testing */
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/


/**************************************************************************************
* Step 1: The insert_contact procedure requires a formal parameter list. The procedure 
* should include all the values that you need to insert or discover to insert into the 
* member, contact, address, and telephone tables. The list of formal parameters is listed  * in the table below
**************************************************************************************/
CREATE OR REPLACE PROCEDURE insert_contact
        ( pv_first_name         VARCHAR2
        , pv_middle_name        VARCHAR2
        , pv_last_name          VARCHAR2
        , pv_contact_type       VARCHAR2
        , pv_account_number     VARCHAR2
        , pv_member_type        VARCHAR2
        , pv_credit_card_number VARCHAR2
        , pv_credit_card_type   VARCHAR2
        , pv_city               VARCHAR2
        , pv_state_province     VARCHAR2
        , pv_postal_code        VARCHAR2
        , pv_address_type       VARCHAR2
        , pv_country_code       VARCHAR2
        , pv_area_code          VARCHAR2
        , pv_telephone_number   VARCHAR2
        , pv_telephone_type     VARCHAR2
        , pv_user_name          VARCHAR2 ) IS PRAGMA AUTONOMOUS_TRANSACTION;
        
        -- Local variables, to leverage subquery assignments in INSERT statements.
        lv_address_type         NUMBER;
        lv_contact_type         NUMBER;
        lv_credit_card_type     NUMBER;
        lv_member_type          NUMBER;
        lv_telephone_type       NUMBER;

        lv_system_user_id       NUMBER;
        lv_time                 DATE := SYSDATE;
        
        
/* Write a dynamic SQL cursor that takes three parameters to return the common_lookup_id values into the program scope */
  CURSOR c
        ( cv_table_name         VARCHAR2
        , cv_column_name        VARCHAR2
        , cv_lookup_type        VARCHAR2) IS
        SELECT      common_lookup_id
            FROM    common_lookup
            WHERE   common_lookup_table =   cv_table_name
            AND     common_lookup_column =  cv_column_name
            AND     common_lookup_type =    cv_lookup_type;
BEGIN


/* Assign parameter values to local variables for nested assignments to DML subqueries */
--     lv_address_type := pv_address_type;
--     lv_contact_type := pv_contact_type;
--     lv_credit_card_type := pv_credit_card_type;
--     lv_member_type := pv_member_type;
--     lv_telephone_type := pv_telephone_type;

-- Member Table lookup
  FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
  END LOOP;
  dbms_output.put_line('Member_TYPE ['||lv_member_type|| ']');

-- Lookup for credit card type
  FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;

-- Address type lookup from Address Table
  FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP;

-- Lookup contact type for Contact Table
  FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
    lv_contact_type := i.common_lookup_id;
  END LOOP;

-- Get Lookup DI for telephone table
  FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP;

    -- Local Variable for Username
  SELECT system_user_id
  INTO   lv_system_user_id
  FROM   system_user
  WHERE  system_user_name = pv_user_name;

  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  
/* Insert the columns and values in this subquery */
    INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , last_name
        , first_name
        , middle_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
    VALUES
        ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_last_name
        , pv_first_name
        , pv_middle_name
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO address
    VALUES
        ( address_s1.NEXTVAL
        , contact_s1.CURRVAL
        , lv_address_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO telephone
    VALUES
        ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_contact;
/

SHOW ERRORS;


/* The insert_contact procedure requires a formal parameter list. The procedure should include all the values that you need to insert or discover to insert into the member, contact, address, and telephone tables */

-- Insert values for Charles Francis Xavier
BEGIN
  insert_contact
            ( pv_first_name => 'Charles'
            , pv_middle_name => 'Francis'
            , pv_last_name => 'Xavier'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000008'
            , pv_member_type => 'INDIVIDUAL'
            , pv_credit_card_number => '7777-6666-5555-4444'
            , pv_credit_card_type => 'DISCOVER_CARD'
            , pv_city => 'Milbridge'
            , pv_state_province => 'Maine'
            , pv_postal_code => '04658'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '111-1234'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 2');
END;
/

-- Insert values fpr Maura Jane Haggerty
BEGIN
  insert_contact( pv_first_name => 'Maura'
            , pv_middle_name => 'Jane'
            , pv_last_name => 'Haggerty'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000009'
            , pv_member_type => 'INDIVIDUAL'
            , pv_credit_card_number => '8888-7777-6666-5555'
            , pv_credit_card_type => 'MASTER_CARD'
            , pv_city => 'Bangor'
            , pv_state_province => 'Maine'
            , pv_postal_code => '04401'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '111-1234'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 2');
END;
/


/* This is test Case 1. Run the following verification query */
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

/* This is test Case 2. Run the following verification query */
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';


/**************************************************************************************
* Step 3: The insert_contact procedure requires a formal parameter list. The procedure 
* should include all the values that you need to insert or discover to insert into the 
* member, contact, address, and telephone tables. The list of formal parameters is listed  * in the table below
**************************************************************************************/

BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

CREATE OR REPLACE FUNCTION insert_contact
        ( pv_first_name         VARCHAR2
        , pv_middle_name        VARCHAR2
        , pv_last_name          VARCHAR2
        , pv_contact_type       VARCHAR2
        , pv_account_number     VARCHAR2
        , pv_member_type        VARCHAR2
        , pv_credit_card_number VARCHAR2
        , pv_credit_card_type   VARCHAR2
        , pv_city               VARCHAR2
        , pv_state_province     VARCHAR2
        , pv_postal_code        VARCHAR2
        , pv_address_type       VARCHAR2
        , pv_country_code       VARCHAR2
        , pv_area_code          VARCHAR2
        , pv_telephone_number   VARCHAR2
        , pv_telephone_type     VARCHAR2
        , pv_user_name          VARCHAR2 ) RETURN NUMBER 
        IS PRAGMA AUTONOMOUS_TRANSACTION;
        
  -- Local variables, to leverage subquery assignments in INSERT statements.
        lv_address_type         NUMBER;
        lv_contact_type         NUMBER;
        lv_credit_card_type     NUMBER;
        lv_member_type          NUMBER;
        lv_telephone_type       NUMBER;

        lv_system_user_id       NUMBER;
        lv_time                 DATE := SYSDATE;

  CURSOR c
        ( cv_table_name         VARCHAR2
        , cv_column_name        VARCHAR2
        , cv_lookup_type        VARCHAR2) IS
            SELECT common_lookup_id
            FROM   common_lookup
            WHERE  common_lookup_table = cv_table_name
            AND    common_lookup_column = cv_column_name
            AND    common_lookup_type = cv_lookup_type;

/* Use for-loops to access the dynamic cursors */
BEGIN
-- Member Table lookup
  FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
      dbms_output.put_line('Member_TYPE ['||lv_member_type|| ']');
  END LOOP;


-- Lookup for credit card type
  FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;

-- Address type lookup from Address Table
  FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP;

-- Lookup contact type for Contact Table
  FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
    lv_contact_type := i.common_lookup_id;
  END LOOP;

-- Get Lookup DI for telephone table
  FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP;


-- Local Variable for Username
  SELECT system_user_id
  INTO   lv_system_user_id
  FROM   system_user
  WHERE  system_user_name = pv_user_name;

-- Create a SAVEPOINT as starting point.
    INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , last_name
        , first_name
        , middle_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_last_name
        , pv_first_name
        , pv_middle_name
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO address
    VALUES
        ( address_s1.NEXTVAL
        , contact_s1.CURRVAL
        , lv_address_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO telephone
    VALUES
        ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

  COMMIT;

  RETURN 0;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 1;
END insert_contact;
/

-- Insert values for Harriet Mary McDonnell
BEGIN
  IF insert_contact( pv_first_name => 'Harriet'
                  , pv_middle_name => 'Mary'
                  , pv_last_name => 'McDonnell'
                  , pv_contact_type => 'CUSTOMER'
                  , pv_account_number => 'SLC-000010'
                  , pv_member_type => 'INDIVIDUAL'
                  , pv_credit_card_number => '9999-8888-7777-6666'
                  , pv_credit_card_type => 'VISA_CARD'
                  , pv_city => 'Orono'
                  , pv_state_province => 'Maine'
                  , pv_postal_code => '04469'
                  , pv_address_type => 'HOME'
                  , pv_country_code => '001'
                  , pv_area_code => '207'
                  , pv_telephone_number => '111-1234'
                  , pv_telephone_type => 'HOME'
                  , pv_user_name => 'DBA 2') = 0 THEN
    dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure');
  END IF;
END;
/

/* This is test Case 1. Run the following verification query */
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';


/**************************************************************************************
* Step 4: This step requires that you create a get_contact object table function, which requires a contact_obj SQL object type and a contact_tab SQL collection type 
**************************************************************************************/
CREATE OR REPLACE TYPE contact_obj IS OBJECT
                    ( first_name   VARCHAR2(30)
                    , middle_name  VARCHAR2(30)
                    , last_name    VARCHAR2(30));
                    /

CREATE OR REPLACE TYPE contact_tab IS TABLE OF contact_obj;
/


CREATE OR REPLACE FUNCTION get_contact RETURN CONTACT_TAB IS

  lv_counter PLS_INTEGER := 1;
  lv_contact_tab CONTACT_TAB := contact_tab();
  

CURSOR c IS
    SELECT first_name, middle_name, last_name
    FROM contact;

BEGIN
    FOR i IN c LOOP
      lv_contact_tab.EXTEND;
      lv_contact_tab(lv_counter) := contact_obj(i.first_name, i.middle_name, i.last_name);
      lv_counter := lv_counter + 1;
    END LOOP;

    RETURN lv_contact_tab;
END get_contact;
/

/* Test the function with the following query */
SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact);


BEGIN
  IF insert_contact( pv_first_name => 'Harriet'
                  , pv_middle_name => 'Mary'
                  , pv_last_name => 'McDonnell'
                  , pv_contact_type => 'CUSTOMER'
                  , pv_account_number => 'SLC-000010'
                  , pv_member_type => 'INDIVDUAL'
                  , pv_credit_card_number => '9999-8888-7777-6666'
                  , pv_credit_card_type => 'VISA_CARD'
                  , pv_city => 'Orono'
                  , pv_state_province => 'Maine'
                  , pv_postal_code => '04469'
                  , pv_address_type => 'HOME'
                  , pv_country_code => '001'
                  , pv_area_code => '207'
                  , pv_telephone_number => '111-1234'
                  , pv_telephone_type => 'HOME'
                  , pv_user_name => 'DBA 2') = 0 THEN
    dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
  END IF;
END;
/

-- Display any compilation errors.
SHOW ERRORS

-- Close log file.
SPOOL OFF
