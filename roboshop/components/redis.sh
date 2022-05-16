#!/bin/bash
#source components/common.sh
#MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1 )
#
#Print "Installing EPEL RELEASE"
#yum install epel-release yum-utils -y
#Start $?
#
#Print "Installing redis repos"
#sudo yum install yum-utils  http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
#Stat $?
#Print "enable Redis Repos "
#sudo yum-config-manager --enable remi &>>$LOG
#Stat $?
#Print "Install  Redis "
#sudo yum install redis -y &>>$LOG
#Stat $?
#Print "Update Redis Listen Address "
#sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
#Stat $?
#Print "Start Redis Database"
#systemctl restart redis &>>$LOG  && systemctl enable redis &>>$LOG
#Stat $?


source components/common.sh
checkRootUser

ECHO "Configure YUM Repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
statusCheck $?

ECHO "Install Redis"
yum install redis-6.2.7 -y &>>${LOG_FILE}
statusCheck $?

ECHO "Update Redis Configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf  &>>${LOG_FILE}
statusCheck $?

ECHO "Start Redis Service"
systemctl enable redis &>>${LOG_FILE} && systemctl restart redis &>>${LOG_FILE}
statusCheck $?