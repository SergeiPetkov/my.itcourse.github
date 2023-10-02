sudo apt install apache2 -y
sudo apt install php -y

sudo mkdir -p /var/www/siteip/html
sudo vi /var/www/siteip/html/index.php
###########################
<!DOCTYPE html>
<html>
<head>
    <title>Server IP Address</title>
</head>
<body>
    <h1>Server IP Address:</h1>
    <p><?php echo $_SERVER['SERVER_ADDR']; ?></p>


</body>
</html>
###########################

sudo vi /etc/apache2/sites-available/siteip.conf
####
Listen 80

<VirtualHost *:80>
    ServerName siteip.com
    DocumentRoot /var/www/siteip/html/
</VirtualHost>
####


# Дополинительно - Возвращаюсь на серверы с apache2 и запрещаю подключение к его ip всем, кроме балансировщика
# Т.е. дропать пакеты присланные 'не' с ip nginx
# https://httpd.apache.org/docs/2.4/howto/access.html#host   инструкция
#Редактирую /etc/apache2/sites-available/siteip.conf
######################### 
Listen 192.168.1.193:80

<VirtualHost *:80>
    ServerName siteip.com
    DocumentRoot /var/www/siteip/html/

    <Directory /var/www/siteip/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require ip 192.168.1.10
        ErrorDocument 403 "Access is denied!!! You do not have permission to access this resource!!!"
    </Directory>
</VirtualHost>
########################
service apache2 restart






