# Развертывание 3 экземпляров WordPress на локальном хосте
## Пошаговое выполнение взято из оффициальной документации Ubuntu configurate Wordpress:
1. Установка пакетов
2. Создание массива с данными для установки WordPress
```bash
wordpress_sites=("wordpress1" "wordpress2" "wordpress3")
```
3. Цикл for для установки и конфигурации Apache и MySQL каждому экземпляру WordPress
```bash
for site in "${wordpress_sites[@]}"; do
```
4. Автоматизация изменений в /etc/hosts
