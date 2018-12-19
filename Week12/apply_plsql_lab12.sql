/*
||  Name:          apply_plsql_lab12.sql
||  Date:          03 Dec 2018
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run the library files here.
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL apply_plsql_lab12.txt

-- ... insert your solution here ...
/************************** Step 1 *******************************
Create the item_obj object type, a item_tab collection object 
type, and item_list function.
*****************************************************************/
DROP TYPE item_obj FORCE;
DROP TYPE item_tab;
DROP FUNCTION item_list;

-- You create the item_obj object type:
CREATE OR REPLACE
  TYPE item_obj IS OBJECT
        ( title         VARCHAR2(60)
        , subtitle      VARCHAR2(60)
        , rating        VARCHAR2(8) 
        , release_date  DATE );
/

-- Create the item_tab object type
DESC item_obj

-- You create the item_obj object collection type:
CREATE OR REPLACE
  TYPE item_tab IS TABLE of item_obj;
/

-- Create the item_tab object type
DESC item_tab

/******************************************************************
After you have created the item_obj object type and item_tab 
collection object type, you create a item_list function
*******************************************************************/
CREATE OR REPLACE
  FUNCTION item_list
  ( pv_start_date DATE
  , pv_end_date   DATE DEFAULT (TRUNC(SYSDATE) + 1) ) RETURN item_tab IS -- We are passing the parameter values in the parenthesis
 
    /* Declare a record type. */
    TYPE item_rec IS RECORD
    ( title        VARCHAR2(60)
    , subtitle     VARCHAR2(60)
    , rating       VARCHAR2(8)
    , release_date DATE);
 
    /* Declare reference cursor for an NDS cursor. (Ref. Cursor) */
    item_cur   SYS_REFCURSOR;
 
    /* Declare a item row for output from an NDS cursor. We build the cursor's variables here */
    item_row   ITEM_REC;
    item_set   ITEM_TAB := item_tab();
 
    /* Declare dynamic statement. */
    stmt  VARCHAR2(2000);
  BEGIN
     /* Create a dynamic statement. */
    stmt := 'SELECT item_title AS title
            , item_subtitle AS subtitle
            , item_rating AS rating
            , item_release_date AS release_date '
         || 'FROM   item '
         || 'WHERE  item_rating_agency = ''MPAA'''
         || 'AND  item_release_date > :start_date AND item_release_date < :end_date';
 
    dbms_output.put_line( stmt );

    /* Open and read dynamic cursor. */
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP
      /* Fetch the cursror into a item row. */
      FETCH item_cur INTO item_row;
      EXIT WHEN item_cur%NOTFOUND;
 
      /* Extend space and assign a value collection. */      
      item_set.EXTEND;
      item_set(item_set.COUNT) :=
        item_obj( title  => item_row.title
                , subtitle => item_row.subtitle
                , rating   => item_row.rating
                , release_date => item_row.release_date );
    END LOOP;
 
    /* Return item set back to the calling program. */
    RETURN item_set;
  END item_list;
/

-- Create the item_tab object type
DESC item_list

SET PAGESIZE 9999
COL title   FORMAT A60
COL rating  FORMAT A6
SELECT   il.title
,        il.rating
FROM     TABLE(item_list('01-JAN-2000')) il
ORDER BY 1, 2;

-- Close log file.
SPOOL OFF
