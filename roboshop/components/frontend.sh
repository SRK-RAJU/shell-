#!/bin/bash
# The frontend is the service in RobotShop to serve the web content over Nginx.
source components/common.sh
Print "Installing Nginx"

# To Install Nginx.
yum install nginx -y &>>$LOG
Start $?
Print "Enabling Nginx"

systemctl enable nginx
Start $?
Print "Starting Nginx"
systemctl start nginx
Start $?

exit



# curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"


# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-master static README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf


# systemctl restart nginx