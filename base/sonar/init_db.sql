DROP DATABASE sonar;
CREATE DATABASE sonar CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON sonar.* TO 'sonar'@'localhost' IDENTIFIED BY 'sonartest';
GRANT ALL PRIVILEGES ON sonar.* TO 'sonar'@'%' IDENTIFIED BY 'sonartest';
flush privileges;
