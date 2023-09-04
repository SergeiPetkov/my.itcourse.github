#!/bin/bash

# Проверяем наличие curl, если не установлен, устанавливаем
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)

# Загружаем GPG-ключ для репозитория GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

# Устанавливаем разрешения для ключа GPG
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

# Добавляем запись о репозитории GitHub CLI в файл
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Обновляем информацию о доступных пакетах
sudo apt update

# Устанавливаем GitHub CLI
sudo apt install gh -y

echo "GitHub CLI успешно установлен."

