/*
||  Name:           base_t.sql
||  Author:         Hiram Todd
||  Date:           06 Dec 2018
||  Purpose:        Complete 325 Final lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run the library files here.
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL base_t.txt

-- ... insert your solution here ...
/****************************************************************
A base_t object type and type body in a base_t.sql file, which 
includes a QUIT; statement 
*****************************************************************/
CREATE OR REPLACE 
    TYPE base_t IS OBJECT
        ( oid    NUMBER
        , oname  VARCHAR2(30)
        , CONSTRUCTOR FUNCTION base_t
            ( oid    NUMBER
            , oname  VARCHAR2 DEFAULT 'BASE_T' ) RETURN SELF AS RESULT
        , MEMBER FUNCTION     get_oname RETURN VARCHAR2
        , MEMBER PROCEDURE    set_oname (oname VARCHAR2)
        , MEMBER FUNCTION     get_name RETURN VARCHAR2
        , MEMBER FUNCTION     to_string RETURN VARCHAR2 ) INSTANTIABLE NOT FINAL;
/

-- Describe type object
DESC base_t

/****************************************************************
Implement the order_subcomp object type body with the following 
code:
*****************************************************************/
CREATE OR REPLACE
  TYPE BODY base_t IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION base_t
    ( oid        NUMBER
    , oname      VARCHAR2 DEFAULT 'BASE_T' ) RETURN SELF AS RESULT IS
  BEGIN
    self.oid := oid;
    self.oname := oname;
    RETURN;
  END base_t;
 
  -- Implement get function for get_oname
  MEMBER FUNCTION get_oname
  RETURN VARCHAR2 IS
  BEGIN
    RETURN self.oname;
  END get_oname;
 
  -- Implement get procedure for set_oname
  MEMBER PROCEDURE set_oname (oname VARCHAR2) IS
  BEGIN
    self.oname := oname;
  END set_oname;
 
  -- Implement a get function for get_name
  MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN NULL;
  END get_name;

  -- Implement to_string function
  MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oid||']';
  END to_string;
END;
/

SHOW ERRORS

QUIT;

-- Close log file.
SPOOL OFF


