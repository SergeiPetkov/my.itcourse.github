

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

