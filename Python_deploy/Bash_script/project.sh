#!/bin/bash

# Перед запуском скрипта

# 1. Создать файлик my-docker.txt с токеном от docker hub в директории скрипта 
# 2. Необходимо указать значения Ip сервера и версии проекта (от v1.1 до v1.4)
# Пример ./project.sh 169 v1.1

# Назначение перменных
ip_4=$1
project_version=$2
timestamp=$(date +'%Y%m%d%H%M')
IMAGE_TAG=$project_version-$timestamp
echo $IMAGE_TAG

# Скачивание репозитория и переход к определенной версии проекта
git clone --branch=deploy --single-branch http://github.com/SergeiPetkov/simple-django-project.git
cd simple-django-project
git checkout $project_version

# Токен для Docker Hub
cat /home/usr1/my-docker.txt | docker login --username sergeypetkov --password-stdin

# Сборка докер образа 
docker build --build-arg PROJECT_V=$project_version -t django:$IMAGE_TAG .

# Добавление метки образу
docker tag django:$IMAGE_TAG sergeypetkov/django:$IMAGE_TAG

# Отправка образа в удаленный репозиторий
docker push sergeypetkov/django:$IMAGE_TAG

# Отправление compose.yaml на удаленный сервер
scp -o StrictHostKeyChecking=accept-new /home/usr1/simple-django-project/compose.yaml usr1@192.168.1.$ip_4:/home/usr1/simple-django-project/

# Запуск контейнеров на удаленном сервере
ssh -o StrictHostKeyChecking=accept-new usr1@192.168.1.$ip_4 "TAG=$IMAGE_TAG docker compose -f /home/usr1/simple-django-project/compose.yaml up -d --force-recreate"


