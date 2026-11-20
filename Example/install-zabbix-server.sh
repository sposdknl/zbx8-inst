#!/usr/bin/env bash

# Instalace databaze
sudo apt install -y mariadb-server

# Konfigurace databáze pro Zabbix
sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'SPOS_OSY_2025';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Restart MariaDB
sudo systemctl enable mariadb.service
sudo systemctl restart mariadb.service

# Install zabbix balicku
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2

# Import Zabbix DB schema
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pSPOS_OSY_2025 zabbix

# Nastaveni trust_function_creators On
sudo mysql -e "set global log_bin_trust_function_creators = 1;"

# Konfigurace 
sudo cp -v /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf-orig
sudo sed -i "s/# DBPassword=/DBPassword=SPOS_OSY_2025/g" /etc/zabbix/zabbix_server.conf

# Restart Zabbix komponent
sudo systemctl restart zabbix-server zabbix-agent2 apache2
sudo systemctl enable zabbix-server zabbix-agent2 apache2 

# Konfigure Zabbix frontend
sudo cp -v /vagrant/zabbix.conf.php /etc/zabbix/web/
sudo chmod 400 /etc/zabbix/web/zabbix.conf.php
sudo chown www-data:www-data /etc/zabbix/web/zabbix.conf.php

# EOF