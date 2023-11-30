#!/bin/bash

# Включение PPA официального проекта (personal package archive) в список источников системы
echo -ne "\n" | sudo apt-add-repository ppa:ansible/ansible

sudo apt update

sudo apt install ansible











