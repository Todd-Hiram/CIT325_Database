/*
||  Name:           apply_plsql_lab11.sql
||  Date:           27 Nov 2018
||  Author:         Hiram Todd
||  Purpose:        Complete 325 Chapter 12 lab.
||  Dependencies:   Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run the library files here.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab11.txt

-- ... insert your solution here ...
/************************************ Step 1 ****************************************
Need to add a text_file_name column to the item table. The text_file_name column 
should use a VARCHAR2(30) data type.
*************************************************************************************/
-- DROP TABLE logger;
DROP SEQUENCE logger_s;

ALTER TABLE item ADD text_file_name VARCHAR2(40);

-- Create Logger Table
CREATE TABLE logger
    ( logger_id                 NUMBER
    , old_item_id               NUMBER
    , old_item_barcode          VARCHAR2(20)
    , old_item_type             NUMBER
    , old_item_title            VARCHAR2(60)
    , old_item_subtitle         VARCHAR2(60)
    , old_item_rating           VARCHAR2(8)
    , old_item_rating_agency    VARCHAR2(4)
    , old_item_release_date     DATE
    , old_created_by            NUMBER
    , old_creation_date         DATE
    , old_last_updated_by       NUMBER
    , old_last_update_date      DATE
    , old_text_file_name        VARCHAR2(40)
    , new_item_id               NUMBER
    , new_item_barcode          VARCHAR2(20)
    , new_item_type             NUMBER
    , new_item_title            VARCHAR2(60)
    , new_item_subtitle         VARCHAR2(60)
    , new_item_rating           VARCHAR2(8)
    , new_item_rating_agency    VARCHAR2(4)
    , new_item_release_date     DATE
    , new_created_by            NUMBER
    , new_creation_date         DATE
    , new_last_updated_by       NUMBER
    , new_last_update_date      DATE
    , new_text_file_name        VARCHAR2(40)
    , CONSTRAINT logger_pk PRIMARY KEY (logger_id));
--     
-- Create logger_s SEQUENCE
CREATE SEQUENCE logger_s;

DESC logger;

/**********************************************************************************
This test is to verify that you have a working INSERT statement into the logger 
table, which you’ll use in subsequent components of the lab 
***********************************************************************************/
/* Test your INSERT statement into the logger table */
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
    INSERT INTO logger
        ( logger_id
        , old_item_id
        , old_item_barcode
        , old_item_type
        , old_item_title
        , old_item_subtitle
        , old_item_rating
        , old_item_rating_agency
        , old_item_release_date
        , old_created_by
        , old_creation_date
        , old_last_updated_by
        , old_last_update_date
        , old_text_file_name
        , new_item_id
        , new_item_barcode
        , new_item_type
        , new_item_title
        , new_item_subtitle
        , new_item_rating
        , new_item_rating_agency
        , new_item_release_date
        , new_created_by
        , new_creation_date
        , new_last_updated_by
        , new_last_update_date
        , new_text_file_name )
        VALUES
        ( logger_s.NEXTVAL
        , i.item_id
        , i.item_barcode 
        , i.item_type
        , i.item_title
        , i.item_subtitle
        , i.item_rating
        , i.item_rating_agency
        , i.item_release_date
        , i.created_by
        , i.creation_date
        , i.last_updated_by
        , i.last_update_date
        , i.text_file_name
        , i.item_id
        , i.item_barcode
        , i.item_type
        , i.item_title
        , i.item_subtitle
        , i.item_rating
        , i.item_rating_agency
        , i.item_release_date
        , i.created_by
        , i.creation_date
        , i.last_updated_by
        , i.last_update_date
        , i.text_file_name );
  END LOOP;
END;
/

/************************************ Step 2 ****************************************
Create overloaded item_insert autonomous procedures inside a manage_item package. 
These item_insert procedures are being designed to insert the old_ and new_ pseudo 
columns from the item table into the logger table within the scope of a database 
trigger.
*************************************************************************************/
-- Create overloaded item_insert autonomous procedures inside a manage_item package 
CREATE OR REPLACE PACKAGE manage_item IS
    PROCEDURE item_insert            -- For New inserts
        ( pv_new_item_id            NUMBER
        , pv_new_item_barcode       VARCHAR2
        , pv_new_item_type          NUMBER
        , pv_new_item_title         VARCHAR2
        , pv_new_item_subtitle      VARCHAR2
        , pv_new_item_rating        VARCHAR2
        , pv_new_item_rating_agency VARCHAR2
        , pv_new_item_release_date  DATE
        , pv_new_created_by         NUMBER
        , pv_new_creation_date      DATE 
        , pv_new_last_updated_by    NUMBER
        , pv_new_last_update_date   DATE 
        , pv_new_text_file_name     VARCHAR2 );

    PROCEDURE item_insert        -- For both Old and New
        ( pv_old_item_id            NUMBER
        , pv_old_item_barcode       VARCHAR2
        , pv_old_item_type          NUMBER
        , pv_old_item_title         VARCHAR2
        , pv_old_item_subtitle      VARCHAR2
        , pv_old_item_rating        VARCHAR2
        , pv_old_item_rating_agency VARCHAR2
        , pv_old_item_release_date  DATE
        , pv_old_created_by         NUMBER
        , pv_old_creation_date      DATE 
        , pv_old_last_updated_by    NUMBER
        , pv_old_last_update_date   DATE 
        , pv_old_text_file_name     VARCHAR2 
        , pv_new_item_id            NUMBER
        , pv_new_item_barcode       VARCHAR2
        , pv_new_item_type          NUMBER
        , pv_new_item_title         VARCHAR2
        , pv_new_item_subtitle      VARCHAR2
        , pv_new_item_rating        VARCHAR2
        , pv_new_item_rating_agency VARCHAR2
        , pv_new_item_release_date  DATE
        , pv_new_created_by         NUMBER
        , pv_new_creation_date      DATE 
        , pv_new_last_updated_by    NUMBER
        , pv_new_last_update_date   DATE 
        , pv_new_text_file_name     VARCHAR2 );
        
    PROCEDURE item_insert        -- For both Old
        ( pv_old_item_id            NUMBER
        , pv_old_item_barcode       VARCHAR2
        , pv_old_item_type          NUMBER
        , pv_old_item_title         VARCHAR2
        , pv_old_item_subtitle      VARCHAR2
        , pv_old_item_rating        VARCHAR2
        , pv_old_item_rating_agency VARCHAR2
        , pv_old_item_release_date  DATE
        , pv_old_created_by         NUMBER
        , pv_old_creation_date      DATE 
        , pv_old_last_updated_by    NUMBER
        , pv_old_last_update_date   DATE 
        , pv_old_text_file_name     VARCHAR2 );
END manage_item;
/

-- Verify package
DESC manage_item;

/***********************************************************************************
Need to implement a manage_item package body
************************************************************************************/
CREATE OR REPLACE PACKAGE BODY manage_item IS
    PROCEDURE item_insert            -- For New inserts
        ( pv_new_item_id            NUMBER
        , pv_new_item_barcode       VARCHAR2
        , pv_new_item_type          NUMBER
        , pv_new_item_title         VARCHAR2
        , pv_new_item_subtitle      VARCHAR2
        , pv_new_item_rating        VARCHAR2
        , pv_new_item_rating_agency VARCHAR2
        , pv_new_item_release_date  DATE
        , pv_new_created_by         NUMBER
        , pv_new_creation_date      DATE 
        , pv_new_last_updated_by    NUMBER
        , pv_new_last_update_date   DATE 
        , pv_new_text_file_name     VARCHAR2 ) IS PRAGMA AUTONOMOUS_TRANSACTION;

    -- Insert log entry
    BEGIN manage_item.item_insert   -- For both Old and New
        ( pv_old_item_id            => NULL
        , pv_old_item_barcode       => NULL
        , pv_old_item_type          => NULL
        , pv_old_item_title         => NULL
        , pv_old_item_subtitle      => NULL
        , pv_old_item_rating        => NULL
        , pv_old_item_rating_agency => NULL
        , pv_old_item_release_date  => NULL
        , pv_old_created_by         => NULL
        , pv_old_creation_date      => NULL 
        , pv_old_last_updated_by    => NULL
        , pv_old_last_update_date   => NULL 
        , pv_old_text_file_name     => NULL 
        , pv_new_item_id            => pv_new_item_id
        , pv_new_item_barcode       => pv_new_item_barcode
        , pv_new_item_type          => pv_new_item_type
        , pv_new_item_title         => pv_new_item_title
        , pv_new_item_subtitle      => pv_new_item_subtitle
        , pv_new_item_rating        => pv_new_item_rating
        , pv_new_item_rating_agency => pv_new_item_rating_agency
        , pv_new_item_release_date  => pv_new_item_release_date
        , pv_new_created_by         => pv_new_created_by
        , pv_new_creation_date      => pv_new_creation_date 
        , pv_new_last_updated_by    => pv_new_last_updated_by
        , pv_new_last_update_date   => pv_new_last_update_date 
        , pv_new_text_file_name     => pv_new_text_file_name );
        COMMIT;
END item_insert;

PROCEDURE item_insert               -- For both Old and New
        ( pv_old_item_id            NUMBER
        , pv_old_item_barcode       VARCHAR2
        , pv_old_item_type          NUMBER
        , pv_old_item_title         VARCHAR2
        , pv_old_item_subtitle      VARCHAR2
        , pv_old_item_rating        VARCHAR2
        , pv_old_item_rating_agency VARCHAR2
        , pv_old_item_release_date  DATE
        , pv_old_created_by         NUMBER
        , pv_old_creation_date      DATE 
        , pv_old_last_updated_by    NUMBER
        , pv_old_last_update_date   DATE 
        , pv_old_text_file_name     VARCHAR2 
        , pv_new_item_id            NUMBER
        , pv_new_item_barcode       VARCHAR2
        , pv_new_item_type          NUMBER
        , pv_new_item_title         VARCHAR2
        , pv_new_item_subtitle      VARCHAR2
        , pv_new_item_rating        VARCHAR2
        , pv_new_item_rating_agency VARCHAR2
        , pv_new_item_release_date  DATE
        , pv_new_created_by         NUMBER
        , pv_new_creation_date      DATE 
        , pv_new_last_updated_by    NUMBER
        , pv_new_last_update_date   DATE 
        , pv_new_text_file_name     VARCHAR2 ) IS PRAGMA AUTONOMOUS_TRANSACTION;
        
    /* Declare local logging value. */
    lv_logger_id  NUMBER;
        
BEGIN
    /* Get a sequence. */
    lv_logger_id := logger_s.NEXTVAL;
    
    -- Logger entry inserts
    INSERT INTO logger
        ( logger_id
        , old_item_id
        , old_item_barcode
        , old_item_type
        , old_item_title
        , old_item_subtitle
        , old_item_rating
        , old_item_rating_agency
        , old_item_release_date
        , old_created_by
        , old_creation_date
        , old_last_updated_by
        , old_last_update_date
        , old_text_file_name
        , new_item_id
        , new_item_barcode
        , new_item_type
        , new_item_title
        , new_item_subtitle
        , new_item_rating
        , new_item_rating_agency
        , new_item_release_date
        , new_created_by
        , new_creation_date
        , new_last_updated_by
        , new_last_update_date
        , new_text_file_name )
        VALUES
        ( lv_logger_id
        , pv_old_item_id
        , pv_old_item_barcode
        , pv_old_item_type
        , pv_old_item_title
        , pv_old_item_subtitle
        , pv_old_item_rating
        , pv_old_item_rating_agency
        , pv_old_item_release_date
        , pv_old_created_by
        , pv_old_creation_date
        , pv_old_last_updated_by
        , pv_old_last_update_date
        , pv_old_text_file_name
        , pv_new_item_id
        , pv_new_item_barcode
        , pv_new_item_type
        , pv_new_item_title
        , pv_new_item_subtitle
        , pv_new_item_rating
        , pv_new_item_rating_agency
        , pv_new_item_release_date
        , pv_new_created_by
        , pv_new_creation_date
        , pv_new_last_updated_by
        , pv_new_last_update_date
        , pv_new_text_file_name );    
        COMMIT;
    END item_insert;
    
PROCEDURE item_insert        -- For both Old
        ( pv_old_item_id            NUMBER
        , pv_old_item_barcode       VARCHAR2
        , pv_old_item_type          NUMBER
        , pv_old_item_title         VARCHAR2
        , pv_old_item_subtitle      VARCHAR2
        , pv_old_item_rating        VARCHAR2
        , pv_old_item_rating_agency VARCHAR2
        , pv_old_item_release_date  DATE
        , pv_old_created_by         NUMBER
        , pv_old_creation_date      DATE 
        , pv_old_last_updated_by    NUMBER
        , pv_old_last_update_date   DATE 
        , pv_old_text_file_name     VARCHAR2 ) IS PRAGMA AUTONOMOUS_TRANSACTION;
        
        BEGIN manage_item.item_insert
            ( pv_old_item_id            => pv_old_item_id
            , pv_old_item_barcode       => pv_old_item_barcode
            , pv_old_item_type          => pv_old_item_type
            , pv_old_item_title         => pv_old_item_title
            , pv_old_item_subtitle      => pv_old_item_subtitle
            , pv_old_item_rating        => pv_old_item_rating
            , pv_old_item_rating_agency => pv_old_item_rating_agency
            , pv_old_item_release_date  => pv_old_item_release_date
            , pv_old_created_by         => pv_old_created_by
            , pv_old_creation_date      => pv_old_creation_date 
            , pv_old_last_updated_by    => pv_old_last_updated_by
            , pv_old_last_update_date   => pv_old_last_update_date 
            , pv_old_text_file_name     => pv_old_text_file_name 
            , pv_new_item_id            => NULL
            , pv_new_item_barcode       => NULL
            , pv_new_item_type          => NULL
            , pv_new_item_title         => NULL
            , pv_new_item_subtitle      => NULL
            , pv_new_item_rating        => NULL
            , pv_new_item_rating_agency => NULL
            , pv_new_item_release_date  => NULL
            , pv_new_created_by         => NULL
            , pv_new_creation_date      => NULL 
            , pv_new_last_updated_by    => NULL
            , pv_new_last_update_date   => NULL 
            , pv_new_text_file_name     => NULL );
            
        END item_insert;
END manage_item;
/

/* Test that the overloaded insert_item procedures write the correct data to the logger table */
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
        -- Insert statement
        manage_item.item_insert
            ( pv_new_item_id                => i.item_id
            , pv_new_item_barcode           => i.item_barcode
            , pv_new_item_type              => i.item_type
            , pv_new_item_title             => i.item_title || '-Inserted'
            , pv_new_item_subtitle          => i.item_subtitle
            , pv_new_item_rating            => i.item_rating
            , pv_new_item_rating_agency     => i.item_rating_agency
            , pv_new_item_release_date      => i.item_release_date
            , pv_new_created_by             => i.created_by
            , pv_new_creation_date          => i.creation_date
            , pv_new_last_updated_by        => i.last_updated_by
            , pv_new_last_update_date       => i.last_update_date
            , pv_new_text_file_name         => i.text_file_name );
        
        -- Update statement
        manage_item.item_insert
            ( pv_old_item_id                => i.item_id
            , pv_old_item_barcode           => i.item_barcode
            , pv_old_item_type              => i.item_type
            , pv_old_item_title             => i.item_title
            , pv_old_item_subtitle          => i.item_subtitle
            , pv_old_item_rating            => i.item_rating
            , pv_old_item_rating_agency     => i.item_rating_agency
            , pv_old_item_release_date      => i.item_release_date
            , pv_old_created_by             => i.created_by
            , pv_old_creation_date          => i.creation_date
            , pv_old_last_updated_by        => i.last_updated_by
            , pv_old_last_update_date       => i.last_update_date
            , pv_old_text_file_name         => i.text_file_name
            , pv_new_item_id                => i.item_id
            , pv_new_item_barcode           => i.item_barcode
            , pv_new_item_type              => i.item_type
            , pv_new_item_title             => i.item_title || '-Changed'
            , pv_new_item_subtitle          => i.item_subtitle
            , pv_new_item_rating            => i.item_rating
            , pv_new_item_rating_agency     => i.item_rating_agency
            , pv_new_item_release_date      => i.item_release_date
            , pv_new_created_by             => i.created_by
            , pv_new_creation_date          => i.creation_date
            , pv_new_last_updated_by        => i.last_updated_by
            , pv_new_last_update_date       => i.last_update_date
            , pv_new_text_file_name         => i.text_file_name );

        -- Delete statement
        manage_item.item_insert
            ( pv_old_item_id                => i.item_id
            , pv_old_item_barcode           => i.item_barcode
            , pv_old_item_type              => i.item_type
            , pv_old_item_title             => i.item_title || '-Deleted'
            , pv_old_item_subtitle          => i.item_subtitle
            , pv_old_item_rating            => i.item_rating
            , pv_old_item_rating_agency     => i.item_rating_agency
            , pv_old_item_release_date      => i.item_release_date
            , pv_old_created_by             => i.created_by
            , pv_old_creation_date          => i.creation_date
            , pv_old_last_updated_by        => i.last_updated_by
            , pv_old_last_update_date       => i.last_update_date
            , pv_old_text_file_name         => i.text_file_name );
            
  END LOOP;
END;
/

/************************************ Step 3 ****************************************
Create an item_trig trigger that manages INSERT, UPDATE, and DELETE row-level events.
Alternatively, you can create an item_trig trigger that manages INSERT or UPDATE 
row-level events and an item_delete_trig that manages the DELETE row-level event
*************************************************************************************/
-- Create an item_trig trigger that performs the tasks for INSERT and UPDATE statements
CREATE OR REPLACE TRIGGER item_trig
  BEFORE INSERT OR UPDATE OF item_title ON item
  FOR EACH ROW
  
  DECLARE
    lv_input_title    VARCHAR2(40);
    lv_title          VARCHAR2(20);
    lv_subtitle       VARCHAR2(20);
    lv_update_needed  NUMBER;
    
    -- Declare exception
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);
    
  BEGIN
    IF INSERTING THEN
      manage_item.item_insert
            ( pv_new_item_id            => :new.item_id
            , pv_new_item_barcode       => :new.item_barcode
            , pv_new_item_type          => :new.item_type
            , pv_new_item_title         => :new.item_title
            , pv_new_item_subtitle      => :new.item_subtitle
            , pv_new_item_rating        => :new.item_rating
            , pv_new_item_rating_agency => :new.item_rating_agency
            , pv_new_item_release_date  => :new.item_release_date
            , pv_new_created_by         => :new.created_by
            , pv_new_creation_date      => :new.creation_date
            , pv_new_last_updated_by    => :new.last_updated_by
            , pv_new_last_update_date   => :new.last_update_date
            , pv_new_text_file_name     => :new.text_file_name );

      /* Assign the title */
      lv_input_title := :new.ITEM_TITLE;
      lv_update_needed := 0;
 
/******************************************************************************************
Testing the logic of database triggers is very complex. As a result, it seems helpful
to first create a stand alone procedure that demonstrates how to hand new input values
*******************************************************************************************/
      IF REGEXP_INSTR(lv_input_title,':') > 0 AND
         REGEXP_INSTR(lv_input_title,':') = LENGTH(lv_input_title) THEN
        /* Shave off the colon. */
        lv_title   := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := '';
        lv_update_needed := 1;
      ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
        /* Split the string into two parts. */
        lv_title    := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
        lv_update_needed := 1;
      END IF;
      
      -- Insert updates if needed
      IF lv_update_needed = 1 THEN
          manage_item.item_insert
            ( pv_old_item_id            => :new.item_id
            , pv_old_item_barcode       => :new.item_barcode
            , pv_old_item_type          => :new.item_type
            , pv_old_item_title         => :new.item_title
            , pv_old_item_subtitle      => :new.item_subtitle
            , pv_old_item_rating        => :new.item_rating
            , pv_old_item_rating_agency => :new.item_rating_agency
            , pv_old_item_release_date  => :new.item_release_date
            , pv_old_created_by         => :new.created_by
            , pv_old_creation_date      => :new.creation_date
            , pv_old_last_updated_by    => :new.last_updated_by
            , pv_old_last_update_date   => :new.last_update_date
            , pv_old_text_file_name     => :new.text_file_name
            , pv_new_item_id            => :new.item_id
            , pv_new_item_barcode       => :new.item_barcode
            , pv_new_item_type          => :new.item_type
            , pv_new_item_title         => lv_title
            , pv_new_item_subtitle      => lv_subtitle
            , pv_new_item_rating        => :new.item_rating
            , pv_new_item_rating_agency => :new.item_rating_agency
            , pv_new_item_release_date  => :new.item_release_date
            , pv_new_created_by         => :new.created_by
            , pv_new_creation_date      => :new.creation_date
            , pv_new_last_updated_by    => :new.last_updated_by
            , pv_new_last_update_date   => :new.last_update_date
            , pv_new_text_file_name     => :new.text_file_name );

          -- Insert values to change
          :new.item_title := lv_title;
          :new.item_subtitle := lv_subtitle;
      END IF;

      /* Check for an empty item_id primary key column value,
         and assign the next sequence value when it is missing. */
      IF :new.item_id IS NULL THEN
        SELECT item_s1.NEXTVAL
        INTO   :new.item_id
        FROM   dual;
      END IF;
      
    ELSIF UPDATING THEN
      manage_item.item_insert
            ( pv_old_item_id            => :old.item_id
            , pv_old_item_barcode       => :old.item_barcode
            , pv_old_item_type          => :old.item_type
            , pv_old_item_title         => :old.item_title
            , pv_old_item_subtitle      => :old.item_subtitle
            , pv_old_item_rating        => :old.item_rating
            , pv_old_item_rating_agency => :old.item_rating_agency
            , pv_old_item_release_date  => :old.item_release_date
            , pv_old_created_by         => :old.created_by
            , pv_old_creation_date      => :old.creation_date
            , pv_old_last_updated_by    => :old.last_updated_by
            , pv_old_last_update_date   => :old.last_update_date
            , pv_old_text_file_name     => :old.text_file_name
            , pv_new_item_id            => :new.item_id
            , pv_new_item_barcode       => :new.item_barcode
            , pv_new_item_type          => :new.item_type
            , pv_new_item_title         => :new.item_title
            , pv_new_item_subtitle      => :new.item_subtitle
            , pv_new_item_rating        => :new.item_rating
            , pv_new_item_rating_agency => :new.item_rating_agency
            , pv_new_item_release_date  => :new.item_release_date
            , pv_new_created_by         => :new.created_by
            , pv_new_creation_date      => :new.creation_date
            , pv_new_last_updated_by    => :new.last_updated_by
            , pv_new_last_update_date   => :new.last_update_date
            , pv_new_text_file_name     => :new.text_file_name );

      -- Assign the title
      lv_input_title := :new.ITEM_TITLE;
      lv_update_needed := 0;
 
      /* Check for a subtitle. */
      IF REGEXP_INSTR(lv_input_title,':') > 0 AND
         REGEXP_INSTR(lv_input_title,':') = LENGTH(lv_input_title) THEN
        /* Shave off the colon. */
        lv_title   := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := '';
        lv_update_needed := 1;
      ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
        /* Split the string into two parts. */
        lv_title    := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
        lv_update_needed := 1;
      END IF;

      -- Insert updates if needed
      IF lv_update_needed = 1 THEN
          manage_item.item_insert
            ( pv_old_item_id            => :new.item_id
            , pv_old_item_barcode       => :new.item_barcode
            , pv_old_item_type          => :new.item_type
            , pv_old_item_title         => :new.item_title
            , pv_old_item_subtitle      => :new.item_subtitle
            , pv_old_item_rating        => :new.item_rating
            , pv_old_item_rating_agency => :new.item_rating_agency
            , pv_old_item_release_date  => :new.item_release_date
            , pv_old_created_by         => :new.created_by
            , pv_old_creation_date      => :new.creation_date
            , pv_old_last_updated_by    => :new.last_updated_by
            , pv_old_last_update_date   => :new.last_update_date
            , pv_old_text_file_name     => :new.text_file_name
            , pv_new_item_id            => :new.item_id
            , pv_new_item_barcode       => :new.item_barcode
            , pv_new_item_type          => :new.item_type
            , pv_new_item_title         => lv_title
            , pv_new_item_subtitle      => lv_subtitle
            , pv_new_item_rating        => :new.item_rating
            , pv_new_item_rating_agency => :new.item_rating_agency
            , pv_new_item_release_date  => :new.item_release_date
            , pv_new_created_by         => :new.created_by
            , pv_new_creation_date      => :new.creation_date
            , pv_new_last_updated_by    => :new.last_updated_by
            , pv_new_last_update_date   => :new.last_update_date
            , pv_new_text_file_name     => :new.text_file_name );

          -- Change values to be updated
          :new.item_title := lv_title;
          :new.item_subtitle := lv_subtitle;
      END IF;
    END IF;
  END item_trig;
/

-- Create an item_delete_trig trigger that performs the following tasks for a DELETE   statement:
CREATE OR REPLACE TRIGGER item_delete_trig
  BEFORE DELETE ON item
  FOR EACH ROW
  
  DECLARE
    -- Declare exception
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);
  BEGIN
    IF DELETING THEN
      manage_item.item_insert
            ( pv_old_item_id            => :old.item_id
            , pv_old_item_barcode       => :old.item_barcode
            , pv_old_item_type          => :old.item_type
            , pv_old_item_title         => :old.item_title
            , pv_old_item_subtitle      => :old.item_subtitle
            , pv_old_item_rating        => :old.item_rating
            , pv_old_item_rating_agency => :old.item_rating_agency
            , pv_old_item_release_date  => :old.item_release_date
            , pv_old_created_by         => :old.created_by
            , pv_old_creation_date      => :old.creation_date
            , pv_old_last_updated_by    => :old.last_updated_by
            , pv_old_last_update_date   => :old.last_update_date
            , pv_old_text_file_name     => :old.text_file_name );
    END IF;
  END item_delete_trig;
/

-- Insert a row into the common_lookup table
INSERT INTO common_lookup 
    ( common_lookup_id
    , common_lookup_table
    , common_lookup_column
    , common_lookup_type
    , common_lookup_code
    , common_lookup_meaning
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES 
    ( common_lookup_s1.NEXTVAL
    , 'ITEM'
    , 'ITEM_TYPE'
    , 'BLU-RAY'
    , ''
    , 'Blu-ray'
    , 3
    , SYSDATE
    , 3
    , SYSDATE);



/* Make item_desc nullable for next inserts */
ALTER TABLE item DROP CONSTRAINT nn_item_4;

/*****************************************************************************************
 Three INSERT statements that test the tree conditions of your inserting event trigger
******************************************************************************************/
-- Column Value 1
INSERT INTO item 
    ( item_id
    , item_barcode
    , item_type
    , item_title
    , item_subtitle
    , item_rating
    , item_rating_agency
    , item_release_date
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES 
    ( item_s1.NEXTVAL
    , 'B01IHVPA8'
    , ( SELECT  common_lookup_id 
        FROM    common_lookup 
        WHERE   common_lookup_table = 'ITEM' 
        AND     common_lookup_column = 'ITEM_TYPE' 
        AND     common_lookup_type = 'BLU-RAY' )
    , 'Bourne'
    , ''
    , 'PG-13'
    , 'MPAA'
    , TO_DATE('6-Dec-16')
    , 3
    , SYSDATE
    , 3
    , SYSDATE);

-- Column Value 2
INSERT INTO item 
    ( item_id
    , item_barcode
    , item_type
    , item_title
    , item_subtitle
    , item_rating
    , item_rating_agency
    , item_release_date
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES 
    ( item_s1.NEXTVAL
    , 'B01AT251XY'
    , ( SELECT  common_lookup_id 
        FROM    common_lookup 
        WHERE   common_lookup_table = 'ITEM' 
        AND     common_lookup_column = 'ITEM_TYPE' 
        AND     common_lookup_type = 'BLU-RAY' )
    , 'Bourne Legacy:'
    , ''
    , 'PG-13'
    , 'MPAA'
    , TO_DATE('5-Apr-16')
    , 3
    , SYSDATE
    , 3
    , SYSDATE);

-- Column Value 3
INSERT INTO item 
    ( item_id
    , item_barcode
    , item_type
    , item_title
    , item_subtitle
    , item_rating
    , item_rating_agency
    , item_release_date
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES 
    ( item_s1.NEXTVAL
    , 'B018FK66TU'
    , ( SELECT  common_lookup_id 
        FROM    common_lookup 
        WHERE   common_lookup_table = 'ITEM' 
        AND     common_lookup_column = 'ITEM_TYPE' 
        AND     common_lookup_type = 'BLU-RAY')
    , 'Star Wars: The Force Awakens'
    , ''
    , 'PG-13'
    , 'MPAA'
    , TO_DATE('5-Apr-16')
    , 3
    , SYSDATE
    , 3
    , SYSDATE);
    
/******************************* Step 0 Verification ***************************************
Run a verification script to ensure you have the correct text_file_name column in 
the item table definition.
*************************************************************************************/
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

/********************************* Step 1 Verification ******************************
Test query returns the rows selected by the get_row cursor of the preceding sample 
code. The get_row cursor selects the item_title column where the item_title equals 
a string literal value of 'Brave Heart'. Then, you write an INSERT statement inside 
the loop that:
************************************************************************************/
-- Query the logger table.
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/********************************** Step 2 Verification **********************************
test query returns the rows from all three test scenarios. You should have an entry for 
King Arthur, but if you don’t add one
*****************************************************************************************/
/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/********************************** Step 3 Verification ********************************
Verify the addition to the common_lookup table with the following query
*****************************************************************************************/
COL common_lookup_table   FORMAT A14 HEADING "Common Lookup|Table"
COL common_lookup_column  FORMAT A14 HEADING "Common Lookup|Column"
COL common_lookup_type    FORMAT A14 HEADING "Common Lookup|Type"
SELECT common_lookup_table
,      common_lookup_column
,      common_lookup_type
FROM   common_lookup
WHERE  common_lookup_table = 'ITEM'
AND    common_lookup_column = 'ITEM_TYPE'
AND    common_lookup_type = 'BLU-RAY';

/********************************** Step 3 Verification *********************************
Verify that your item_trig trigger’s update event works by querying the modified results 
again. The query against the item table should display the results from the inserting and 
updating test cases
*****************************************************************************************/
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

/********************************** Step 3 Verification ***********************************
Verify the results from the logger table
******************************************************************************************/
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/*****************************************************************************************
Update the Star Wars row that you previously inserted into the item table to test your 
inserting event trigger with the following values
******************************************************************************************/
UPDATE item SET item_title = 'Star Wars: The Force Awakens' 
WHERE ITEM_BARCODE = 'B018FK66TU';

/*********************************** Step 3 Verification *********************************
verify the values in the item table after the deletion of the row
******************************************************************************************/
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

/************************************ Step 3 Verification *********************************
Query the logger table to see what transactions have occurred 
*******************************************************************************************/
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/* Delete the entry */
DELETE FROM item WHERE ITEM_BARCODE = 'B018FK66TU';

/*********************************** Step 3 Verification ***********************************
Use the following query to verify the values in the item table after the deletion of 
the row 
*******************************************************************************************/
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

/*********************************** Step 3 Verification ***********************************
Query the logger table with the familiar query one more time to see what transactions you 
have logged. The results show you the results of the INSERT, UPDATE, and DELETE testing
*******************************************************************************************/
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Close log file.
SPOOL OFF
