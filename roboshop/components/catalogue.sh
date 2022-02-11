#!/bin/bash

source components/common.sh

Print "Installing Nodejs "
yum install nodejs make gcc-c++ -y &>>$LOG
Start $?

## As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

##o to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use roboshop as the username to run the service.
Print "Add Roboshop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
echo User Roboshop already exists &>>$LOG
else

useradd roboshop &>>$LOG

fi

Start $?

##So let's switch to the roboshop user and run the following commands.
Print "Download Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG

Start $?

Print "Remove the Roboshop Project"
rm -rf /home/roboshop/catalogue

Start $?
Print "Extracting Catalogue"
unzip -o -d /home/roboshop  /tmp/catalogue.zip &>>$LOG
Start $?

Print " Copy Content"
mv /home/roboshop/catalogue-main  /home/roboshop/catalogue
Start $?

Print "Install Node.js Dependencies"
cd /home/roboshop/catalogue

##npm install  --unsafe-perm &>>$LOG
Start $?
Print "Fix App Permission"
sudo chown -R roboshop:roboshop /home/roboshop
Start $?
Print "Update DNS Records in SystemID Config"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$LOG
Start $?
Print "Copy SystemID file"
## mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
## mv  /home/roboshop/catalogue/systemd.service  /etc/systemd/system/catalogue.service  &>>$LOG
Start "Finally Catalogue Service Started "
systemctl daemon-reload &>>$LOG && systemctl start catalogue &>>$LOG  && systemctl enable catalogue &>>$LOG

Print "Checking DB connections from App"
sleep 5
STAT=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STAT" == "true" ]; then
  Start 0
  else
    Start 1
    fi


