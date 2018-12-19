COL item_id     FORMAT 9999
COL item_title  FORMAT A44
COL text_size   FORMAT 999,999
SET PAGESIZE 99
SELECT   item_id
,        item_title
,        LENGTH(item_desc) AS text_size
FROM     item
WHERE    REGEXP_LIKE(item_title,'^Harry Potter.*$')
AND      item_type IN
          (SELECT common_lookup_id 
           FROM   common_lookup 
           WHERE  common_lookup_table = 'ITEM' 
           AND    common_lookup_column = 'ITEM_TYPE'
           AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'))
ORDER BY item_id;