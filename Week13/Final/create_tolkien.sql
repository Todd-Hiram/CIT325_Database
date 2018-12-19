/*
||  Name:           create_tolkien.sql
||  Author:         Hiram Todd
||  Date:           06 Dec 2018
||  Purpose:        Complete 325 Final lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run the library files here.
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


/* Set environment variables. */
SET PAGESIZE 999
 
/* Write to log file. */
SPOOL create_tolkien.txt
 
/* Drop the tolkien table. */
DROP TABLE tolkien;
 
/* Create the tolkien table. */
CREATE TABLE tolkien
( tolkien_id NUMBER
, tolkien_character base_t);

DESC tolkien
 
/* Drop and create a tolkien_s sequence. */
DROP SEQUENCE tolkien_s;
CREATE SEQUENCE tolkien_s START WITH 1001;

 
/* Close log file. */
SPOOL OFF
 
/* Exit the connection. */
QUIT
