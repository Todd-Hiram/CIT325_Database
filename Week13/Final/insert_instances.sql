/*
||  Name:           insert_instances.sql
||  Author:         Hiram Todd
||  Date:           06 Dec 2018
||  Purpose:        Complete 325 Final lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run the library files here.
-- @/home/student/Data/cit325/lib/cleanup_oracle.sql
-- @/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL insert_instances.txt

/******************************************************************************************************** 
An insert_instances.sql file that inserts 21 object type instances. 
*********************************************************************************************************/
CREATE OR REPLACE PROCEDURE create_man
    ( pv_name VARCHAR2 ) IS
    man MAN_T:= man_t
            ( pv_name
            , 'Men' );
BEGIN 

	INSERT INTO tolkien 
	VALUES 
        ( tolkien_s.NEXTVAL
        , man );
	
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE create_hobbit
    ( pv_name VARCHAR2 ) IS
    hobbit HOBBIT_T:= hobbit_t
            ( pv_name
            , 'Hobbits' );
BEGIN 

	INSERT INTO tolkien 
	VALUES 
        ( tolkien_s.NEXTVAL
        , hobbit);
	
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE create_dwarf
    ( pv_name VARCHAR2 ) IS
    dwarf DWARF_T:= dwarf_t
            ( pv_name
            , 'Dwarves' );
BEGIN 

	INSERT INTO tolkien 
	VALUES 
        ( tolkien_s.NEXTVAL
        , dwarf );
	
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE create_elf
    ( pv_name VARCHAR2
    , pv_elfkind VARCHAR2 ) IS
 
        noldor NOLDOR_T;
        silvan SILVAN_T;
        teleri TELERI_T;
        sindar SINDAR_T;
        
        lv_seq NUMBER := tolkien_s.NEXTVAL;
        lv_elfkind ELF_T;
	
BEGIN 

	IF pv_elfkind = 'Noldor' THEN
		noldor := noldor_t
            ( name => pv_name
            , genus => 'Elves'
            , elfkind => 'Noldor' );
		lv_elfkind := noldor;
	ELSIF pv_elfkind = 'Silvan' THEN 
		silvan := silvan_t
            ( name => pv_name
            , genus =>  'Elves'
            , elfkind => 'Silvan' );
		lv_elfkind := silvan;
	ELSIF pv_elfkind = 'Teleri' THEN 
		teleri := teleri_t
            ( name => pv_name
            , genus => 'Elves'
            , elfkind => 'Teleri' );
		lv_elfkind := teleri;
	ELSIF pv_elfkind = 'Sindar' THEN
		sindar := sindar_t
            ( name => pv_name
            , genus => 'Elves'
            , elfkind => 'Sindar' );
		lv_elfkind := sindar;
	END IF;
	
	INSERT INTO tolkien 
	VALUES 
        ( lv_seq
        , lv_elfkind);
	
	COMMIT;
END;
/

SHOW ERRORS;

CREATE OR REPLACE PROCEDURE create_orc
    (pv_name VARCHAR2) IS
    orc ORC_T:= orc_t
            (pv_name
            , 'Orcs');
	
BEGIN 

	INSERT INTO tolkien 
	VALUES 
        ( tolkien_s.NEXTVAL
        , orc);
	
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE create_maia
    (pv_name VARCHAR2) IS
    maia MAIA_T:= maia_t
            (pv_name
            , 'Maiar');
	
BEGIN 

	INSERT INTO tolkien 
	VALUES 
        ( tolkien_s.NEXTVAL
        , maia );
	
	COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE create_goblin
    ( pv_name VARCHAR2 ) IS
    goblin GOBLIN_T:= goblin_t
            ( pv_name
            , 'Goblins' );
	
BEGIN 

	INSERT INTO tolkien 
	VALUES 
        ( tolkien_s.NEXTVAL
        , goblin );
	
	COMMIT;
END;
/

BEGIN

	create_man('Boromir');
	create_man('Faramir');
	create_hobbit('Bilbo');
	create_hobbit('Frodo');
	create_hobbit('Merry');
	create_hobbit('Pippin');
	create_hobbit('Samwise');
	create_dwarf('Gimli');
	create_elf('Feanor', 'Noldor');
	create_elf('Tauriel', 'Silvan');
	create_elf('Earwen', 'Teleri');
	create_elf('Celeborn', 'Teleri');
	create_elf('Thranduil', 'Sindar');
	create_elf('Legolas', 'Sindar');
	create_orc('Azgog the Defiler');
	create_orc('Bolg');
	create_maia('Gandalf the Grey');
	create_maia('Radaagast the Brown');
	create_maia('Saruman the White');
	create_goblin('The Great Goblin');
	create_man('Aaragorn');
	
END;
/
	
SHOW ERRORS	
	
-- Close log file.
SPOOL OFF

QUIT
