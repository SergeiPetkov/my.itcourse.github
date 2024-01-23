Keenetic Extra
# Доступ к веб интерфейсу 
Keenetic User Management -->
Administrative Services -->
HTTP port 80

# Настройки файрвола
Firewall -->
Action --> Permit
Protocol --> TCP/80

# Доступ к Proxmox, регистрация ip
Port Forwarding Rule -->
Protocol --> TCP
Single port open 58006 --> redirect 8006

# Доступ SSH, регистрация ip 
Protocol --> TCP/UDP
Single port open 50022 --> redirect 22

dig example.com # Получение информации о доменных именах и их DNS-записях

#QUESTION SECTION указывает, что выполняется запрос A-записи для "example.com".
#ANSWER SECTION предоставляет ответ: IP-адрес "93.184.216.34" связан с доменом "example.com".
#Query time указывает на время выполнения запроса.
#SERVER отображает DNS-сервер, который обработал запрос.

nsloop example.com # на linux и windows 

