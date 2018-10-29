/*
||  Name:          apply_plsql_lab2-2.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/
SET ECHO ON 
-- Open log file.
SPOOL rerunnable.txt

-- ... insert your solution here ...
SET SERVEROUTPUT ON SIZE UNLIMITED


SET DEFINE ON
SET VERIFY OFF
DECLARE
    lv_raw_input    VARCHAR2(4000);
    lv_input        VARCHAR2(10);

BEGIN
    lv_raw_input := '&1';
    
    IF lv_raw_input IS NULL THEN
        dbms_output.put_line('Hello World!');
    
    ELSIF LENGTH(lv_raw_input) <= 10 THEN
        lv_input := lv_raw_input;
        dbms_output.put_line(concat('Hello ', concat(lv_input, '!')));
        
    ELSIF LENGTH(lv_raw_input) > 10 THEN
        lv_input := SUBSTR(lv_raw_input, 1, 10);
        dbms_output.put_line(concat('Hello ', concat(lv_input, '!')));
    
    END IF;
    
END;
/

SET ECHO OFF
-- Close log file.
SPOOL OFF

QUIT;
