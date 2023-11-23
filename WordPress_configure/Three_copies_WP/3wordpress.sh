#!/bin/bash

# Этот скрипт устанавливает пакеты и настраивает Apache для WordPress.
echo "Начинаю установку пакетов..."
sudo apt install apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
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

# Создаем массив с данными для установки WordPress
wordpress_sites=("wordpress1" "wordpress2" "wordpress3")

for site in "${wordpress_sites[@]}"; do

    # Создаем каталог установки и назначаем права
    sudo mkdir -p /srv/www/$site
    sudo chown usr1: /srv/www/$site

    # Загружаем и устанавливаем WordPress
    curl https://wordpress.org/latest.tar.gz | sudo -u usr1 tar zx -C /srv/www/$site

    echo "Установка WordPress для $site завершена."

    # Создаем конфигурационный файл для сайта WordPress
    echo "<VirtualHost *:80>
        ServerName $site.com
        DocumentRoot /srv/www/$site/wordpress
        <Directory /srv/www/$site/wordpress>
            Options FollowSymLinks
            AllowOverride Limit Options FileInfo
            DirectoryIndex index.php
            Require all granted
        </Directory>
        <Directory /srv/www/$site/wordpress/wp-content>
            Options FollowSymLinks
            Require all granted
        </Directory>
    </VirtualHost>" | sudo tee /etc/apache2/sites-available/$site.conf

    # Включаем конфигурацию сайта
    sudo a2ensite $site

    # Включаем перезапись URL
    sudo a2enmod rewrite

    # Отключаем стандартную "Это работает" страницу
    sudo a2dissite 000-default

    # Перезагружаем Apache
    sudo service apache2 reload

    echo "Настройка Apache для $site завершена."

    # Создаем базу данных и пользователя MySQL
    # Запускаем MySQL с правами root
    sudo mysql -u root <<EOF
    CREATE DATABASE $site;
    CREATE USER '$site'@'127.0.0.1' IDENTIFIED BY 'usr1';
    GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON $site.* TO '$site'@'127.0.0.1';
    FLUSH PRIVILEGES;
    quit

EOF
    

    # Запускаем MySQL
    sudo service mysql start

    echo "MySQL настроен и запущен для $site."

    # Копируем файл конфигурации из шаблона
    cp /srv/www/$site/wordpress/wp-config-sample.php /srv/www/$site/wordpress/wp-config.php

    # Заменяем имена базы данных и пользователя в wp-config.php
    sed -i "s/'database_name_here'/'$site'/g" /srv/www/$site/wordpress/wp-config.php
    sed -i "s/'username_here'/'$site'/g" /srv/www/$site/wordpress/wp-config.php
    sed -i "s/'password_here'/'usr1'/g" /srv/www/$site/wordpress/wp-config.php
    sed -i "s/'localhost'/'127.0.0.1'/g" /srv/www/$site/wordpress/wp-config.php

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
    while IFS= read -r line; do
        if [[ "$line" == *'put your unique phrase here'* ]]; then
            line="${line//put your unique phrase here/$(salt)}"
        fi
        echo "$line"
    done < /srv/www/$site/wordpress/wp-config.php > /srv/www/$site/wordpress/new-wp-config.php

    # Заменяем оригинальный файл временным файлом
    mv /srv/www/$site/wordpress/new-wp-config.php /srv/www/$site/wordpress/wp-config.php

done

# Получаем список активных сетевых интерфейсов и их IP-адресов
interfaces=$(ip -o -4 addr show | awk '!/^[0-9]*: ?lo|link\/ether/ {split($4, a, "/"); print a[1]}')

# Проверяем, есть ли активные интерфейсы
if [ -z "$interfaces" ]; then
    echo "Не удалось определить активные сетевые интерфейсы."
    exit 1
fi

# Определяем IP-адрес первого активного интерфейса
ip_address=$(echo "$interfaces" | head -n 1)

# Проверка, был ли найден IP-адрес
if [ -z "$ip_address" ]; then
    echo "Не удалось определить IP-адрес виртуальной машины."
    exit 1
fi

# Строки для добавления
lines_to_add=(
    "$ip_address wordpress1.com"
    "$ip_address wordpress2.com"
    "$ip_address wordpress3.com"
)

# Начальная строка, с которой нужно добавить новые строки (нумерация с 1)
start_line=3

# Преобразуем строки в одну строку с разделителями '\n'
lines=$(printf "%s\n" "${lines_to_add[@]}")

# Создаем временный файл для обновленного содержимого
tempfile=$(mktemp)

# Используем awk для вставки строк в начало файла hosts
awk -v lines="$lines" -v start_line="$start_line" 'NR == start_line {print lines} {print}' /etc/hosts > "$tempfile"

# Заменяем исходный файл обновленным файлом
sudo mv "$tempfile" /etc/hosts
