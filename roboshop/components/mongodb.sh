#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 | grep ^Print | awk -F '*' '{print $2}' | awk '{print length}' | sort | tail -l)

Print "Downloading REPO"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG

Start $?


Print "Installing Mongodb service "
yum install -y mongodb-org &>>$LOG
Start $?

Print "Update Mongodb Config"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG
Start $?

# Liste IP address from 127.0.0.1 to 0.0.0.0 in config file
Print "Start And Restart Mongodb"
 systemctl restart mongod &>>LOG
 Start $?
 Print "Enabling Mongodb"
systemctl enable mongod &>>LOG

## Config file: /etc/mongod.conf
Start $?


# systemctl restart mongod
##Every Database needs the schema to be loaded for the application to work.
##Download the schema and load it.
Print "Download Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
Start $?
Print "Extract The Schema"
unzip -o -d /tmp  /tmp/mongodb.zip &>>$LOG
Start $?
Print "Load the schema"

cd /tmp/mongodb-main &>>$LOG
Start $?


mongo < catalogue.js &>>$LOG
mongo < users.js &>>$LOG

Start $?

exit

