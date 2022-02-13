#!/bin/bash
source components/common.sh
MSPACE=$(cat $0 | grep ^Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1 )

Print "Installing redis repos"
yum install yum-utils  http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
Stat $?
Print "enable Redis Repos "
yum-config-manager --enable remi &>>$LOG
Stat $?
Print "Install  Redis "
yum install redis -y &>>$LOG
Stat $?
Print "Update Redis Listen Address "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
Stat $?
Print "Start Redis Database"
systemctl enable redis &>>$LOG  && systemctl restart redis &>>$LOG
Stat $?
