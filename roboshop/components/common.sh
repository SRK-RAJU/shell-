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
#  chown -R roboshop:roboshop /home/roboshop &>>$LOG
#  Stat $?
#
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
#  systemctl restart ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
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
#  sudo yum install npm && sudo yum install nodejs make gcc-c++ -y  &>>$LOG
#  Stat $?
#
#  ROBOSHOP_USER
#
#  DOWNLOAD "/home/roboshop" &>>$LOG
#
#  Print "Install NodeJS dependencies"
#  cd /home/roboshop/${COMPONENT} &>>$LOG
#  npm install --unsafe-perm &>>$LOG
#  Stat $?
#
#  SYSTEMD
#}
#
#CHECK_MONGO_FROM_APP() {
#  Print "Checking DB Connections from APP IN Mongo"
#  sleep 10
#  ##echo status= $STAT
#
#  STAT=$(curl -s localhost:8080/health  | jq .mongo)
#  if [ "$STAT" == "true" ]; then
#    Stat 0
#  else
#    Stat 1
#  fi
#}
#
#
#CHECK_REDIS_FROM_APP() {
#  Print "Checking DB  Connections from APP In Redis "
#  sleep 15
# ## echo status = $STAT
#  STAT=$(curl -s localhost:8080/health  | jq .redis)
#  if [ "$STAT" == "true" ]; then
#    Stat 0
#  else
#    Stat 1
#  fi
#}
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
StatCheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\n --------------------- $1 ----------------------" &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo You should run your script as sudo or root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

APP_USER=roboshop

APP_SETUP() {
  id ${APP_USER} &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
    Print "Add Application User"
    useradd ${APP_USER} &>>${LOG_FILE}
    StatCheck $?
  fi
  Print "Download App Component"
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  StatCheck $?

  Print "CleanUp Old Content"
  rm -rf /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}
  StatCheck $?

  Print "Extract App Content"
  cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
  StatCheck $?
}

SERVICE_SETUP() {
  Print "Fix App User Permissions"
  chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
  StatCheck $?

  Print "Setup SystemD File"
  sed -i  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
          -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
          -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
          -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
          -e 's/CARTENDPOINT/cart.roboshop.internal/' \
          -e 's/DBHOST/mysql.roboshop.internal/' \
          -e 's/CARTHOST/cart.roboshop.internal/' \
          -e 's/USERHOST/user.roboshop.internal/' \
          -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
          /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG_FILE}
  StatCheck $?

  Print "Restart ${COMPONENT} Service"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE}
  StatCheck $?
}

NODEJS() {

  Print "Configure Yum repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
  StatCheck $?

  Print "Install NodeJS"
  yum install nodejs gcc-c++ -y &>>${LOG_FILE}
  StatCheck $?

  APP_SETUP

  Print "Install App Dependencies"
  cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
  StatCheck $?

  SERVICE_SETUP

}

MAVEN() {
  Print "Install Maven"
  yum install maven -y &>>${LOG_FILE}
  StatCheck $?

  APP_SETUP

  Print "Maven Packaging"
  cd /home/${APP_USER}/${COMPONENT} &&  mvn clean package &>>${LOG_FILE} && mv target/shipping-1.0.jar shipping.jar &>>${LOG_FILE}
  StatCheck $?

  SERVICE_SETUP

}

PYTHON() {

  Print "Install Python"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  StatCheck $?

  APP_SETUP

  Print "Install Python Dependencies"
  cd /home/${APP_USER}/${COMPONENT} && pip3 install -r requirements.txt &>>${LOG_FILE}
  StatCheck $?

  SERVICE_SETUP
  }