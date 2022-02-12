#!/bin/bash

source components/common.sh
MSPACE=$(cat $0  | grep ^Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

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