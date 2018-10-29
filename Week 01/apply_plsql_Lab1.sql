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

SET ECHO ON

SELECT   table_name
FROM     user_tables
WHERE    table_name NOT IN ('EMP','DEPT')
AND NOT  table_name LIKE 'DEMO%'
AND NOT  table_name LIKE 'APEX%'
ORDER BY table_name;

  SET ECHO OFF
-- Close log file.
SPOOL OFF
