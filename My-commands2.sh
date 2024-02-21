

# PHP код, для вывода ip сервера на странице сайта. Расширение файла меняю на .php
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

# Репозиторий Debian stretch repositories 404 Not Found
RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list


######################
docker php mysql nginx урок по установке
https://www.youtube.com/watch?v=Q0OwEKtncPc&t=996s
###############################################################
Dockerfile apache2 php
###############################################################
sudo docker build -t example1 .
sudo docker run -it example1

# Удаление всех томов образов и отключенных контейнеров (Команда запрашивает ответ Y)
docker system prune -a

swaks --to akondratov1990@gmail.com --from sp8997778@gmail.com --server smtp.google.com --port 587 --tls --auth LOGIN  --header "Subject: Тестовое письмо" --body "Это тестовое письмо"
swaks --to akondratov1990@gmail.com --server smtp.ionos.de:587 --auth LOGIN
# установка VIM в DEBIAN
apt-get update && apt-get install apt-file -y && apt-file update && apt-get install vim -y

Proxmox 
Выбрать VM -> Hardware -> Hard dicsc -> Disc action -> + Resize -> ввод памяти
sudo lvresize --size +10G --resizefs /dev/mapper/ubuntu--vg-ubuntu--lv  (имя записанно df -h)



PostgreSQL
# Подключение
psql -U user -d postgres_db 

\dt
SELECT * FROM name_tables;


