
#установка apache2 на Ubuntu
https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-20-04-ru


# PHP код, для вывода ip сервера на странице сайта
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