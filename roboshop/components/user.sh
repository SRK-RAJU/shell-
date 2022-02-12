#!/bin/bash

source components/common.sh
MSPACE=$(cat $0  | grep ^Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)
Print "Installing Nodejs "
yum install nodejs make gcc-c++ -y &>>$LOG
Start $?

## As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

Print "Add Roboshop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
echo User Roboshop already exists &>>$LOG
else
useradd roboshop &>>$LOG
fi
Start $?
##So let's switch to the roboshop user and run the following commands.
Print "Download User"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG
Start $?
Print "Remove the Roboshop Project"
rm -rf /home/roboshop/user
Start $?
Print "Extracting user"
unzip -o -d /home/roboshop  /tmp/user.zip &>>$LOG
Start $?
Print " Copy Content"
mv /home/roboshop/user-main  /home/roboshop/user
Start $?
Print "Install Node.js Dependencies"
cd /home/roboshop/user
##npm install  --unsafe-perm &>>$LOG
##Start $?
Print "Fix App Permission"
sudo chown -R roboshop:roboshop  /home/roboshop
Start $?
Print "Update DNS Records in SystemID Config"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>$LOG
Start $?


##Print "Copy SystemID file"
##mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
## mv  /home/roboshop/user/systemd.service  /etc/systemd/system/user.service  &>>$LOG

Start "Finally Catalogue Service Started"

systemctl daemon-reload &>>$LOG && systemctl restart user &>>$LOG  && systemctl enable user &>>$LOG

Print "Checking DB connections from App"
sleep 5
STAT=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STAT" == "true" ]; then
  Start 0
  else
    Start 1
    fi


exit