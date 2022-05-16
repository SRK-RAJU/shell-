#!/bin/bash
#Print() {
#  LSPACE=$(echo $1 | awk '{print length}')
#  SPACE=$(($MSPACE-$LSPACE))
#  SPACES=""
#  while [ $SPACE -gt 0 ]; do
#    SPACES="$SPACES$(echo ' ')"
#    SPACE=$(($SPACE-1))
#  done
#  echo -n -e "\e[1m$1${SPACES}\e[0m  ... "
#  echo -e "\n\e[36m======================== $1 ========================\e[0m" >>$LOG
#}
#
#Stat() {
#  if [ $1 -eq 0 ]; then
#    echo -e "\e[1;32mSUCCESS\e[0m"
#  else
#    echo -e "\e[1;31mFAILURE\e[0m"
#    echo -e "\e[1;33mScript Failed and check the detailed log in $LOG file\e[0m"
#    exit 1
#  fi
#}
#
#LOG=/tmp/roboshop.log
#rm -f $LOG
#
#DOWNLOAD() {
#  Print "Download $COMPONENT_NAME"
#  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
#  Stat $?
#  Print "Extract $COMPONENT_NAME Content"
#  unzip -o -d $1 /tmp/${COMPONENT}.zip &>>$LOG
#  Stat $?
#  if [ "$1" == "/home/roboshop" ]; then
#    Print "Remove Old Content"
#    rm -rf /home/roboshop/${COMPONENT} &>>$LOG
#    Stat $?
#    Print "Copy Content"
#    mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT} &>>$LOG
#    Stat $?
#  fi
#}
#
#ROBOSHOP_USER() {
#  Print "Add RoboShop User"
#  id roboshop &>>$LOG
#  if [ $? -eq 0 ]; then
#    echo User RoboShop already exists &>>$LOG
#  else
#    useradd roboshop  &>>$LOG
#  fi
#  Stat $?
#}
#
#SYSTEMD() {
#  Print "Fix App Permissions"
#  chown roboshop:roboshop /home/roboshop -R
#   Print "Update DNS records in SystemD config"
#    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
#    -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e \
#    's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
#     -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
#      -e 's/CARTENDPOINT/cart.roboshop.internal/' \
#       -e 's/DBHOST/mysql.roboshop.internal/' -e  \
#       's/CARTHOST/cart.roboshop.internal/' \
#       -e 's/USERHOST/user.roboshop.internal/' \
#       -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
#       /home/roboshop/${COMPONENT}/systemd.service  &>>$LOG
#    Stat $?
#
#  Print "Copy SystemD file"
#  mv  /home/roboshop/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service &>>$LOG
#  Stat $?
#  Print "Start ${COMPONENT_NAME} Service"
# ## echo "Deamon Reload Running "
#  systemctl daemon-reload &>>$LOG
#  systemctl enable ${COMPONENT} &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG
#  Stat $?
#}
#
#PYTHON() {
#  Print "Install Python 3"
#  sudo yum install python36 gcc python3-devel -y &>>$LOG
#  Stat $?
#
#  ROBOSHOP_USER
#  DOWNLOAD "/home/roboshop" &>>$LOG
#
#  Print "Install the dependencies"
#  cd /home/roboshop/${COMPONENT}
#  pip3 install -r requirements.txt &>>$LOG
#  Stat $?
#  USER_ID=$(id -u roboshop) &>>$LOG
#  GROUP_ID=$(id -g roboshop) &>>$LOG
#
#  Print "Update ${COMPONENT_NAME} Service"
#  sed -i -e "/uid/ c uid = ${USER_ID}" -e "/gid/ c gid = ${GROUP_ID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>$LOG
#  Stat $?
#
#  SYSTEMD
#}
#
#MAVEN() {
#  Print "Install Maven"
#  sudo yum install maven -y &>>$LOG
#  Stat $?
#
#  ROBOSHOP_USER
#  DOWNLOAD "/home/roboshop" &>>$LOG
#  Print "Make Maven package"
#  cd /home/roboshop/${COMPONENT} &>>$LOG
#  mvn clean package &>>$LOG && mv target/shipping-1.0.jar shipping.jar &>>$LOG
#  Stat $?
#
#  SYSTEMD
#}
#
#NODEJS() {
#  Print "Install NodeJS"
# # sudo yum install npm &&
#  sudo yum install nodejs make gcc-c++ -y  &>>$LOG
#  Stat $?
#
#  ROBOSHOP_USER
#
#  DOWNLOAD "/home/roboshop" &>>$LOG
#
#  Print "Install NodeJS dependencies"
#  cd /home/roboshop/${COMPONENT}
# sudo npm install --unsafe-perm &>>$LOG
#  Stat $?
#
#  SYSTEMD
#}



checkRootUser() {
  USER_ID=$(id -u)

  if [ "$USER_ID" -ne "0" ]; then
    echo -e "\e[31mYou are suppose to be running this script as sudo or root user\e[0m"
    exit 1
  fi
}


statusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Check the error log in ${LOG_FILE}"
    exit 1
  fi
}

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

ECHO() {
  echo -e "=========================== $1 ===========================\n" >>${LOG_FILE}
  echo "$1"
}

APPLICATION_SETUP() {
  id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
    ECHO "Add Application User"
    useradd roboshop &>>${LOG_FILE}
    statusCheck $?
  fi

  ECHO "Download Application Content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  statusCheck $?

  ECHO "Extract Application Archive"
  cd /home/roboshop && rm -rf ${COMPONENT} &>>${LOG_FILE} && unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}  && mv ${COMPONENT}-main ${COMPONENT}
  statusCheck $?
}

SYSTEMD_SETUP() {
  chown roboshop:roboshop /home/roboshop/${COMPONENT} -R

  ECHO "Update SystemD Configuration Files"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  statusCheck $?

  ECHO "Setup SystemD Service"
  mv /home/roboshop/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service
  systemctl daemon-reload &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE}
  statusCheck $?
}


NODEJS() {
  ECHO "Configure NodeJS YUM Repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -  &>>${LOG_FILE}
  statusCheck $?

  ECHO "Install NodeJS"
 sudo  yum install nodejs make  gcc-c++ -y &>>${LOG_FILE}
  statusCheck $?

  APPLICATION_SETUP

  ECHO "Install NodeJS Modules"
  cd /home/roboshop/${COMPONENT} && npm install &>>${LOG_FILE}
  statusCheck $?

  SYSTEMD_SETUP
}

JAVA() {
  ECHO "Installing Java & Maven"
  yum install maven -y &>>${LOG_FILE}
  statusCheck $?

  APPLICATION_SETUP

  ECHO "Compile Maven Package"
  cd /home/roboshop/${COMPONENT} && mvn clean package &>>${LOG_FILE} && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
  statusCheck $?

  SYSTEMD_SETUP
}

PYTHON() {
  ECHO "Installing Python"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  statusCheck $?

  APPLICATION_SETUP

  ECHO "Install Python Dependencies"
  cd /home/roboshop/${COMPONENT} && pip3 install -r requirements.txt &>>${LOG_FILE}
  statusCheck $?

  USER_ID=$(id -u roboshop)
  GROUP_ID=$(id -g roboshop)

  ECHO "Update RoboSHop Configugration"
  sed -i -e "/^uid/ c uid = ${USER_ID}" -e "/^gid/ c gid = ${GROUP_ID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>${LOG_FILE}
  statusCheck $?

  SYSTEMD_SETUP
}

CHECK_MONGO_FROM_APP() {
  Print "Checking DB Connections from APP IN Mongo"
  sleep 10
  ##echo status= $STAT

  STAT=$(curl -s localhost:8080/health  | jq .mongo)
  if [ "$STAT" == "true" ]; then
    Stat 0
  else
    Stat 1
  fi
}


CHECK_REDIS_FROM_APP() {
  Print "Checking DB  Connections from APP In Redis "
  sleep 15
 ## echo status = $STAT
  STAT=$(curl -s localhost:8080/health  | jq .redis)
  if [ "$STAT" == "true" ]; then
    Stat 0
  else
    Stat 1
  fi
}
#CHECK_SHIPPING_FROM_APP()
#{
#  Print "Checking DB  Connections from APP In Redis "
#    sleep 15
#  ##echo status = $STAT
#    STAT=$(curl -s localhost:8080/health  | jq .shipping)
#    if [ "$STAT" == "OK" ]; then
#      Stat 0
#    else
#      Stat 1
#    fi
#
#}