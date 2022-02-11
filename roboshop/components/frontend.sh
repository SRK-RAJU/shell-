#!/bin/bash
# The frontend is the service in RobotShop to serve the web content over Nginx.
source components/common.sh
MSPACE=$(cat $0 | grep ^Print |awk -F '*' '{print $2}' | awk '{print length}' | sort | tail -l)
Print "Installing Nginx"

# To Install Nginx.
yum install nginx -y &>>$LOG
Start $?

Print "Starting nginx"
systemctl start nginx &>>$LOG
Start $?


Print " Downloading HTML Pages"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
Start $?

Print "Remove Old Hmtl Pages"
rm -rf  /usr/share/nginx/html/* &>>$LOG
Start $?

Print "Extracting Frontend Archive"
unzip -o -d  /tmp /tmp/frontend.zip &>>$LOG
Start $?

Print "Copying files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>$LOG
Start $?
Print "Copy nginx roboshop into config file"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
Start $?


Print "Enabling Nginx"

systemctl enable nginx &>>$LOG
Start $?

Print "ReStarting Nginx"
systemctl restart nginx &>>$LOG
Start $?

exit
