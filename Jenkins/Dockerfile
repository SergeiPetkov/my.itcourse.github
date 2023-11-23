# Дистрибутив базового образа
FROM python:3.7.2

# Контактная информация
LABEL maintainer="sp8997778@gmail.com" \
      description="python:v3.7.2 for simple-django-project"

# Значение переменной при запуске скрипта
#ARG PROJECT_V

# Установка, создание и активация виртуальной среды
RUN pip install virtualenv \
    && mkdir /envs \
    && virtualenv /envs/ \
    && . /envs/bin/activate

# Обновления необходимые перед установкой зависимостей (ошибка You should consider upgrading via the 'pip install --upgrade pip' command.)
RUN pip install --upgrade setuptools \
    && pip install --upgrade pip

#  Копирование файлов и каталогов из локальной файловой системы
#COPY . /simple-django-project

# Установка рабочей директории
WORKDIR /simple-django-project

COPY requirements.txt /simple-django-project/

# Установка всех зависимостей из requirements.txt
RUN pip install -r requirements.txt

COPY panorbit /simple-django-project/panorbit
COPY static /simple-django-project/static
COPY templates /simple-django-project/templates
COPY world /simple-django-project/world
COPY manage.py /simple-django-project/
COPY run.sh /simple-django-project/

# Режим ожидания
CMD ["/simple-django-project/run.sh"]

