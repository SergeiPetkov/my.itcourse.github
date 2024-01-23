#!/bin/bash

echo "Начинаю установку пакетов..."
sudo apt install apache2 \
                 mysql-client \
                 ghostscript \
                 libapache2-mod-php \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip -y
echo "Установка пакетов завершена."

#
input="input.txt"


while read -r line
do
    IFS=' '
    read -ra values <<< "$line"
    
    WP_HOSTNAME=${values[0]}
    WP_NAME=${values[1]}
    WP_USER_NAME=${values[2]}
    WP_PASSWORD=${values[3]}
    DB_HOSTNAME=${values[4]}
    

    # Создаем каталог установки и назначаем права
    sudo mkdir -p /srv/www/$WP_NAME
    sudo chown usr1: /srv/www/$WP_NAME

    # Загружаем и устанавливаем WordPress
    curl https://wordpress.org/latest.tar.gz | sudo -u usr1 tar zx -C /srv/www/$WP_NAME

    echo "Установка WordPress для $WP_NAME завершена."

    # Создаем конфигурационный файл для сайта WordPress
    echo "<VirtualHost *:80>
        ServerName $WP_HOSTNAME
        DocumentRoot /srv/www/$WP_NAME/wordpress
        <Directory /srv/www/$WP_NAME/wordpress>
            Options FollowSymLinks
            AllowOverride Limit Options FileInfo
            DirectoryIndex index.php
            Require all granted
        </Directory>
        <Directory /srv/www/$WP_NAME/wordpress/wp-content>
            Options FollowSymLinks
            Require all granted
        </Directory>
    </VirtualHost>" | sudo tee /etc/apache2/sites-available/$WP_NAME.conf

    # Включаем конфигурацию сайта
    sudo a2ensite $WP_NAME

    # Включаем перезапись URL
    sudo a2enmod rewrite

    # Отключаем стандартную "Это работает" страницу
    sudo a2dissite 000-default

    # Перезагружаем Apache
    sudo service apache2 reload

    echo "Настройка Apache для $WP_NAME завершена."

    # Копируем файл конфигурации из шаблона
    cp /srv/www/$WP_NAME/wordpress/wp-config-sample.php /srv/www/$WP_NAME/wordpress/wp-config.php

    # Заменяем имена базы данных и пользователя в wp-config.php
    sed -i "s/'database_name_here'/'$WP_NAME'/g" /srv/www/$WP_NAME/wordpress/wp-config.php
    sed -i "s/'username_here'/'$WP_USER_NAME'/g" /srv/www/$WP_NAME/wordpress/wp-config.php
    sed -i "s/'password_here'/'$WP_PASSWORD'/g" /srv/www/$WP_NAME/wordpress/wp-config.php
    sed -i "s/'localhost'/'$DB_HOSTNAME'/g" /srv/www/$WP_NAME/wordpress/wp-config.php

    # Заменяем SALT в файле wp-config.php
    chars=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9")

    salt() {
        length="${#chars[@]}"
        result=""
        for i in {1..64}; do
            index=$(( RANDOM % length ))
            result="${result}${chars[index]}"
        done
        echo "$result"
    }

    # Читаем файл построчно, заменяем фразу и записываем во временный файл
    # Замена line на string
    while IFS= read -r string; do
        if [[ "$string" == *'put your unique phrase here'* ]]; then
            string="${string//put your unique phrase here/$(salt)}"
        fi
        echo "$string"
    done < /srv/www/$WP_NAME/wordpress/wp-config.php > /srv/www/$WP_NAME/wordpress/new-wp-config.php

    # Заменяем оригинальный файл временным файлом
    mv /srv/www/$WP_NAME/wordpress/new-wp-config.php /srv/www/$WP_NAME/wordpress/wp-config.php

done < "$input"

# Добавляю пару ip - Dns к файлу /etc/hosts
read -p "" ip_address_mysql

file_path="/etc/hosts"

# Используйте `echo` и перенаправление вывода `>>` для добавления строки в конец файла
echo "$ip_address_mysql mysqldb" | sudo tee -a $file_path