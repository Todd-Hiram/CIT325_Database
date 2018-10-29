/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Open log file.
SPOOL apply_plsql_lab4.txt

-- ... insert your solution here ...
-- BEGIN 
--     --Read forward through a range of values
--     FOR i IN 1..10 LOOP
--         IF i < 10 THEN
--             dbms_output.put_line('Value of "i" is: ['||i||']');
--         ELSE
--             dbms_output.put_line('Value of "i" is: ['||i||']');
--         END IF;
--     END LOOP;
-- END;
-- /


-- BEGIN 
--     --Read backward through a range of values
--     FOR i IN REVERSE 1..10 LOOP
--         IF i < 10 THEN
--             dbms_output.put_line('Value of "i" is: ['||i||']');
--         ELSE
--             dbms_output.put_line('Value of "i" is: ['||i||']');
--         END IF;
--     END LOOP;
-- END;
-- /

--You declare a days object type of a number and string in SQL with the following syntx
-- CREATE OR REPLACE
--     TYPE weekday IS OBJECT
--     (xnumber    number
--     ,xtext      VARCHAR2(9)
--     );
--     /
    
-- --You would implement the anonymous PL/SQL block with the following code
-- DECLARE
--     --Declare an array of days and gifts
--     TYPE days IS TABLE OF weekday;
--     
--     --Initialize the collection of days
--     lv_days DAYS := days( weekday(1, 'Sunday')
--                         , weekday(2, 'Monday')
--                         , weekday(3, 'Tuesday')
--                         , weekday(4, 'Wednesday')
--                         , weekday(5, 'Thursday')
--                         , weekday(6, 'Friday')
--                         , weekday(7, 'Saturday')
--                         );
--                         
-- BEGIN
--     --Read forward through the contents of the loop
--     FOR i IN 1..lv_days.COUNT LOOP
--         dbms_output.put_line('Value of "day" is: ['||lv_days(i).xtext||']');
--     END LOOP;
-- END;
-- /

-- DECLARE
--     --Declare an array of days and gifts
--     TYPE days IS TABLE OF weekday;
--     TYPE weekdays IS TABLE OF weekday;
--     
--     --Initialize the collection of days
--     lv_days DAYS := days( weekday(1, 'Sunday')
--                         , weekday(2, 'Monday')
--                         , weekday(3, 'Tuesday')
--                         , weekday(4, 'Wednesday')
--                         , weekday(5, 'Thursday')
--                         , weekday(6, 'Friday')
--                         , weekday(7, 'Saturday')
--                         );
--                         lv_weekdays WEEKDAYS := weekdays();
--                         
-- BEGIN 
--     --Remove the weekend elements, which alters the collection
--     FOR i IN 1..lv_days.COUNT LOOP
--         IF lv_days(i).xtext IN ('Saturday','Sunday') THEN
--             lv_days.DELETE(i);
--         END IF;
--     END LOOP;
--     
--     --Read forward through the contents of the loop
--     FOR i IN 1..lv_days.LAST LOOP
--         IF lv_days.EXISTS(i) THEN
--             dbms_output.put_line('Value of "day" is: ['||i||']['||lv_days(i).xnumber||']['||lv_days(i).xtext||']');
--         END IF;
--     END LOOP;
-- END;
-- /

--Show the input
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET ECHO ON;

--Create the day and gift objects
CREATE OR REPLACE 
    TYPE day_name IS OBJECT
        ( xtext     VARCHAR2(8)
        );
        /
        
CREATE OR REPLACE
    TYPE gift_name IS OBJECT
        ( xqty      VARCHAR2(8)
        , xgift     VARCHAR2(24)
        );
        /

DECLARE
--Declare tables of days and gifts
    TYPE days IS TABLE OF day_name;
    TYPE gifts IS TABLE OF gift_name;

    
--Initialize days
    lv_days DAYS := days(day_name('First')
                        , day_name('Second')
                        , day_name('Third')
                        , day_name('Fourth')
                        , day_name('Fifth')
                        , day_name('Sixth')
                        , day_name('Seventh')
                        , day_name('Eighth')
                        , day_name('Ninth')
                        , day_name('Tenth')
                        , day_name('Eleventh')
                        , day_name('Twelfth')
                        );
                        
--Initialize gifts
    lv_gifts GIFTS := gifts(gift_name('-and a', 'Partridge in a pear tree')
                        , gift_name('-Two', 'Turtle doves')
                        , gift_name('-three', 'French hens')
                        , gift_name('-Four', 'Calling birds')
                        , gift_name('-Five', 'Golden rings')
                        , gift_name('-Six', 'Geese a laying')
                        , gift_name('-Seven', 'Swans a swimming')
                        , gift_name('-Eight', 'Maids a milking')
                        , gift_name('-Nine', 'Ladies dancing')
                        , gift_name('-Ten', 'Lords a leaping')
                        , gift_name('-Eleven', 'Pipers piping')
                        , gift_name('-Twelve', 'Drummers drumming')
                        );
                        
BEGIN 
--Read forward
    FOR i IN 1..lv_days.COUNT LOOP
        dbms_output.put_line('On the ' || lv_days(i).xtext || ' day of Christmas');
        dbms_output.put_line('my true love gave to me:');
--Read backward
    FOR x IN REVERSE 1..i LOOP
    
--Print "Twelve Days of Christmas"
    IF i > 1 THEN
        dbms_output.put_line('' ||lv_gifts(x).xqty|| ' ' ||lv_gifts(x).xgift|| '');
    ELSE
        dbms_output.put_line('-A ' ||lv_gifts(x).xgift|| '');
    END IF;
    
    END LOOP;
        dbms_output.put_line(CHR(13));
    END LOOP;
END;
/

    
-- Close log file.
SPOOL OFF
--EXIT;
