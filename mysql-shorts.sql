--Set Auto increment after deleting records
SET @num := 0;
UPDATE <tablename> SET id = @num := (@num+1);
ALTER TABLE <tablename> AUTO_INCREMENT = 1;

--Magento delete all products and reset product id auto_increment to 1--
DELETE FROM `catalog_product_entity`;
ALTER TABLE `catalog_product_entity` AUTO_INCREMENT = 1;

--Magento delete all categories and reset basic category settings--
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE `catalog_category_entity`;
TRUNCATE TABLE `catalog_category_entity_datetime`;
TRUNCATE TABLE `catalog_category_entity_decimal`;
TRUNCATE TABLE `catalog_category_entity_int`;
TRUNCATE TABLE `catalog_category_entity_text`;
TRUNCATE TABLE `catalog_category_entity_varchar`;
TRUNCATE TABLE `catalog_category_product`;
TRUNCATE TABLE `catalog_category_product_index`;
INSERT INTO `catalog_category_entity`(`entity_id`,`entity_type_id`,`attribute_set_id`,`parent_id`,`created_at`,`updated_at`,`path`,`position`,`level`,`children_count`) VALUES (1,3,0,0,'0000-00-00 00:00:00','2009-02-20 00:25:34','1',1,0,1),(2,3,3,0,'2009-02-20 00:25:34','2009-02-20 00:25:34','1/2',1,1,0);
INSERT INTO `catalog_category_entity_int`(`value_id`,`entity_type_id`,`attribute_id`,`store_id`,`entity_id`,`value`) VALUES (1,3,32,0,2,1),(2,3,32,1,2,1);
INSERT INTO `catalog_category_entity_varchar`(`value_id`,`entity_type_id`,`attribute_id`,`store_id`,`entity_id`,`value`) VALUES (1,3,31,0,1,"Root Catalog"),(2,3,33,0,1,"root-catalog"),(3,3,31,0,2,"Default Category"),(4,3,39,0,2,'PRODUCTS'),(5,3,33,0,2,"default-category");
SET FOREIGN_KEY_CHECKS=1;

--Magento Product URL Rewrite Issue fix start--
--STEP1--
TRUNCATE TABLE `core_url_rewrite`;
TRUNCATE TABLE `log_url_info`;
--step2--
--Clear cache--
--step3--
--Reindex all indexes--
--may be step4--
--Export the `catalog_product_entity_varchar` table with "Disable foreign key checks" and "Add Drop table query" options selected.--
SELECT * FROM `catalog_product_entity_varchar` WHERE `value` LIKE BINARY "<old_url_key>%";
DELETE FROM `catalog_product_entity_varchar` WHERE `value` LIKE BINARY "<old_url_key>%";
--Reindex again maybe--
--Magento Product URL Rewrite Issue fix finish--


--Magento Category URL Rewrite Issue fix start--
--STEP1--
TRUNCATE TABLE `core_url_rewrite`;
TRUNCATE TABLE `log_url_info`;
--step2--
--Clear cache--
--step3--
--Reindex all indexes--
--may be step4--
--Export the `catalog_category_entity_varchar` table with "Disable foreign key checks" and "Add Drop table query" options selected.--
SELECT * FROM `catalog_category_entity_varchar` WHERE `value` LIKE BINARY "<old_url_key>%";
DELETE FROM `catalog_category_entity_varchar` WHERE `value` LIKE BINARY "<old_url_key>%";
--Reindex again maybe--
--Magento Category URL Rewrite Issue fix finish--

--Drop all tables whose name starts with--
declare @cmd varchar(4000)
declare cmds cursor for 
select 'drop table [' + Table_Name + ']'
from INFORMATION_SCHEMA.TABLES
where Table_Name like 'prefix%'

open cmds
while 1=1
begin
    fetch cmds into @cmd
    if @@fetch_status != 0 break
    exec(@cmd)
end
close cmds;
deallocate cmds

--or--
---example---
SELECT CONCAT('DROP TABLE `',t.table_schema,'`.`',t.table_name,'`;') AS stmt
FROM information_schema.tables t
WHERE t.table_schema = 'mydatabase'
AND t.table_name LIKE 'aggregate\_temp%' ESCAPE '\\'
ORDER BY t.table_name
  
SELECT CONCAT('DROP TABLE `',t.table_schema,'`.`',t.table_name,'`;') AS stmt
FROM information_schema.tables t
WHERE t.table_schema = '<database_name>'
AND t.table_name LIKE '<table_name>%' ESCAPE '\\'
ORDER BY t.table_name

--if table names long then enable "show full texts" in options--
--Drop all tables whose name starts with end--

--Find all tables having specific "columns" start--
SELECT DISTINCT TABLE_NAME, COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('<column_name1>','<column_name2>',...)
AND TABLE_SCHEMA='<database_name>';

--or with LIKE--
SELECT DISTINCT TABLE_NAME, COLUMN_NAME, CONCAT('ALTER TABLE `',TABLE_SCHEMA,'`.`',TABLE_NAME,'` DROP `',COLUMN_NAME,'`;') AS stmt
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '<column_name>%'
AND TABLE_SCHEMA='<database_name>';

--example--
--JUST DROP do not list out--
--ALTER TABLE x DROP a;

-Find all tables having specific "columns" end--


--Generate drop/truncate table queries for all tables in a db--
SELECT concat('DROP TABLE IF EXISTS ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '<database_name>' LIMIT 364, 0;

SELECT concat('TRUNCATE ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '<database_name>' LIMIT 364, 0;

--Add before the generated sql--
SET FOREIGN_KEY_CHECKS = 0;
--Add after the generated sql--
SET FOREIGN_KEY_CHECKS = 1;

--or stored procedure way--
DROP PROCEDURE IF EXISTS `drop_all_tables`;

DELIMITER $$
CREATE PROCEDURE `drop_all_tables`()
BEGIN
    DECLARE _done INT DEFAULT FALSE;
    DECLARE _tableName VARCHAR(255);
    DECLARE _cursor CURSOR FOR
        SELECT table_name 
        FROM information_schema.TABLES
        --WHERE table_schema = SCHEMA();--
        WHERE TABLE_SCHEMA = '<db_name>';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

    SET FOREIGN_KEY_CHECKS = 0;

    OPEN _cursor;

    REPEAT FETCH _cursor INTO _tableName;

    IF NOT _done THEN
        SET @stmt_sql = CONCAT('DROP TABLE IF EXISTS ', _tableName);
        PREPARE stmt1 FROM @stmt_sql;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;
    END IF;

    UNTIL _done END REPEAT;

    CLOSE _cursor;
    SET FOREIGN_KEY_CHECKS = 1;
END$$

DELIMITER ;

call drop_all_tables(); 

DROP PROCEDURE IF EXISTS `drop_all_tables`;
--Generate drop/truncate table queries for all tables in a db end--

--Update url after uploading magento files & setting up database start--
SELECT *  FROM `core_config_data` WHERE `path` LIKE '%base_url%'
UPDATE `core_config_data` SET `value` = "[new_url]" WHERE `path` LIKE '%base_url%';

--or--

UPDATE table SET field = REPLACE(field, 'string', 'anothervalue') WHERE field LIKE '%string%';
UPDATE `core_config_data` SET `value` = REPLACE(`value`, '<old_path_partial>', '<new_path_partial>') WHERE `path` LIKE '%base_url%';
--Update url after uploading magento files & setting up database finish--

--Get unused attributes and their values from Magento database start--
SELECT o.*, v.*, a.*
FROM `eav_attribute` a
INNER JOIN `eav_attribute_option` o ON a.`attribute_id` = o.`attribute_id`
INNER JOIN `eav_attribute_option_value` v ON v.`option_id` = o.`option_id`
INNER JOIN `eav_entity_type` t ON t.`entity_type_id` = a.`entity_type_id`
LEFT JOIN `catalog_product_entity_int` pi ON o.`option_id` = pi.`value` AND o.`attribute_id` = pi.`attribute_id`
LEFT JOIN `catalog_product_entity_varchar` pv ON FIND_IN_SET(o.`option_id`, pv.`value`) AND o.`attribute_id` = pv.`attribute_id`
WHERE pi.`entity_id` IS NULL
AND pv.`entity_id` IS NULL
AND t.`entity_type_code` = "catalog_product";
--Get unused attributes and their values from Magento database finish--

-- Truncate Multiple Tables from Database
DECLARE @delimiter CHAR(1),
        @tableList VARCHAR(MAX),
        @tableName VARCHAR(20),
        @currLen INT

SET @delimiter = ','

-- SET @tableList = 'table1,table2,table3'
SELECT @tableList := GROUP_CONCAT(`table_name`) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '[DatabaseName]' AND TABLE_NAME LIKE '%order%' OR TABLE_NAME LIKE '%product%';

WHILE LEN(@tableList) > 0
BEGIN
    SELECT @currLen =
    (
        CASE charindex( @delimiter, @tableList )
            WHEN 0 THEN len( @tableList  )
            ELSE ( charindex( @delimiter, @tableList  ) -1 )
        END
    )

    SELECT @tableName = SUBSTRING (@tableList,1,@currLen )

    TRUNCATE TABLE @tableName

    SELECT tableList =
    (
        CASE ( len( @tableList ) - @currLen  )
            WHEN 0 THEN ''
            ELSE right( @tableList, len( @tableList ) - @currLen  - 1 )
        END
    )
END;
