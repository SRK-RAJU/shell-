#!/bin/bash

source components/common.sh
MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=MongoDB
COMPONENT=mongodb

Print "Downloading REPO"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
Stat $?

Print "Installing MongoDB service "
sudo yum install -y mongodb-org &>>$LOG
Stat $?

Print "Update MongoDB Config"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
Stat $?

# Liste IP address from 127.0.0.1 to 0.0.0.0 in config file
Print "Start And Restart MongoDB"
 systemctl restart mongod &>>$LOG
 Stat $?
 Print "Enabling MongoDB Service"
systemctl enable mongod &>>$LOG
Stat $?
DOWNLOAD "/tmp"

Print "Load Schema"
cd /tmp/mongodb-main
for db in catalogue users ; do
  mongo < $db.js &>>$LOG
done
Stat $?

