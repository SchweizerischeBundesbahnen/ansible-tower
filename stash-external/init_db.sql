CREATE DATABASE stashdb CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON stashdb.* TO 'stashuser'@'82.220.39.130' IDENTIFIED BY 'stash14external';
GRANT ALL PRIVILEGES ON stashdb.* TO 'stashuser'@'82.220.39.129' IDENTIFIED BY 'stash14external';
GRANT ALL PRIVILEGES ON stashdb.* TO 'stashuser'@'172.17.0.%' IDENTIFIED BY 'stash14external';
flush privileges;
