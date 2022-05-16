#!/bin/bash

#source components/common.sh
#
#MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)
#
#
#COMPONENT_NAME=MySQL
#COMPONENT=mysql
#
#Print "Setup MySQL Repo"
#curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
#Stat $?
#
#Print "Install MariaDB Service"
#yum remove mariadb-libs -y &>>$LOG  && yum install mysql-community-server -y &>>$LOG
#Stat $?
#
#Print "Start MySQL Service"
#systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
#Stat $?
#
#DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
#NEW_PASSWORD="RoboShop@1"
#
#echo 'show databases;' | mysql -uroot -p"${NEW_PASSWORD}"  &>>$LOG
#if [ $? -ne 0 ]; then
#  Print "Changing the Default Password"
#  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_PASSWORD}';
#  uninstall plugin validate_password;" >/tmp/pass.sql
#  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>$LOG
#fi
#Stat $?
#
#
#DOWNLOAD "/tmp"
#
#Print "Load Schema"
#cd /tmp/mysql-main
#mysql -uroot -pRoboShop@1 <shipping.sql &>>$LOG
#Stat $?



source components/common.sh
checkRootUser


ECHO "Setup MySQL Yum repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
statusCheck $?

ECHO "Install MySQL Server"
yum install mysql-community-server -y &>>${LOG_FILE}
statusCheck $?

ECHO "Start MySQL Service"
systemctl enable mysqld  &>>${LOG_FILE} && systemctl start mysqld  &>>${LOG_FILE}
statusCheck $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/root-pass.sql

echo show databases | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then
  ECHO "Reset MySQL Password"
  mysql --connect-expired-password -u root -p${DEFAULT_PASSWORD} </tmp/root-pass.sql &>>${LOG_FILE}
  statusCheck $?
fi

echo 'show plugins;' | mysql -uroot -pRoboShop@1 2>>${LOG_FILE} | grep validate_password &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  ECHO "Uninstall Password Validation Plugin"
  echo "uninstall plugin validate_password;" |  mysql -uroot -pRoboShop@1 &>>$LOG_FILE
  statusCheck $?
fi

ECHO "Download Schema"
cd /tmp
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE && unzip -o  /tmp/mysql.zip &>>$LOG_FILE
statusCheck $?

ECHO "Load Schema"
cd /tmp/mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>${LOG_FILE}
statusCheck $?