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

--Get Attribute Id of 'url_key' of product--
--Using LOCATE also--
SELECT *  FROM `eav_attribute` WHERE `attribute_code` LIKE 'url_key' AND LOCATE('product',`backend_model`) > 0;
SELECT `attribute_id` FROM `eav_attribute` WHERE `attribute_code` LIKE 'url_key' AND LOCATE('product',`backend_model`) > 0;
--Using LIKE only--
SELECT *  FROM `eav_attribute` WHERE `attribute_code` LIKE 'url_key' AND `backend_model` LIKE '%product%';
SELECT `attribute_id` FROM `eav_attribute` WHERE `attribute_code` LIKE 'url_key' AND `backend_model` LIKE '%product%';
--Get Attribute Id of 'url_key' of product--

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
WHERE t.table_schema = 'vivek_magento'
AND t.table_name LIKE 'perception%' ESCAPE '\\'
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
SELECT DISTINCT TABLE_NAME, COLUMN_NAME, CONCAT('ALTER TABLE `',TABLE_SCHEMA,'`.`',TABLE_NAME,'` DROP `',COLUMN_NAME,'`;') AS stmt
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE "perception%"
AND TABLE_SCHEMA='vivek_magento';

--JUST DROP do not list out--
SELECT CONCAT('ALTER TABLE `',TABLE_SCHEMA,'`.`',DISTINCT TABLE_NAME,'` DROP `',COLUMN_NAME,'`;') AS stmt
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE "perception%"
AND TABLE_SCHEMA='vivek_magento';

--ALTER TABLE x DROP a;

SELECT DISTINCT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE "elite%"
AND TABLE_SCHEMA='vivek_magento';
--Find all tables having specific "columns" end--


--Vehicle fits module uninstall database & data start--
SELECT CONCAT('DROP TABLE `',t.table_schema,'`.`',t.table_name,'`;') AS stmt
FROM information_schema.tables t
WHERE t.table_schema = 'vivek_magento'
AND t.table_name LIKE 'perception%' ESCAPE '\\'
ORDER BY t.table_name;

SELECT CONCAT('ALTER TABLE `',TABLE_SCHEMA,'`.`',TABLE_NAME,'` DROP `',COLUMN_NAME,'`;') AS stmt
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE "perception%"
AND TABLE_SCHEMA='vivek_magento';
--Vehicle fits module uninstall database & data finish--

--Generate drop/truncate table queries for all tables in a db--
SELECT CONCAT('DROP TABLE IF EXISTS ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '<database_name>' LIMIT 364, 0;

SELECT CONCAT('TRUNCATE ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '<database_name>' LIMIT 364, 0;

--Clear only session tables in magento--
SET @truncateAllTbls = (SELECT CONCAT('TRUNCATE ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '<database_name>' AND TABLE_NAME LIKE '%_session%');
SELECT CONCAT('SET FOREIGN_KEY_CHECKS=0;', @truncateAllTbls, 'SET FOREIGN_KEY_CHECKS=1;');

SELECT salary INTO @variable1 FROM employee_info WHERE emp_id = 12345678 LIMIT 1;
--or--
TRUNCATE api_session;
TRUNCATE core_session;
TRUNCATE dataflow_session;
TRUNCATE persistent_session;
--Clear only session tables in magento end--

SELECT CONCAT('DROP TABLE IF EXISTS ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'magento_cookpack' LIMIT 364;

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

--eg.--
SELECT *  FROM `core_config_data` WHERE `path` LIKE '%base_url%'
UPDATE `core_config_data` SET `value` = "http://115.112.143.170/ECO/mag/cookpack/" WHERE `path` LIKE '%base_url%';
UPDATE `core_config_data` SET `value` = "http://115.112.143.170/ECO/mag/ooberpad/" WHERE `path` LIKE '%base_url%';
UPDATE `core_config_data` SET `value` = "http://115.112.143.170/ECO/mag/kaffex/" WHERE `path` LIKE '%base_url%';
UPDATE `core_config_data` SET `value` = "http://192.168.0.160/226/mag/kaffex/" WHERE `path` LIKE '%base_url%';
UPDATE `core_config_data` SET `value` = "http://192.168.0.160/226/mag/kidsa/" WHERE `path` LIKE '%base_url%';

--or--

UPDATE table SET field = REPLACE(field, 'string', 'anothervalue') WHERE field LIKE '%string%';
UPDATE `core_config_data` SET `value` = REPLACE(`value`, '<old_path_partial>', '<new_path_partial>') WHERE `path` LIKE '%base_url%';
UPDATE `core_config_data` SET `value` = REPLACE(`value`, '192.168.0.160/226/mag', '192.168.0.160/vivek') WHERE `path` LIKE '%base_url%';
UPDATE `core_config_data` SET `value` = REPLACE(`value`, '192.168.0.160/vivek', '115.112.143.170/ECO/mag') WHERE `path` LIKE '%base_url%';
--Update url after uploading magento files & setting up database finish--

--Generate Drop all tables in database query--
SET FOREIGN_KEY_CHECKS = 0;
SET GROUP_CONCAT_MAX_LEN=32768;
SET @tables = NULL;
SELECT GROUP_CONCAT('`', table_name, '`') INTO @tables
  FROM information_schema.tables
  WHERE table_schema = (SELECT DATABASE());
SELECT IFNULL(@tables,'dummy') INTO @tables;

SET @tables = CONCAT('DROP TABLE IF EXISTS ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET FOREIGN_KEY_CHECKS = 1;

--Generate Drop all views in database query--
SET FOREIGN_KEY_CHECKS = 0;
SET GROUP_CONCAT_MAX_LEN=32768;
SET @views = NULL;
SELECT GROUP_CONCAT('`', TABLE_NAME, '`') INTO @views
  FROM information_schema.views
  WHERE table_schema = (SELECT DATABASE());
SELECT IFNULL(@views,'dummy') INTO @views;

SET @views = CONCAT('DROP VIEW IF EXISTS ', @views);
PREPARE stmt FROM @views;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SET FOREIGN_KEY_CHECKS = 1;

--Magento Clear Log & Report Tables begin--
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE `dataflow_batch_export`;
TRUNCATE `dataflow_batch_import`;
TRUNCATE `log_customer`;
TRUNCATE `log_quote`;
TRUNCATE `log_summary`;
TRUNCATE `log_summary_type`;
TRUNCATE `log_url`;
TRUNCATE `log_url_info`;
TRUNCATE `log_visitor`;
TRUNCATE `log_visitor_info`;
TRUNCATE `log_visitor_online`;
TRUNCATE `report_viewed_product_index`;
TRUNCATE `report_compared_product_index`;
TRUNCATE `report_event`;
TRUNCATE `index_event`;
TRUNCATE `catalog_compare_item`;
SET FOREIGN_KEY_CHECKS = 1;
--Magento Clear Log & Report Tables end--

--Magento Add Admin User manually start--
LOCK TABLES `admin_role` WRITE , `admin_user` WRITE;
SET @SALT = "rp";
SET @PASS = CONCAT(MD5(CONCAT( @SALT , "password") ), CONCAT(":", @SALT ));
SELECT @EXTRA := MAX(extra) FROM admin_user WHERE extra IS NOT NULL;
INSERT INTO `admin_user` (firstname,lastname,email,username,password,created,lognum,reload_acl_flag,is_active,extra,rp_token_created_at) 
VALUES ('Firstname','Lastname','email@example.com','myuser',@PASS,NOW(),0,0,1,@EXTRA,NOW());
INSERT INTO `admin_role` (parent_id,tree_level,sort_order,role_type,user_id,role_name) 
VALUES (1,2,0,'U',(SELECT user_id FROM admin_user WHERE username = 'myuser'),'Firstname');
UNLOCK TABLES;
--example
LOCK TABLES `admin_role` WRITE , `admin_user` WRITE;
SET @SALT = "rp";
SET @PASS = CONCAT(MD5(CONCAT( @SALT , 'admin11') ), CONCAT(":", @SALT ));
SELECT @EXTRA := MAX(extra) FROM admin_user WHERE extra IS NOT NULL;
INSERT INTO `admin_user` (firstname,lastname,email,username,password,created,lognum,reload_acl_flag,is_active,extra,rp_token_created_at) 
VALUES ('Vivek','Shah','admin@localweb.com','admin',@PASS,NOW(),0,0,1,@EXTRA,NOW());
INSERT INTO `admin_role` (parent_id,tree_level,sort_order,role_type,user_id,role_name) 
VALUES (1,2,0,'U',(SELECT user_id FROM admin_user WHERE username = 'admin'),'Vivek');
UNLOCK TABLES;
--Magento Add Admin User manually finish--

--Magento Change product type in database begin--
UPDATE `catalog_product_entity` SET `type_id` = '<desired_type>' WHERe `sku` = '<product_sku>';
UPDATE `catalog_product_entity` SET `type_id` = 'simple' WHERe `sku` = 'recipe_meal1'
--or by Entity_Id--
UPDATE `catalog_product_entity` SET `type_id` = '<desired_type>' WHERe `entity_id` = <product_id>;
UPDATE `catalog_product_entity` SET `type_id` = 'simple' WHERe `entity_id` = 16;
--Magento Change product type in database end--
