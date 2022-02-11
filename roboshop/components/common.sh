Print ()
{
  echo -n -e "\e[1m$*\e[0m ... "
  echo -e "\n\e[36m================= $* ================\e[0m" &>>$LOG
}
Start() {
  if [ "$*" -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
    else
      echo -e "\e[1;31mFAILURE\e[0m"
      echo -e "\e[1;33mScript failed and check the detailed log in $LOG file\e[0m]"
      exit
    fi
}
LOG=/tmp/roboshop.log
rm -f $LOG