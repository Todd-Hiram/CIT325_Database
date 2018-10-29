/*
||  Name:          apply_plsql_lab1.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab1.txt

-- ... insert your solution here ...
SET ECHO ON

CURSOR c IS
SELECT   table_name
  2  FROM     user_tables
  3  WHERE    table_name NOT IN ('EMP','DEPT')
  4  AND NOT  table_name LIKE 'DEMO%'
  5  AND NOT  table_name LIKE 'APEX%'
  6  ORDER BY table_name;

  
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Close log file.
SPOOL OFF