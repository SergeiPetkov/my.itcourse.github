
#Моя любимая часть - РЕДАКТИРОВАНИЕ файла /etc/hosts на клиентском сервере!!! 

#Часть 3 Балансировщик нагрузки Nginx
sudo apt install nginx -y
sudo vi /etc/nginx/sites-available/siteip.conf
sudo ln -s /etc/nginx/sites-available/siteip.conf /etc/nginx/sites-enabled/
sudo mv sites-available/default sites-available/default.bk  #убрал его чтобы не cлушал :80
sudo unlink /etc/nginx/sites-enabled/default                #убрал его чтобы не cлушал :80
sudo vi sites-available/siteip.conf

#################################################
upstream app{
   server 192.168.1.20;
   server 192.168.1.193;
}
         
server {
    listen 80;
    listen [::]:80; #это для IPv6
     
    server_name siteip.com www.siteip.com;
              
    location / {
        proxy_pass http://app;
        include proxy_params;
    }
}

#################################################
sudo nginx -t
sudo systemctl restart nginx

#TEST - Обязательно сменить hosts!
for i in {1..100}; do curl http://siteip.com | grep 192; done >> test2.txt
 cat test2.txt | grep 20 | wc
#ГОТОВО

#Часть 4 (Опц) SSL на nginx порт 443
#SSL nginx Termination
 https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-load-balancing-with-ssl-termination
sudo mkdir -p /etc/nginx/ssl/siteip/private
sudo mkdir -p /etc/nginx/ssl/siteip/certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/siteip/private/nginx-selfsigned.key -out /etc/nginx/ssl/siteip/certs/nginx-selfsigned.crt

#Дописываю информацию в конфиг /etc/nginx/sites-available/siteip.conf   
##################################
server {
    listen 80;
    server_name siteip.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name siteip.com;


    ssl_certificate /etc/nginx/ssl/siteip/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/nginx/ssl/siteip/private/nginx-selfsigned.key;

    location / {
        proxy_pass http://back_server;
        proxy_set_header Host $host;
    }
}

upstream back_server {
    server 192.168.1.20:80;
    server 192.168.1.193:80;
}
####################################


sudo systemctl restart nginx

# Дополинительно - Возвращаюсь на серверы с apache2 и запрещаю подключение к его ip всем, кроме балансировщика
# Т.е. дропать пакеты присланные 'не' с ip nginx
# Сделал это только на сервере 192.168.1.20 для наблюдения за разницей при взаимодействии


# Часть 5 (Опц)  Mysql и reverse_proxy nginx
https://stackoverflow.com/questions/32246992/nginx-reverse-proxy-for-mysql
sudo vi /etc/nginx/nginx.conf
#Вствить в самом конце (главное что это в отдельном блоке от http)
##############
stream {
  upstream db {
    server 192.168.1.193:3306;
  }

  server {
    listen 3306;
    proxy_pass db;
  }
}
#####################