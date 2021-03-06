#!/bin/bash
# The frontend is the service in RobotShop to serve the web content over Nginx.
#source components/common.sh
#MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1 )
#
#Print "Installing Nginx"
#sudo yum install nginx -y &>>$LOG
#Stat $?
#
#
#Print " Downloading HTML Pages"
#curl  -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
#Stat $?
#
##Print "Remove Old Hmtl Pages"
##rm -rf  /usr/share/nginx/html/* &>>$LOG
##Stat $?
#
##cd /usr/share/nginx/html/
#
#Print "Extracting Frontend Archive"
#rm -rf /usr/share/nginx/* && cd /usr/share/nginx && unzip -o /tmp/frontend.zip  &>>$LOG  && mv frontend-main/* .  &>>$LOG  &&   mv static html  &>>$LOG
##unzip  /tmp/frontend.zip &>>$LOG && mv frontend-main/* . &>>$LOG  && mv static/* &>>$LOG
##unzip -o -d  /tmp /tmp/frontend.zip &>>$LOG
#Stat $?
#
##Print "Copying files to nginx path"
##mv /tmp/frontend-main/static/* /usr/share/nginx/html/. &>>$LOG
##Stat $?
#Print "Copy nginx roboshop  config file"
#mv localhost.conf /etc/nginx/default.d/roboshop.conf  &>>$LOG
##cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
#Stat $?
#Print "Update Nginx Config file"
#sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf  &>>$LOG
##sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/'  -e '/user/ s/localhost/user.roboshop.internal/'  -e '/payment/ s/localhost/payment.roboshop.internal/'  -e '/shipping/ s/localhost/shipping.roboshop.internal/'   /etc/nginx/default.d/roboshop.conf  &>>$LOG
#Stat $?
#
#Print "Restarting and Enabling Nginx\t\t"
##systemctl enable nginx &>>$LOG
##Stat $?
##Print "status nginx"
##sudo systemctl status nginx &>>$LOG
##Stat $?
#systemctl restart nginx &>>$LOG  && systemctl enable nginx &>>$LOG
#
##Print "ReStarting Nginx"
##sudo systemctl restart nginx &>>$LOG
#Stat $?



source components/common.sh
checkRootUser


ECHO "Installing Nginx"
yum install nginx -y &>>${LOG_FILE}
statusCheck $?

ECHO "Downloading Frontend Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
statusCheck $?

cd /usr/share/nginx/html

ECHO "Removing Old Files"
rm -rf * &>>${LOG_FILE}
statusCheck $?

ECHO "Extracting Zip Content"
unzip /tmp/frontend.zip &>>${LOG_FILE}
statusCheck $?

ECHO "Copying extracted Content"
mv frontend-main/* . &>>${LOG_FILE} && mv static/* . &>>${LOG_FILE} && rm -rf frontend-main README.md &>>${LOG_FILE}
statusCheck $?

ECHO "Copy RoboShop Nginx Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
statusCheck $?

ECHO "Update Nginx Configuration"
for component in catalogue user cart shipping payment ; do
  ECHO "Update Configuration for ${component}"
  sed -i -e "/${component}/ s/localhost/${component}.roboshop.internal/"  /etc/nginx/default.d/roboshop.conf
  statusCheck $?
done

ECHO "Start Nginx Service"
systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
statusCheck $?
