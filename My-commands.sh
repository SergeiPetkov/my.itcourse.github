net-stats #сначала установить
sudo apt install net-tools
sudo netstat -ntlup #прослушиваемые порты
netstat -ntlup
ps aux | grep (имя процесса) #процессы
df -h   #информация про жесткий диск в читаемом формате мб гб
grep -r 80 .
sudo vi var/log/  #логи тут  grep *.log .
lsblk #информация про Жесткий диск

sudo tail -f /var/log/apache2/*.log #просмотр логов *.log покажет логи всех файлов
sudo tail -f /var/log/nginx/*.log
sudo apt-get purge php*  # удаление всех версий программы
sudo apt-get remove --auto-remove example #
apt list --installed | grep php # вывести список всех пакетов - например php
cat test2.txt | grep 161 | wc  # 50  54  1321 выводит количство -строк -слов -символов
curl -s -k https://siteip.com |grep 192
sudo lshw  # подробная информация о железе
sudo lshw -C display -html > hardware_info.html
lsb_release -a 
for i in {1..100}; do curl http://siteip.com | grep 192; done >> test2.txt
cat test2.txt | grep 20 | wc
#route print в Windows маршрутизации все, посмотреть в LInux


ansible
ansible-playbook install_packages.yml --start-at-task="#имя таски" -vvvv # запуск с определнной таски
# -vvvv после команды дает доп информацию об ошибке


mysql
sudo mysql -u root -e "SHOW DATABASES;"
sudo mysql -u root -e "SELECT user, HOST FROM mysql. user;"


mariadb
sudo systemctl start mariadb
sudo mysql -u root -e "SHOW DATABASES;"
sudo mysql -u root -e "SELECT user, HOST FROM mysql. user;"


ubuntu
ps aux | grep new
df -h


github
git add .
git commit -m ""
git push -u origin main
#######
git status
git checkout -b "branch_name"
git add .
git commit -m "commit message"
git push origin branch_name
# git config --global user.name "SergeiPetkov"
# git config --global user.email "sp8997778@gmail.com"
# просмотр комитов -2 это нужное количество комитов 
git log --pretty=oneline -2 
# можно добавить тэги с версиями (в конце выписан хэш комита из git log --pretty=oneline -5 )
git tag -a v1.1 -m "Мой тег версии 1.1" 435f684
# просмотр тэгов 
git tag
# легковесный тэг 
git tag v1.2-lw
# по количеству эпох
git tag -a "v1.1-`date +%s`"
# пушит все новые таги
git push origin --tags
# склонирует ПОЛНОСТЬЮ весь репозиторий и просто переключится на ветку branch-name:
git clone http://whatever.git -b branch-name
# склонировать ТОЛЬКО конкретную ветку, и 2 последних комита тогда:
git clone --branch=branch-name --depth=2 --single-branch http://whatever.git
git checkout tag_name
# Удаление тага
git tag -d v1.3

apache2
sudo vi /etc/apache2/ports.conf #не работает с wordpress
sudo vi /etc/apache2/sites-available/wordpress1.conf
sudo systemctl reload apache2


httpd #centos
https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-centos-7 #ссылка на инструкции


#PHP 7.2
sudo yum install epel-release
sudo yum install   http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum install yum-utils -y
sudo  yum-config-manager --enable remi-php72
sudo  yum update
sudo  yum install php72


nginx                         # https://docs.nginx.com/ справка
https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04#prerequisites #инструкция 
sudo apt update
sudo apt install nginx
sudo ufw app list
#sudo ufw enable
sudo ufw allow 'Nginx HTTP' #или другой
# /var/www/html путь к сайту
sudo mkdir -p /var/www/koti.com/html
sudo chown -R usr1:usr1 /var/www/koti.com/html
sudo chmod -R 755 /var/www/koti.com
sudo vi /var/www/koti.com/html/index.html
sudo vi /etc/nginx/sites-available/koti.com
sudo ln -s /etc/nginx/sites-available/koti.com /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default 
sudo nginx -t
sudo systemctl restart nginx
        proxy_pass http://localhost:80; <----<< куда переводит прокси



ssl
https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04
sudo a2enmod ssl
sudo systemctl restart apache2                                                     # путь сменить                         # путь сменить
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/usr1/apache-selfsigned.key -out /home/usr1/apache-selfsigned.crt


ssl nginx
https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-20-04-1
sudo ufw enable
mkdir -p /home/usr1/ssl/certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/usr1/ssl/private/nginx-selfsigned.key -out /home/usr1/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/nginx/dhparam.pem 4096
#добавить сертификат и ключ в файл
sudo vi /etc/nginx/snippets/self-signed.conf
#
ssl_certificate /home/usr1/ssl/certs/nginx-selfsigned.crt;
ssl_certificate_key /home/usr1/ssl/private/nginx-selfsigned.key;

sudo vi /etc/nginx/snippets/ssl-params.conf #конфигурация с сильными настройками шифрования
ssl_protocols TLSv1.3;
ssl_prefer_server_ciphers on;
ssl_dhparam /etc/nginx/dhparam.pem; 
ssl_ciphers EECDH+AESGCM:EDH+AESGCM;
ssl_ecdh_curve secp384r1;
ssl_session_timeout  10m;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
# Disable strict transport security for now. You can uncomment the following
# line if you understand the implications.
#add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";

#потом делаю резервную копию
sudo cp /etc/nginx/sites-available/koti.com /etc/nginx/sites-available/koti.com.bk


curl -kI https://koti.com #для проверки
curl -kI http://koti.com


Docker
# инструкция установки https://docs.docker.com/engine/install/ubuntu/

docker inspect id | grep IP

sudo docker build -t example1 .
sudo docker run -it example1

# Удаление всех томов образов и отключенных контейнеров (Команда запрашивает ответ Y)
docker system prune -a

# команда добавляет строку с информацией о репозитории Docker в файл /etc/apt/sources.list.d/docker.list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Если не ставится vim в контейнер то использую
RUN apt-get update && apt-get install apt-file -y && apt-file update && apt-get install vim -y
# для обновления пакетов Дебиан можно использовать
RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' -e 's|security.debian.org|archive.debian.org/|g' -e '/stretch-updates/d' /etc/apt/sources.list




