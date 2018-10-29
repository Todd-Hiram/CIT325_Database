/*
||  Name:          apply_plsql_prereq3.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 4 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Open log file.
SPOOL apply_plsql_lab3.txt

DECLARE
  /* Declare a collection of strings. */
  TYPE list IS TABLE OF VARCHAR2(12);
  /* Declare a variable of the string collection. */
  lv_strings  LIST := list('10','Ten','Twelve12','28-FEB-2016');
BEGIN
  /* Loop through list of values to find only the numbers. */
  FOR i IN 1..lv_strings.COUNT LOOP
    IF REGEXP_LIKE(lv_strings(i),'^[[:digit:]]*$') OR
       REGEXP_LIKE(lv_strings(i),'^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$') OR
       REGEXP_LIKE(lv_strings(i),'^[[:alnum:]]*$') THEN
       dbms_output.put_line('Print string ['||lv_strings(i)||']');
    END IF;
  END LOOP;
END;
/

CREATE OR REPLACE
  FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  /* Local return variable. */
  lv_date  DATE;
BEGIN
  /* Check for a DD-MON-RR or DD-MON-YYYY string. */
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[ADFJMNOS][ACEOPU][BCGLNPRTVY]-([0-9]{2,2}|[0-9]{4,4})$') THEN
    /* Case statement checks for 28 or 29, 30, or 31 day month. */
    CASE
      /* Valid 31 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN 
        lv_date := pv_date_in;
      /* Valid 30 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN 
        lv_date := pv_date_in;
      /* Valid 28 or 29 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        /* Verify 2-digit or 4-digit year. */
        IF (LENGTH(pv_date_in) = 9 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,2)) + 2000,4) = 0 OR
            LENGTH(pv_date_in) = 11 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0) AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := null;
        ELSE /* Not a leap year. */
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := null;
          ELSE
            lv_date := null;
          END IF;
        END IF;
      ELSE
        /* Assign a default date. */
        lv_date := null;
    END CASE;
  ELSE
    /* Assign a default date. */
    lv_date := null;
  END IF;
  /* Return date. */
  RETURN lv_date;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  lv_date    DATE;
  lv_string  VARCHAR2(11) := '15-JAN-2017';
BEGIN
  /* Check and assign valid date. */
  IF verify_date(lv_string) IS NOT NULL THEN
    lv_date := lv_string;
    dbms_output.put_line('Does match date:     ['||lv_string||']['||lv_date||']');
  ELSE
    dbms_output.put_line('Does not match date: ['||lv_string||']['||lv_date||']');
  END IF;
END;
/

DECLARE
  lv_date    DATE;
  lv_string  VARCHAR2(11) := '31-APR-2017';
BEGIN
  /* Check and assign valid date. */
  IF verify_date(lv_string) IS NOT NULL THEN
    lv_date := lv_string;
    dbms_output.put_line('Does match date:     ['||lv_string||']['||lv_date||']');
  ELSE
    dbms_output.put_line('Does not match date: ['||lv_string||']['||lv_date||']');
  END IF;
END;
/

-- Close log file.
SPOOL OFF
