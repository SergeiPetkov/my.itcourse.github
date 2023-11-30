Jenkins

Установка JAVA "17.0.8"
Потом Jenkins

На мастере нужно выполнить команды
sudo -i
su - jenkins
ssh-keygen (Finger print пропускаю)

#Установить на мастере плагин
SSH Build Agents plugin

#На агенте создаю пользователя с именем "jenkins", создаю для него домашний каталог, устанавливаю bash в качестве его оболочки.
sudo useradd -m -s /bin/bash jenkins

#В домашней директории добавить .ssh/authorized_keys
#И установить java
sudo apt install openjdk-11-jdk

#Добавление jenkins в sudo группу
sudo usermode -aG sudo jenkins  администратор

#Добавление jenkins в doker группу
sudo usermode -aG docker jenkins #Либо вручную /etc/groups

#В вебе мастера создаю Node
