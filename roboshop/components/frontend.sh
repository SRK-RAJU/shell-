#!/bin/bash
# The frontend is the service in RobotShop to serve the web content over Nginx.
source components/common.sh
MSPACE=$(cat $0 | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

Print "Installing Nginx"
yum reinstall nginx -y &>>$LOG
Stat $?

Print " Downloading HTML Pages"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
Stat $?

Print "Remove Old Hmtl Pages"
rm -rf  /usr/share/nginx/html/* &>>$LOG
Stat $?

Print "Extracting Frontend Archive"
unzip -o -d  /tmp /tmp/frontend.zip &>>$LOG
Stat $?

Print "Copying files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>$LOG
Stat $?
Print "Copy nginx roboshop  config file"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
Stat $?
##Print "Update Nginx Config file"
##sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/'  -e '/user/ s/localhost/user.roboshop.internal/'  -e '/payment/ s/localhost/payment.roboshop.internal/'  -e '/shipping/ s/localhost/shipping.roboshop.internal/'   /etc/nginx/default.d/roboshop.conf  &>>$LOG
##Stat $?

Print "Enabling Nginx"
systemctl enable nginx &>>$LOG
Stat $?

Print "ReStarting Nginx"
systemctl restart nginx &>>$LOG
Stat $?
