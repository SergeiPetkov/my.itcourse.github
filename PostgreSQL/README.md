# Практическая работа с PostgreSQL и PgAdmin в докере
## Развертывание PostgreSQL и PgAdmin в докере:
1. Создание compose.yml файла
```bash
version: "3.9"
services:
  postgres:
    image: postgres:14.8-alpine3.18
    environment:
      POSTGRES_DB: "postgres_db"
      POSTGRES_USER: "user"
      POSTGRES_PASSWORD: "1111"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  pgadmin:
    container_name: pgadmin_container
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: "example@mail.com"
      PGADMIN_DEFAULT_PASSWORD: "1111"
      PGADMIN_CONFIG_SERVER_MODE: "False"
    volumes:
      - pgadmin-data:/var/lib/pgadmin
    ports:
      - "5050:80"
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 1G
volumes:
  db-data:
  pgadmin-data:
```
2. Запуск compose.yml 
```bash
docker compose up -d
```
3. Информация о томах контейнера
```bash
docker volume inspect имя_контейнера
```
4. Логи контейнера. В них есть информация касаемая изменений в таблицах
```bash
docker logs имя_контейнера
```
