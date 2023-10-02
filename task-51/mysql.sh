#Устанавливаю на серевер 192.168.1.193 mysql
sudo apt install mysql-server

sudo mysql -u root

# команда \h выведет help
#        Ctrl+D выход

CREATE DATABASE siteip;
CREATE USER usr1@'%' IDENTIFIED BY '12345';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON siteip.* TO 'usr1'@'%';
FLUSH PRIVILEGES;
quit

sudo service mysql start

#серевер 192.168.1.193 перестал отвечать на запросы браузера
#Логи перестали писаться   sudo tail -f /var/log/apache2/*.log  там тишина
#Порт 80 молчит  sudo netstat -ntlup 


sudo apt-get install mysql-client  # ставлю туда - откуда буду управлять db
mysql -u usr1 -p -h 192.168.1.193
#вышла ошибка ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.1.193:3306' (111)
#sudo netstat -ntlup и вижу что 3306 - Localhost. Меняю бинды на нули

sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address            = 0.0.0.0
mysqlx-bind-address     = 0.0.0.0

sudo systemctl restart mysql
#Подключаюсь удаленно 
mysql -u usr1 -p -h 192.168.1.193 

#После конфигурации nginx reverse proxy подлючаюсь по ip nginx
mysql -u usr1 -p -h 192.168.1.10





