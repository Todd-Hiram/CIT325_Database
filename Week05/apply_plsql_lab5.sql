/*
||  Name:          apply_plsql_lab5.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 6 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open a log file here.
SPOOL apply_plsql_lab5.txt

-- ... insert your solution here ...
SET SERVEROUTPUT ON
SET VERIFY ON

-- Create from the rating_agency table a rating_agency sequence starting with a value of 1001
DROP SEQUENCE rating_agency_s;
CREATE SEQUENCE rating_agency_s START WITH 1001;

-- Here we create the rating_agency table by using the data from the ITEM table
CREATE TABLE rating_agency AS
    SELECT  rating_agency_s.NEXTVAL AS my_rating_agency_id
    ,       il.item_rating          AS my_rating
    ,       il.item_rating_agency   AS my_rating_agency
    FROM    (SELECT DISTINCT
                i.item_rating
            ,   i.item_rating_agency
            FROM item i) il;

-- Here we add a new RATING_AGENCY_ID column to the ITEM table.
ALTER TABLE item
ADD rating_agency_id NUMBER;

-- Create the object type here
CREATE OR REPLACE
  TYPE my_record IS OBJECT
  ( my_rating_agency_id    NUMBER
  , my_rating              VARCHAR2(8)
  , my_rating_agency       VARCHAR2(4));
/

-- Create the my_records table collection here
CREATE OR REPLACE
    TYPE my_records IS TABLE OF my_record;
/

/****************************************** PL/SQL Block ****************************************************
Here we start PL/SQL anonymouse block by first declaring the local variables with their data types
From the DECLARE to the END of the BEGIN block is all PL/SQL */
DECLARE
-- Creating a cursor here. This CURSOR grabs the rows from the rating_agency table created above in SQL
	CURSOR c IS
        SELECT my_rating, my_rating_agency_id, my_rating_agency FROM rating_agency;

-- Here is the empty collection
        lv_my_record my_record;
        lv_my_records my_records;

BEGIN 
lv_my_records := my_records();

-- Here is the FOR loop for the CURSOR to assign values in the collection
    FOR i IN c LOOP
            lv_my_record := my_record( my_rating_agency_id => i.my_rating_agency_id
                                , my_rating => i.my_rating
                                , my_rating_agency => i.my_rating_agency );    
            lv_my_records.EXTEND;
            lv_my_records(lv_my_records.COUNT) := my_record( lv_my_record.my_rating_agency_id
            , lv_my_record.my_rating
            , lv_my_record.my_rating_agency );
    END LOOP;
-- dbms_output.put_line(lv_my_records.COUNT);

--  This FOR loop updates the statement
    FOR g IN 1..lv_my_records.COUNT LOOP
        UPDATE item SET rating_agency_id = lv_my_records(g).my_rating_agency_id
        WHERE item_rating = lv_my_records(g).my_rating
        AND item_rating_agency = lv_my_records(g).my_rating_agency;        
    END LOOP;
END;
/
/***************************************** END of PL/SQL Block ************************************************/

-- Verification
SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;


SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- Here we check the contents after creating the table
SELECT * FROM rating_agency;

-- Close log file.
SPOOL OFF

