/*
||  Name:           elf_t.sql
||  Author:         Hiram Todd
||  Date:           06 Dec 2018
||  Purpose:        Complete 325 Final lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run the library files here.
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL elf_t.txt

-- ... insert your solution here ...
/********************************************************************************
An elf_t object type and type body as a subtype of the base_t object type, and 
a QUIT; statement in a elf_t.sql file.
*********************************************************************************/
CREATE OR REPLACE
  TYPE elf_t UNDER base_t
  ( /*oid     NUMBER
  , oname   VARCHAR2(30)*/
    name    VARCHAR2(30)
  , genus   VARCHAR2(30)
  , CONSTRUCTOR FUNCTION elf_t
        ( name       VARCHAR2
        , genus      VARCHAR2 DEFAULT 'Elves' ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION get_genus RETURN VARCHAR2
  , MEMBER PROCEDURE set_genus (genus VARCHAR2)
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/

SHOW ERRORS

DESC elf_t

/********************************************************************************
This is the elf_t type body
*********************************************************************************/
CREATE OR REPLACE TYPE BODY elf_t IS
  /* Implement a default constructor. */  
  CONSTRUCTOR FUNCTION elf_t
        ( name      VARCHAR2
        , genus     VARCHAR2 DEFAULT 'Elves' ) RETURN SELF AS RESULT IS
  BEGIN
    self.oid := tolkien_s.CURRVAL-1000;
    self.oname := 'Elf';
    self.name := name;
    self.genus := genus;
    RETURN;
  END elf_t;
 
  /* Override the get_name function. */
  OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
  BEGIN
    RETURN self.name;
  END get_name;

  /* Implement a get_genus function. */
  MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
  BEGIN
    RETURN self.genus;
  END get_genus;

  /* Implement a set_genus procedure. */
  MEMBER PROCEDURE set_genus (genus VARCHAR2) IS
  BEGIN
    self.genus := genus;
  END set_genus;
  
  /* Implement an overriding to_string function with
     generalized invocation. */
  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN (self AS base_t).to_string||'['||self.name||']['||self.genus||']';
  END to_string;
END;
/

QUIT;


-- Close log file.
SPOOL OFF
