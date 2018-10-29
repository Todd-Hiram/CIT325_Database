--Having the SET SERVEROUTPUT ON helps to test things through the terminal, lot easier than continually opening log files
SET SERVEROUTPUT ON

BEGIN
    dbms_output.put_line('===============================');
    dbms_output.put_line('      PART 1 or Example A      ');
    dbms_output.put_line('===============================');
END;
/

-- Drop pre-existing object type. Once you create something you should usually always drop it, especially in the labs.
-- Here we are droping my_record which is created below in the "CREATE OR REPLACE" block
DROP TYPE my_record;

-- Creates an object type.
-- Here we are CREATING or REPLACING A TYPE
-- Here we are letting the computer know that we are calling this OBJECT TYPE my_record and are giving this object type three properties
CREATE OR REPLACE
	TYPE my_record IS OBJECT
	( my_name    VARCHAR2(40)  			--This is a property "my_name" and were are declaring wht type of data this is or the data type which is VARCHAR2()
	, my_city    VARCHAR2(30)			--This is a property "my_city" and were are declaring wht type of data this is or the data type which is VARCHAR2()
	, my_state   VARCHAR2(30));			--This is a property "my_state" and were are declaring wht type of data this is or the data type which is VARCHAR2()
/

DECLARE
	-- Create a cursor.
	CURSOR c IS
		SELECT CASE WHEN c.middle_name IS NOT NULL OR LENGTH(c.middle_name) > 0 THEN
					c.last_name || ', ' || c.first_name || ' ' || c.middle_name
				ELSE
					c.last_name || ', ' || c.first_name
				END AS full_name		-- Here is where the c.last_name, c.first_name, and c.middle_name come together
			, a.city
			, a.state_province AS state
		FROM contact c JOIN address a 	-- Here we give alias 'c' to the Contact Table and alias 'a' to the 
		ON c.contact_id = a.contact_id; -- Address Table. This is also where we JOIN both the contact and address tables

	--Create a collection of MY_RECORD
	lv_record MY_RECORD;				-- Here is where we create a collection of MY-RECORD, or in other words we are 
										-- creating a collection of the object. Here we create a collection for MY_RECORD
										-- This will be used later on somewhere in Example B and C

BEGIN									
  FOR i IN c LOOP						-- This block tells the computer or the compiler to loop the CURSOR above and what
										-- comes back from the database, we now want to loop through the RECORDS

  	-- i = {full_name, city, state}		-- 'i' usually equal a number, but the 'i' here in this line not longer equals a
	  									-- number but equals an object and those are full_name, city, and state
										-- This is not being used here but is just to show that 'i' here is an object
    dbms_output.put_line(i.full_name);
/*
    lv_record.my_name := i.last_name || ', ' || i.first_name;
    IF LENGTH(i.middle_name) > 0 THEN
      lv_record.my_name := lv_record.my_name || ' ' || i.middle_name;
    END IF;
    lv_record.my_city := i.city;
    dbms_output.put_line(lv_record.my_name|| ', '||lv_record.my_city);
*/
  END LOOP;
END;
/

BEGIN
    dbms_output.put_line('===============================');
    dbms_output.put_line('      PART 2 or Example B      ');
    dbms_output.put_line('===============================');
END;
/

-- Drop pre-existing object type.
DROP TYPE my_record;

-- Creates an object type.
CREATE OR REPLACE
  TYPE my_record IS OBJECT
  ( my_name    VARCHAR2(40)
  , my_city    VARCHAR2(30)
  , my_state   VARCHAR2(30));
/

DECLARE
	-- Create a cursor.
	CURSOR c IS
		SELECT CASE WHEN c.middle_name IS NOT NULL OR LENGTH(c.middle_name) > 0 THEN
					c.last_name || ', ' || c.first_name || ' ' || c.middle_name
				ELSE
					c.last_name || ', ' || c.first_name
				END AS full_name
			, a.city
			, a.state_province AS state
		FROM contact c JOIN address a
		ON c.contact_id = a.contact_id;

	--Create a collection of MY_RECORD
	lv_record MY_RECORD;
BEGIN
	FOR i IN c LOOP
		/* Two things:
		||  1. Constructs an instance of the object.
		||  2. Assigns the instance to the variable of the object type.
		*/
		lv_record := my_record( my_name => i.full_name 		-- Here is where we are using the lv.record that we declared,
		                      , my_city => i.city			-- that collection of MY_RECORD in Example A. Here is where we
		                      , my_state => i.state );		-- are passing in the results that we got from the CURSOR
		dbms_output.put_line(lv_record.my_name);
	END LOOP;
END;
/

BEGIN
    dbms_output.put_line('===============================');
    dbms_output.put_line('      PART 3 or Example C      ');
    dbms_output.put_line('===============================');
END;
/

-- Drop pre-existing object type.
DROP TYPE my_record;

-- Creates an object type.
CREATE OR REPLACE
  TYPE my_record IS OBJECT
  ( my_name    VARCHAR2(40)
  , my_city    VARCHAR2(30)
  , my_state   VARCHAR2(30));
/

-- Drop pre-existing table and re-create it
DROP TABLE my_records; 
CREATE TABLE my_records
( my_name    VARCHAR2(40)
, my_city    VARCHAR2(30)
, my_state   VARCHAR2(30));

DECLARE
	-- Create a cursor.
	CURSOR c IS
		SELECT CASE WHEN c.middle_name IS NOT NULL OR LENGTH(c.middle_name) > 0 THEN
					c.last_name || ', ' || c.first_name || ' ' || c.middle_name
				ELSE
					c.last_name || ', ' || c.first_name
				END AS full_name
			, a.city
			, a.state_province AS state
		FROM contact c JOIN address a
		ON c.contact_id = a.contact_id;

	--Create a collection of MY_RECORD
	lv_record MY_RECORD;
BEGIN
	FOR i IN c LOOP
		/* Two things:
		||  1. Constructs an instance of the object.
		||  2. Assigns the instance to the variable of the object type.
		*/
		lv_record := my_record( my_name => i.full_name
		                      , my_city => i.city
		                      , my_state => i.state );
		INSERT INTO my_records
		( my_nameb 
		, my_city
		, my_state )
		VALUES
		( lv_record.my_name
		, lv_record.my_city
		, lv_record.my_state );
	END LOOP;
END;
/

SET PAGESIZE 999
COL my_name FORMAT A24
COL my_city FORMAT A14
COL my_state FORMAT A12
SELECT * FROM my_records;