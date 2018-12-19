/*
||  Name:           apply_plsql_lab8.sql
||  Student:        Hiram Todd
||  Date:           07 Nov 2018
||  Purpose:        Complete 325 Chapter 9 lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Run library scripts 
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

@/home/student/Data/cit325/lab7/apply_plsql_lab7.sql


-- Open log file.
SPOOL apply_plsql_lab8.txt

/************************************************************************************************
Create a contact_package package SPECIFICATION that holds overloaded insert_contact procedures. 
One procedure supports a user’s name and another supports a user’s ID; where the ID is a value 
from the system_user_id column of the system_user table. 
***********************************************************************************************/

CREATE OR REPLACE PACKAGE contact_package IS
	PROCEDURE insert_contact
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
            , pv_user_name          VARCHAR2 );

	PROCEDURE insert_contact
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
            , pv_user_id            NUMBER ); 
    END contact_package;
    /

DESC contact_package;


/*******************************************************************************
Inserts for Member Table 
*******************************************************************************/
	INSERT INTO system_user
	    VALUES ( 6
                ,'BONDSB'
                ,1
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'DBA')
                ,'Bonds'
                ,'Barry'
                ,'L'
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'SYSTEM_ADMIN')
                ,SYSDATE
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'SYSTEM_ADMIN')
                ,SYSDATE );

	INSERT INTO system_user
        VALUES ( 7
                ,'OWENSR'
                ,1
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'DBA')
                ,'Curry'
                ,'Wardell'
                ,'S'
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'SYSTEM_ADMIN')
                ,SYSDATE
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'SYSTEM_ADMIN')
                ,SYSDATE );

	
	INSERT INTO system_user
        VALUES ( -1
                ,'ANONYMOUS'
                ,1
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'DBA')
                ,''
                ,''
                ,''
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'SYSTEM_ADMIN')
                ,SYSDATE
                ,(SELECT c.common_lookup_id
                    FROM common_lookup c
                    WHERE c.common_lookup_type = 'SYSTEM_ADMIN')
                ,SYSDATE);

/*************************************** VERIFICATION! *************************************
You can confirm the inserts with the following query
********************************************************************************************/
COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

/************************************************************************************************
Create a contact_package package BODY that holds overloaded insert_contact procedures. 
One procedure supports a user’s name and another supports a user’s ID; where the ID is a value 
from the system_user_id column of the system_user table. 
***********************************************************************************************/
   CREATE OR REPLACE PACKAGE BODY contact_package IS
        PROCEDURE insert_contact
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
              , pv_user_name          VARCHAR2) is

                              -- Add local variables
              lv_contact_type         VARCHAR2(50);
              lv_member_type          VARCHAR2(50);
              lv_credit_card_type     VARCHAR2(50);
              lv_address_type         VARCHAR2(50);
              lv_telephone_type       VARCHAR2(50);
              lv_created_by           NUMBER; 
              lv_creation_date        DATE := SYSDATE;
              lv_member_id            NUMBER;

/* Write a dynamic SQL cursor that takes three parameters to return the common_lookup_id 
values into the program scope */
    CURSOR c
        (cv_table_name        VARCHAR2
        ,cv_column_name       VARCHAR2
        ,cv_lookup_type       VARCHAR2) is
        SELECT c.common_lookup_id
        FROM common_lookup c
        where c.common_lookup_table = cv_table_name
        and c.common_lookup_column = cv_column_name
        and c.common_lookup_type = cv_lookup_type;


/* Return Member */
	CURSOR m
		(cv_account_number VARCHAR2) is
		SELECT m.member_id
		FROM member m
		WHERE m.account_number = cv_account_number;

BEGIN

	SELECT s.system_user_id
	into  lv_created_by
	FROM   system_user s
	where s.system_user_name = pv_user_name;

   /* Assign a value when a row exists. */
    -- Member Table lookup
	FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := slice.common_lookup_id;
	END LOOP;

	-- Lookup contact type for Contact Table
	FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := slice.common_lookup_id;
	END LOOP;

	-- this is part of the member table
	FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := slice.common_lookup_id;
	END LOOP;

    -- Address type lookup from Address Table
	FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := slice.common_lookup_id;
	END LOOP;

    -- Get Lookup DI for telephone table
	FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := slice.common_lookup_id;
	END LOOP;

	-- SET the savepoint
	SAVEPOINT starting_point1;

	
/* Open CURSOR */
OPEN m(pv_account_number);
FETCH m INTO lv_member_id;

/* Inserts for Member Table */
IF m%NOTFOUND THEN
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
		, lv_created_by
		, lv_creation_date
		, lv_created_by
		, lv_creation_date );
END IF;

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
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date );

-- insert into address table

INSERT INTO address
        ( address_id
        , contact_id
        , address_type
        , city
        , state_province
        , postal_code
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
    VALUES
        ( address_s1.NEXTVAL
        , contact_s1.CURRVAL
        , lv_address_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date );

-- insert into telephone table

INSERT INTO telephone
        ( telephone_id
        , contact_id 
        , address_id
        , telephone_type
        , country_code
        , area_code
        , telephone_number
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( telephone_s1.NEXTVAl
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date);
     COMMIT;
     EXCEPTION 
     WHEN OTHERS THEN
     /* Until any partial results. */
                -- dbms_output.put_line('['||lv_debug||']['||lv_debug_id||']');
                -- dbms_output.put_line('ERROR IN PROCEDURE 1: '||SQLERRM);
     
      ROLLBACK TO starting_point1;
 END insert_contact;
 
 
/************************************************************************************************
Second Procedure
***********************************************************************************************/
 PROCEDURE insert_contact
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
         , pv_user_id            NUMBER ) is
         
     -- Add local variables
         lv_contact_type         VARCHAR2(50);
         lv_member_type          VARCHAR2(50);
         lv_credit_card_type     VARCHAR2(50);
         lv_address_type         VARCHAR2(50);
         lv_telephone_type       VARCHAR2(50);
     -- If no user_id is passed in, SET default to -1
         lv_created_by           NUMBER:= nvl(pv_user_id, -1); 
         lv_creation_date        DATE := SYSDATE;
         lv_member_id            NUMBER;

/* Local cursor declaration */
  CURSOR c
       ( cv_table_name        VARCHAR2
       , cv_column_name       VARCHAR2
       , cv_lookup_type       VARCHAR2 ) is
       SELECT c.common_lookup_id
       FROM common_lookup c
       where c.common_lookup_table = cv_table_name
       and c.common_lookup_column = cv_column_name
       and c.common_lookup_type = cv_lookup_type;

/* Member Cursor */
  CURSOR m
       (cv_account_number VARCHAR2) is
       SELECT m.member_id
       FROM member m
       WHERE m.account_number = cv_account_number;



BEGIN
/* Assign a value when a row exists. */
    -- Member Table lookup
	FOR slice IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := slice.common_lookup_id;
	END LOOP;

	-- Lookup contact type for Contact Table
	FOR slice IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := slice.common_lookup_id;
	END LOOP;

	-- Lookup for credit card type
	FOR slice IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := slice.common_lookup_id;
	END LOOP;

    -- Address type lookup from Address Table
	FOR slice IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := slice.common_lookup_id;
	END LOOP;

    -- Get Lookup DI for telephone table
	FOR slice IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := slice.common_lookup_id;
	END LOOP;
    
        -- Local Variable for Username
            -- SELECT system_user_id INTO lv_system_user_id -- lv_created_by
            -- FROM   system_user
            -- WHERE  system_user_name = pv_user_name;

	-- SET the savepoint
	SAVEPOINT starting_point2;

    -- Open Cursor
    OPEN m(pv_account_number);
    FETCH m INTO lv_member_id;

/* If no member found, add new member */
IF m%NOTFOUND THEN

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
            , lv_created_by
            , lv_creation_date
            , lv_created_by
            , lv_creation_date );
END IF;

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
			, lv_created_by
			, lv_creation_date
			, lv_created_by
			, lv_creation_date );


-- insert into address table

        INSERT INTO address
                ( address_id
                 , contact_id
                 , address_type
                 , city
                 , state_province
                 , postal_code
                 , created_by
                 , creation_date
                 , last_updated_by
                 , last_update_date)
             VALUES
                ( address_s1.NEXTVAL
                , contact_s1.CURRVAL
                , lv_address_type
                , pv_city
                , pv_state_province
                , pv_postal_code
                , lv_created_by
                , lv_creation_date
                , lv_created_by
                , lv_creation_date );


-- insert into telephone table

     INSERT INTO telephone
			( telephone_id
			, contact_id 
			, address_id
			, telephone_type
			, country_code
			, area_code
			, telephone_number
			, created_by
			, creation_date
			, last_updated_by
			, last_update_date )
     VALUES
			( telephone_s1.NEXTVAl
			, contact_s1.CURRVAL
			, address_s1.CURRVAL
			, lv_telephone_type
			, pv_country_code
			, pv_area_code
			, pv_telephone_number
			, lv_created_by
			, lv_creation_date
			, lv_created_by
			, lv_creation_date);
     COMMIT;
							
     EXCEPTION 
         WHEN OTHERS THEN
          ROLLBACK TO starting_point2;
     END insert_contact;     
     END contact_package;
     /
LIST
SHOW ERRORS

/*******************************************************************************************
The insert_contact procedure requires a formal parameter list. The procedure should include 
all the values that you need to insert or discover to insert into the member, contact, 
address, and telephone tables
********************************************************************************************/
BEGIN
    contact_package.insert_contact
            ( pv_first_name => 'Charlie'
            , pv_middle_name => ''
            , pv_last_name => 'Brown'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000011'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '');


    contact_package.insert_contact
            ( pv_first_name => 'Peppermint'
            , pv_middle_name => ''
            , pv_last_name => 'Patty'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000011'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => '' 
            , pv_user_id => '' );

    contact_package.insert_contact(pv_first_name => 'Sally'
            ( pv_first_name => 'Sally'
            , pv_middle_name => ''
            , pv_last_name => 'Brown'
            , pv_contact_type => 'CUSTOMER'
            , pv_account_number => 'SLC-000011'
            , pv_member_type => 'GROUP'
            , pv_credit_card_number => '8888-6666-8888-4444'
            , pv_credit_card_type => 'VISA_CARD'
            , pv_city => 'Lehi'
            , pv_state_province => 'Utah'
            , pv_postal_code => '84043'
            , pv_address_type => 'HOME'
            , pv_country_code => '001'
            , pv_area_code => '207'
            , pv_telephone_number => '877-4321'
            , pv_telephone_type => 'HOME'
            , pv_user_name => 'DBA 3' 
            , pv_user_id => '6');
END;
/

-- LIST
-- SHOW ERRORS


/*************************************** VERIFICATION! *************************************
After you call the overloaded insert_contact procedures three times, you 
should be able to run the following verification query
********************************************************************************************/
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
WHERE  c.last_name IN ('Brown','Patty');


/***********************************************************************************************
Recreate the SPECIFICATION package
************************************************************************************************/
CREATE OR REPLACE PACKAGE contact_package IS
	FUNCTION insert_contact
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
            , pv_user_name          VARCHAR2) RETURN NUMBER;

	FUNCTION insert_contact
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
            , pv_user_id            NUMBER) RETURN NUMBER; 
    END contact_package;
    /

/***********************************************************************************************
Recreate the BODY package
************************************************************************************************/
CREATE OR REPLACE PACKAGE BODY contact_package IS
	FUNCTION insert_contact
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
            , pv_user_name          VARCHAR2) RETURN NUMBER is

            -- Local variables, to leverage subquery assignments in INSERT statements
            lv_contact_type          VARCHAR2(50);
            lv_member_type           VARCHAR2(50);
            lv_credit_card_type      VARCHAR2(50);
            lv_address_type          VARCHAR2(50);
            lv_telephone_type        VARCHAR2(50);
            lv_created_by            NUMBER; 
            lv_creation_date         DATE := SYSDATE;
            lv_member_id             NUMBER;
            lv_retval                NUMBER := 0;

/* Write a dynamic SQL cursor that takes three parameters to return the common_lookup_id 
values into the program scope */
	CURSOR c
		( cv_table_name          VARCHAR2
		,cv_column_name          VARCHAR2
		,cv_lookup_type          VARCHAR2 ) is
            SELECT  c.common_lookup_id
            FROM    common_lookup c
            WHERE   c.common_lookup_table = cv_table_name
            AND     c.common_lookup_column = cv_column_name
            AND     c.common_lookup_type = cv_lookup_type;



/* Return Member_id */
	CURSOR m
		(cv_account_number VARCHAR2) is
		SELECT m.member_id
		FROM member m
		WHERE m.account_number = cv_account_number;



BEGIN	
	SELECT s.system_user_id
	INTO  lv_created_by
	FROM   system_user s
	WHERE s.system_user_name = pv_user_name;

    /* Assign a value when a row exists. */
    -- Member Table lookup
	FOR slice IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := slice.common_lookup_id;
	END LOOP;

	-- Lookup contact type for Contact Table
	FOR slice IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := slice.common_lookup_id;
	END LOOP;

	-- Lookup for credit card type
	FOR slice IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := slice.common_lookup_id;
	END LOOP;

    -- Address type lookup from Address Table
	FOR slice IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := slice.common_lookup_id;
	END LOOP;

    -- Get Lookup DI for telephone table
	FOR slice IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := slice.common_lookup_id;
	END LOOP;


    -- Create a SAVEPOINT as a starting point.
	SAVEPOINT starting_point1;

				
    -- Open CURSOR
	OPEN m(pv_account_number);
	FETCH m INTO lv_member_id;

/* If no member found, add new member */
IF m%NOTFOUND THEN
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
		, lv_created_by
		, lv_creation_date
		, lv_created_by
		, lv_creation_date );
END IF;

-- insert into address table
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
		, lv_created_by
		, lv_creation_date
		, lv_created_by
		, lv_creation_date );

-- insert into address table
    INSERT INTO address
		( address_id
		, contact_id
		, address_type
		, city
		, state_province
		, postal_code
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
    VALUES
		( address_s1.NEXTVAL
		, contact_s1.CURRVAL
		, lv_address_type
		, pv_city
		, pv_state_province
		, pv_postal_code
		, lv_created_by
		, lv_creation_date
		, lv_created_by
		, lv_creation_date );

-- insert into telephone table
    INSERT INTO telephone
		( telephone_id
		, contact_id 
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date )
    VALUES
		( telephone_s1.NEXTVAl
		, contact_s1.CURRVAL
		, address_s1.CURRVAL
		, lv_telephone_type
		, pv_country_code
		, pv_area_code
		, pv_telephone_number
		, lv_created_by
		, lv_creation_date
		, lv_created_by
		, lv_creation_date);
    COMMIT;
RETURN lv_retval;
								
EXCEPTION 
	WHEN OTHERS THEN
	 ROLLBACK TO starting_point1;
	 Return 1;
END insert_contact;

/***********************************************************************************************
Create a BODY contact_package function
************************************************************************************************/
CREATE PACKAGE BODY contact_package IS
    FUNCTION insert_contact
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
        , pv_user_id            NUMBER) RETURN NUMBER is

    -- Add local variables
        lv_contact_type          VARCHAR2(50);
        lv_member_type           VARCHAR2(50);
        lv_credit_card_type      VARCHAR2(50);
        lv_address_type          VARCHAR2(50);
        lv_telephone_type        VARCHAR2(50);
        
    -- If no user_id is passed in, SET default to -1
        lv_created_by            NUMBER := nvl(pv_user_id, -1); 
        lv_creation_date         DATE := SYSDATE;
        lv_member_id             NUMBER;
        lv_retval                NUMBER := 0;

    /* Write a dynamic SQL cursor that takes three parameters to return the common_lookup_id 
    values into the program scope */
	CURSOR c
		(cv_table_name        VARCHAR2
		,cv_column_name       VARCHAR2
		,cv_lookup_type       VARCHAR2) is
		SELECT c.common_lookup_id
		FROM common_lookup c
		where c.common_lookup_table = cv_table_name
		and c.common_lookup_column = cv_column_name
		and c.common_lookup_type = cv_lookup_type;

    /* Member cursor */
	CURSOR m
		(cv_account_number VARCHAR2) is
		SELECT m.member_id
		FROM member m
		WHERE m.account_number = cv_account_number;



BEGIN
/* Assign a value when provided for pv_user_id. */
    -- Get the member_type ID value
	FOR slice IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := slice.common_lookup_id;
	END LOOP;

	-- Get the contact_type ID value
	FOR slice IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := slice.common_lookup_id;
	END LOOP;

	-- Get the credit_card_type ID value
	FOR slice IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := slice.common_lookup_id;
	END LOOP;

    -- Get the address_type ID value
	FOR slice IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := slice.common_lookup_id;
	END LOOP;

    -- Get the telephone_type ID value
	FOR slice IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := slice.common_lookup_id;
	END LOOP;

	-- SET the savepoint
	SAVEPOINT starting_point2;

    -- For Get Member Cursor
    OPEN m(pv_account_number);
    FETCH m INTO lv_member_id;

    -- Insert into Member Table
		IF m%NOTFOUND THEN
        
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
                , lv_created_by
                , lv_creation_date
                , lv_created_by
                , lv_creation_date );
            END IF;

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
				, lv_created_by
				, lv_creation_date
				, lv_created_by
				, lv_creation_date );


-- insert into address table

            INSERT INTO address
				( address_id
				, contact_id
				, address_type
				, city
				, state_province
				, postal_code
				, created_by
				, creation_date
				, last_updated_by
				, last_update_date)
            VALUES
				( address_s1.NEXTVAL
				, contact_s1.CURRVAL
				, lv_address_type
				, pv_city
				, pv_state_province
				, pv_postal_code
				, lv_created_by
				, lv_creation_date
				, lv_created_by
				, lv_creation_date );


-- insert into telephone table

            INSERT INTO telephone
				( telephone_id
				, contact_id 
				, address_id
				, telephone_type
				, country_code
				, area_code
				, telephone_number
				, created_by
				, creation_date
				, last_updated_by
				, last_update_date )
            VALUES
				( telephone_s1.NEXTVAl
				, contact_s1.CURRVAL
				, address_s1.CURRVAL
				, lv_telephone_type
				, pv_country_code
				, pv_area_code
				, pv_telephone_number
				, lv_created_by
				, lv_creation_date
				, lv_created_by
				, lv_creation_date);
            COMMIT;
            
            RETURN lv_retval;
								
            EXCEPTION 
                WHEN OTHERS THEN.
                /* Until any partial results. */
                -- dbms_output.put_line('['||lv_debug||']['||lv_debug_id||']');
                -- dbms_output.put_line('ERROR IN PROCEDURE 1: '||SQLERRM);
                
                 ROLLBACK TO starting_point2;
                 RETURN 1;
END insert_contact;     
END contact_package;
/
LIST
SHOW ERRORS


/*******************************************************************************************
The insert_contact procedure requires a formal parameter list. The procedure should include 
all the values that you need to insert or discover to insert into the member, contact, 
address, and telephone tables
********************************************************************************************/
/* Insert values for Shirley Partridge in insert_contact */
BEGIN
    IF contact_package.insert_contact
                ( pv_first_name => 'Shirley'
				, pv_middle_name => ''
				, pv_last_name => 'Partridge'
				, pv_contact_type => 'CUSTOMER'
				, pv_account_number => 'SLC-000012'
				, pv_member_type => 'GROUP'
				, pv_credit_card_number => '8888-6666-8888-4444'
				, pv_credit_card_type => 'VISA_CARD'
                , pv_city => 'Lehi'
				, pv_state_province => 'Utah'
				, pv_postal_code => '84043'
				, pv_address_type => 'HOME'
				, pv_country_code => '001'
				, pv_area_code => '207'
				, pv_telephone_number => '877-4321'
				, pv_telephone_type => 'HOME'
				, pv_user_name => 'DBA 3') = 0 THEN
            dbms_output.put_line('Insert contact succeeds.');
    END IF;

/* Insert values for Keith Partridge in insert_contact */
    IF contact_package.insert_contact
                ( pv_first_name => 'Keith'
				, pv_middle_name => ''
				, pv_last_name => 'Partridge'
				, pv_contact_type => 'CUSTOMER'
				, pv_account_number => 'SLC-000012'
				, pv_member_type => 'GROUP'
				, pv_credit_card_number => '8888-6666-8888-4444'
				, pv_credit_card_type => 'VISA_CARD'
				, pv_city => 'Lehi'
				, pv_state_province => 'Utah'
				, pv_postal_code => '84043'
				, pv_address_type => 'HOME'
				, pv_country_code => '001'
				, pv_area_code => '207'
				, pv_telephone_number => '877-4321'
				, pv_telephone_type => 'HOME'
				, pv_user_id => 6) = 0 THEN
            dbms_output.put_line('Insert contact succeeds.');
    END IF;

/* Insert values for Laurie Partridge in insert_contact */
    IF contact_package.insert_contact
                ( pv_first_name => 'Laurie'
				, pv_middle_name => ''
				, pv_last_name => 'Partridge'
				, pv_contact_type => 'CUSTOMER'
				, pv_account_number => 'SLC-000012'
				, pv_member_type => 'GROUP'
				, pv_credit_card_number => '8888-6666-8888-4444'
				, pv_credit_card_type => 'VISA_CARD'
				, pv_city => 'Lehi'
				, pv_state_province => 'Utah'
				, pv_postal_code => '84043'
				, pv_address_type => 'HOME'
				, pv_country_code => '001'
				, pv_area_code => '207'
				, pv_telephone_number => '877-4321'
				, pv_telephone_type => 'HOME'
				, pv_user_id => -1 ) = 0 THEN
            dbms_output.put_line('Insert contact succeeds.');
    END IF;
END;
/


/*************************************** VERIFICATION! *************************************
After you call the overloaded insert_contact function three times, you should be able to run 
the following verification query
********************************************************************************************/
COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
				 WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
			 END
||     c.last_name AS full_name
,      c.created_by 
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

spool off