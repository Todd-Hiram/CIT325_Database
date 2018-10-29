SQL> CREATE OR REPLACE PROCEDURE Sample AS 
  2    lv_number  NUMBER; 
  3  BEGIN 
  4    lv_number := lv_another_number; 
  5  END; 
  6  /
 
SQL> EXECUTE Sample;
