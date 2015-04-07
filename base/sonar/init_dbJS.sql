DROP DATABASE sonarJS;
CREATE DATABASE sonarJS CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON sonarJS.* TO 'sonarJS'@'localhost' IDENTIFIED BY 'sonarJStest';
GRANT ALL PRIVILEGES ON sonarJS.* TO 'sonarJS'@'%' IDENTIFIED BY 'sonarJStest';
flush privileges;
