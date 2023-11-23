#!/bin/bash

# Скрипт для миграции баз данных, и запуска приложения
python manage.py makemigrations && python manage.py migrate && python manage.py runserver 0:8001
