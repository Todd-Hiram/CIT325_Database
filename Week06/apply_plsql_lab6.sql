/*
||  Name:    apply_plsql_lab6_prep.sql
||  Date:    October 24, 2018
||  Purpose: Complete 325 Chapter 6 lab
||  Dependencies: Run the Oracle Database 12c PL/SQL Programming setup programs
*/

-- @/home/student/Data/cit325/oracle/lab6/apply_plsql_lab6_pre.sql
@/home/student/Data/cit325/lab6/apply_plsql_lab6_pre.sql

/*Open your log file and make sure the extension is ".log"*/
SPOOL apply_plsql_lab6.log


DECLARE
/* Declare the local error handling variables. */
  lv_local_object  VARCHAR2(30) := 'ANONYMOUS';
  lv_local_module  VARCHAR2(30) := 'LOCAL';
 
BEGIN
  insert_item( pv_item_barcode => 'B01LTHWTHO'
             , pv_item_type => 'DVD'
             , pv_item_title => 'Inferno'
             , pv_item_rating => 'PG-13'
             , pv_item_rating_agency => 'MPAA'
             , pv_item_release_date => '24-JAN-2017' );

EXCEPTION
  WHEN OTHERS THEN
    record_errors( object_name => lv_local_object
                 , module_name => lv_local_module
                 , sqlerror_code => 'ORA'||SQLCODE
                 , sqlerror_message => SQLERRM
                 , user_error_message => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    RAISE;
END;
/

/* You can use the following to query results */
COL item_barcode FORMAT A10 HEADING "Item|Barcode"
COL item_title   FORMAT A48 HEADING "Item Title"
COL release_date FORMAT A12 HEADING "Item|Release|Date"
SELECT   i.item_barcode
,        i.item_title
,        i.item_release_date AS release_date
FROM   item i
WHERE  REGEXP_LIKE( i.item_title,'^.*bourne.*$','i' )
OR     REGEXP_LIKE( i.item_title,'^.*inferno.*$','i' );

/* Test a call to the insert_items procedure for a set of entries after you’ve added the exception 
handling block and made the procedure an autonomous transaction */
DECLARE
/* Declare the local error handling variables. */
  lv_local_object  VARCHAR2(30) := 'ANONYMOUS';
  lv_local_module  VARCHAR2(30) := 'LOCAL';
 
/* Create a collection. */
  lv_items  ITEM_TAB :=
    item_tab(
        item_obj( item_barcode => 'B0084IG7KC'
                , item_type => 'BLU-RAY'
                , item_title => 'The Hunger Games'
                , item_subtitle => NULL
                , item_rating => 'PG-13'
                , item_rating_agency => 'MPAA'
                , item_release_date => '18-AUG-2012')
      , item_obj( item_barcode => 'B008JFUS8M'
                , item_type => 'BLU-RAY'
                , item_title => 'The Hunger Games: Catching Fire'
                , item_subtitle => NULL
                , item_rating => 'PG-13'
                , item_rating_agency => 'MPAA'
                , item_release_date => '07-MAR-2014'));
BEGIN

/* Call a element processing procedure. */
  insert_items(lv_items);
 
EXCEPTION
  WHEN OTHERS THEN
    record_errors( object_name => lv_local_object
                 , module_name => lv_local_module
                 , sqlerror_code => 'ORA'||SQLCODE
                 , sqlerror_message => SQLERRM
                 , user_error_message => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

/* This code is used to query results */
COL item_barcode FORMAT A10 HEADING "Item|Barcode"
COL item_title   FORMAT A36 HEADING "Item Title"
COL release_date FORMAT A12 HEADING "Item|Release|Date"
SELECT   i.item_barcode
,        i.item_title
,        i.item_release_date AS release_date
FROM     item i
WHERE    REGEXP_LIKE(i.item_title,'^.*bourne.*$','i')
OR       REGEXP_LIKE(i.item_title,'^.*inferno.*$','i')
OR       REGEXP_LIKE(i.item_title,'^.*hunger.*$','i')
ORDER BY CASE
           WHEN REGEXP_LIKE(i.item_title,'^.*bourne.*$','i')  THEN 1
           WHEN REGEXP_LIKE(i.item_title,'^.*hunger.*$','i')  THEN 2
           WHEN REGEXP_LIKE(i.item_title,'^.*inferno.*$','i') THEN 3
         END
,        i.item_release_date;

/* Test a second call to the insert_items procedure for a set of entries. The first one complies with 
business rule that synchronizes foreign key values and the second one doesn’t */
DECLARE
  /* Declare the local error handling variables. */
  lv_local_object  VARCHAR2(30);
  lv_local_module  VARCHAR2(30);
  -- lv_local_object  VARCHAR2(30) := 'ANONYMOUS';
  -- lv_local_module  VARCHAR2(30) := 'LOCAL';

  /* Create a collection. */
  lv_items  ITEM_TAB :=
    item_tab(
        item_obj( item_barcode => 'B00PYLT4YI'
                , item_type => 'BLU-RAY'
                , item_title => 'The Hunger Games: Mockingjay Part 1'
                , item_subtitle => NULL
                , item_rating => 'PG-13'
                , item_rating_agency => 'MPAA'
                , item_release_date => '06-MAR-2015')
      , item_obj( item_barcode => 'B0189HKE5Q'
                , item_type => 'XBOX'
                , item_title => 'The Hunger Games: Mockingjay Part 2'
                , item_subtitle => NULL
                , item_rating => 'PG-13'
                , item_rating_agency => 'MPAA'
                , item_release_date => '22-MAR-2016'));
BEGIN
  /* Call a element processing procedure. */
  insert_items(lv_items);
 
EXCEPTION
  WHEN OTHERS THEN
    record_errors(object_name => lv_local_object
                 ,module_name => lv_local_module
                 , sqlerror_code => 'ORA'||SQLCODE
                 ,sqlerror_message => SQLERRM
                 ,user_error_message => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

/* You can use the following to query results */
COL item_barcode FORMAT A10 HEADING "Item|Barcode"
COL item_title   FORMAT A36 HEADING "Item Title"
COL release_date FORMAT A12 HEADING "Item|Release|Date"
SELECT   i.item_barcode
,        i.item_title
,        i.item_release_date AS release_date
FROM     item i
WHERE    REGEXP_LIKE(i.item_title,'^.*bourne.*$','i')
OR       REGEXP_LIKE(i.item_title,'^.*inferno.*$','i')
OR       REGEXP_LIKE(i.item_title,'^.*hunger.*$','i')
ORDER BY CASE
           WHEN REGEXP_LIKE(i.item_title,'^.*bourne.*$','i')  THEN 1
           WHEN REGEXP_LIKE(i.item_title,'^.*hunger.*$','i')  THEN 2
           WHEN REGEXP_LIKE(i.item_title,'^.*inferno.*$','i') THEN 3
         END
,        i.item_release_date;

/* The last thing you need to check is what has been written to the nc_error table. 
You can use the following query to check the nc_error table */
COL error_id        FORMAT 999999  HEADING "Error|ID #"
COL object_name     FORMAT A20     HEADING "Object Name"
COL module_name     FORMAT A20     HEADING "Module Name"
COL sqlerror_code   FORMAT A10   HEADING "Error|ID #"
SELECT   ne.error_id
,        ne.object_name
,        ne.module_name
,        ne.sqlerror_code
FROM     nc_error ne
ORDER BY 1 DESC;

-- Close your log file.
SPOOL OFF
QUIT;