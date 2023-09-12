#!/bin/bash
input="/home/usr1/work/Task-26/input.txt"
  

i=0
while read -r line
do
    IFS=' '
    i=$((i+1))
    echo "-=$i сайт=-"
    read -ra values <<< "$line"
    echo "DNS: ${values[0]}"
    echo "Name: ${values[1]}"
    echo "User: ${values[2]}"
    echo "Pass: ${values[3]}"
done < "$input"



