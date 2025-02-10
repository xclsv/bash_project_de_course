#!/bin/bash

exec > report.txt 2>&1

ls -l
pwd

cat <<EOL > access.log
192.168.1.1 - - [28/Jul/2024:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [28/Jul/2024:12:35:56 +0000] "POST /login HTTP/1.1" 200 567
192.168.1.3 - - [28/Jul/2024:12:36:56 +0000] "GET /home HTTP/1.1" 404 890
192.168.1.1 - - [28/Jul/2024:12:37:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.4 - - [28/Jul/2024:12:38:56 +0000] "GET /about HTTP/1.1" 200 432
192.168.1.2 - - [28/Jul/2024:12:39:56 +0000] "GET /index.html HTTP/1.1" 200 1234
EOL

{
echo "Отчет о логе веб-сервера"
echo "========================"
awk '/HTTP/ { count++ } END { print "Общее количество запросов:", count }' access.log
awk '!seen[$1]++ {count++} END {print "Количество уникальных IP-адресов:", count}' access.log
echo "Количество запросов по методам:" 
awk '{gsub(/"/, "", $6); methods[$6]++} END {for (method in methods) print methods[method], method}' access.log
echo -n "Самый популярный URL: " && awk '{print $7}' access.log | sort | uniq -c | sort -nr | head -1
} > report.txt

exec > /dev/tty 2>&1
echo "Отчет сохранен в файл report.txt"