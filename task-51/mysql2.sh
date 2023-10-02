#Впишу тут конфиги

sudo vi /etc/nginx/sites-available/siteip.conf

#############
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
#########################

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