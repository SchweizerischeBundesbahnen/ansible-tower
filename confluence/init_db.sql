-- DROP DATABASE confluencedb;
-- REVOKE  ALL PRIVILEGES ON `confluencedb`.* FROM 'confluence'@'localhost';
-- DROP USER  'confluence'@'localhost';

CREATE DATABASE confluencedb CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON confluencedb.* TO 'confluence'@'172.17.0.%' IDENTIFIED BY 'confluenceINTpass';
flush privileges;
