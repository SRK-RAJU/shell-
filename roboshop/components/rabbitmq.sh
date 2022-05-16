#!/bin/bash

#source components/common.sh
#MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)
#
#COMPONENT_NAME=RabbitMQ
#COMPONENT=rabbitmq
#
#Print "Install ErLang"
#yum list installed | grep erlang &>>$LOG
#if [ $? -ne 0 ]; then
# yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG
#fi
#Stat $?
#
#Print "Setup YUM repositories for RabbitMQ"
#curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
#Stat $?
#
#Print "Install RabbitMQ"
#yum install rabbitmq-server -y &>>$LOG
#Stat $?
#
#Print "Start RabbitMQ"
#systemctl enable rabbitmq-server &>>$LOG && systemctl start rabbitmq-server &>>$LOG
#Stat $?
#
#Print "Setup Application User"
#rabbitmqctl list_users | grep roboshop &>>$LOG
#if [ $? -ne 0 ]; then
#  rabbitmqctl add_user roboshop roboshop123 &>>$LOG && rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
#else
#  rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
#fi
#Stat $?


source components/common.sh
checkRootUser

ECHO "Setup YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
statusCheck $?

ECHO "Install RabbitMQ & Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
statusCheck $?

ECHO "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>${LOG_FILE}  && systemctl start rabbitmq-server &>>${LOG_FILE}
statusCheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  ECHO "Create an Application User"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  statusCheck $?
fi

ECHO "Setup Application User Persmissions"
rabbitmqctl set_user_tags roboshop administrator  &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${LOG_FILE}
statusCheck $?