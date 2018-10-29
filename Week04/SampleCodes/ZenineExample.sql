/*Zenine07 apply_plsql_lab4.sql example work*/
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

SPOOL apply_plsql_lab4.txt

CREATE OR REPLACE
  TYPE twelve_christmas IS OBJECT
  ( amount VARCHAR2(8)
  , gift_name VARCHAR2(24));
/

DECLARE
  --create collection of days
  TYPE twelve_days IS TABLE OF VARCHAR2(8);
  lv_twelve_days TWELVE_DAYS := twelve_days('first','second','third','fourth','fifth','sixth',
                                     'seventh','eighth','ninth','tenth','eleventh','twelfth');

  TYPE christmas_presents IS TABLE of twelve_christmas;

  lv_christmas_presents CHRISTMAS_PRESENTS :=
    CHRISTMAS_PRESENTS( twelve_christmas('and a', 'Partridge in a pear tree')
                      , twelve_christmas('Two', 'Turtle doves')
                      , twelve_christmas('Three', 'French Hens')
                      , twelve_christmas('Four', 'Calling birds')
                      , twelve_christmas('Five', 'Golden rings')
                      , twelve_christmas('Six', 'Geese a laying')
                      , twelve_christmas('Seven', 'Swans a swimming')
                      , twelve_christmas('Eight', 'Maids a milking')
                      , twelve_christmas('Nine', 'Ladies dancing')
                      , twelve_christmas('Ten', 'Lords a leaping')
                      , twelve_christmas('Eleven', 'Pipers piping')
                      , twelve_christmas('Twelve', 'Drummers drumming'));


BEGIN
  FOR i IN 1..lv_twelve_days.COUNT LOOP
    dbms_output.put_line('On the '||lv_twelve_days(i)||' day of Christmas');
    dbms_output.put_line('my true love sent to me: ');

    IF (i > 1) THEN
      FOR j IN REVERSE 1..i LOOP
        dbms_output.put_line('-'||lv_christmas_presents(j).amount||' '||lv_christmas_presents(j).gift_name);
      END LOOP;
    ELSE
      dbms_output.put_line('-A Partridge in a pear tree');
    END IF;

    dbms_output.put_line(CHR(13));
  END LOOP;
END;
/

SPOOL OFF