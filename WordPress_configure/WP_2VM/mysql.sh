#!/bin/bash

echo "Начинаю установку mysql-server..."

sudo apt install mysql-server -y

echo "Установка mysql-server завершена."

input="input.txt"


while read -r line
do
    IFS=' '
    read -ra values <<< "$line"
    
    WP_HOSTNAME=${values[0]}
    DB_NAME=${values[1]}
    WP_USER_NAME=${values[2]}
    WP_PASSWORD=${values[3]}
    DB_HOSTNAME=${values[4]}

###   netstat -ntlup
    # mysqldb 3306
### Проверить везде файлы конфигурации ### Скачать Mysql-client


    # Создаем базу данных и пользователя MySQL
    # Запускаем MySQL с правами root
    sudo mysql -u root <<EOF
    CREATE DATABASE $DB_NAME;
    CREATE USER '$WP_USER_NAME'@'%' IDENTIFIED BY '$WP_PASSWORD';
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON $DB_NAME.* TO '$WP_USER_NAME'@'%';
    FLUSH PRIVILEGES;
    quit;
   
EOF
    
    # Запускаем MySQL
    sudo service mysql start
    echo "MySQL настроен и запущен для $DB_NAME."

done < "$input"

#Заменяю хосты в файле конфигурации
config_file="/etc/mysql/mysql.conf.d/mysqld.cnf"
old_host="127.0.0.1"
new_host="0.0.0.0"

sudo sed -i "s/$old_host/$new_host/g" "$config_file"

sudo service mysql restart 

# Вывожу на экран ip сервера с mysql
interfaces=$(ip -o -4 addr show | awk '!/^[0-9]*: ?lo|link\/ether/ {split($4, a, "/"); print a[1]}')
echo Введи этот ip -=$interfaces=- при установке wordpress
echo Введи этот ip -=$interfaces=- при установке wordpress
echo Введи этот ip -=$interfaces=- при установке wordpress
echo Введи этот ip -=$interfaces=- при установке wordpress