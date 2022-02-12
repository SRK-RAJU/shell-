Print ()
{
  LSPACE=$(echo $1 | awk '{print length}')
  SPACE=$(($MSPACE-$LSPACE))
  SPACES=""
 while [ $SPACE -gt 0 ]; do
  SPACES="$SPACES$(echo ' ')"
   SPACE=$(($SPACE-1))
   done

 echo -n -e "\e[1m$1${SPACES}\e[0m ... "
## echo -n -e "\e[1m$1\e[0m ... "
  echo -e "\n\e[36m================= $1 ================\e[0m" &>>$LOG
}
Start() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
    else
      echo -e "\e[1;31mFAILURE\e[0m"
      echo -e "\e[1;33mScript failed and check the detailed log in $LOG file\e[0m]"
      exit 1
    fi
}
LOG=/tmp/roboshop.log
rm -f $LOG

NODEJS() {
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
Print "Download $COMPONENT_NAME"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
Start $?
Print "Remove the Roboshop Project"
rm -rf /home/roboshop/${COMPONENT}
Start $?
Print "Extracting user"
unzip -o -d /home/roboshop  /tmp/${COMPONENT}.zip &>>$LOG
Start $?
Print " Copy Content"
mv /home/roboshop/${COMPONENT}-main  /home/roboshop/${COMPONENT}
Start $?
Print "Install Node.js Dependencies"
cd /home/roboshop/${COMPONENT}
##npm install  --unsafe-perm &>>$LOG
##Start $?
Print "Fix App Permission"
sudo chown -R roboshop:roboshop /home/roboshop
Start $?

Print "Update DNS Records in SystemID Config"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e '/s/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
Start $?


Print "Copy SystemID file"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
## mv  /home/roboshop/user/systemd.service  /etc/systemd/system/user.service  &>>$LOG
Start $?
Start "Finally $COMPONENT_NAMEalogue Service Started"

systemctl daemon-reload &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG  && systemctl enable ${COMPONENT} &>>$LOG
Start $?


}

