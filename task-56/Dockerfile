# Операционная система и ее версия
FROM ubuntu:22.04

# Контактная информация
LABEL maintainer="sergey@example.com" \
      description="Apache2 and PHP, port 80"

# Убирает интерактивный режим при установки ОС
ARG DEBIAN_FRONTEND=noninteractive

# Установка Apache2 и PHP, после чего очистка кэша и временных файлов
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Копирование index.php в каталог контейнера
COPY ./sitephp /var/www/sitephp/html

# Копирование конфигурации в каталог контейнера
COPY ./sitephp.conf /etc/apache2/sites-available/sitephp.conf

# Создание новой линк ссылки и удаление сайта по умолчанию
RUN a2enmod rewrite \
    && a2dissite 000-default \
    && a2ensite sitephp

# Исполняемый файл для запуска и управления apache2
ENTRYPOINT ["apache2ctl"]

# Включает процесс в активном режиме
CMD ["-D", "FOREGROUND"]

# Прослушиваемый порт в запущенном контейнере
EXPOSE 80