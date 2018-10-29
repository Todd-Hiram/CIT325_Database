/*
||  Name:          apply_plsql_lab3.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 4 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Open log file.
--SPOOL apply_plsql_lab3.txt

-- ... insert your solution here ...

SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED 
DECLARE
    --Declare a type
    TYPE three_type IS RECORD
    (xnum       NUMBER
    , xdate     DATE
    , xstring    VARCHAR2(30)
    );
    
    --Declare a collection of strings
    TYPE list IS TABLE OF VARCHAR2(100);
    
    --Declare variable of the record type
    lv_three_type three_type;
    
    --Declare a list of the collection type
    lv_input LIST;
    
    --Declare indepentent list variables 
    lv_input1 VARCHAR2(100);
    lv_input2 VARCHAR2(100);
    lv_input3 VARCHAR2(100);

BEGIN
    --Assign input variables
    lv_input1 := '&1';
    lv_input2 := '&2';
    lv_input3 := '&3';
    
    --Construct an instance of the input variable
    lv_input := list(lv_input1, lv_input2, lv_input3);
    
    --Loop thru list of values to find only the numbers
    FOR i IN 1..lv_input.COUNT LOOP
        IF  REGEXP_LIKE(lv_input(i), '^[[:digit:]]*$') THEN
            lv_three_type.xnum := lv_input(i);
        ELSIF verify_date(lv_input(i)) IS NOT NULL THEN
            lv_three_type.xdate := lv_input(i);
        ELSIF REGEXP_LIKE(lv_input(i), '^[[:alnum:]]*$') THEN
            lv_three_type.xstring := lv_input(i);
        END IF;
    END LOOP;
    
    --
    dbms_output.put_line('RECORD ['||lv_three_type.xnum||'] ['||lv_three_type.xstring||'] ['||lv_three_type.xdate||']');
    
END;
    /
    
    --Exit SQL*Plus
    
-- Close log file.
--SPOOL OFF
QUIT;
