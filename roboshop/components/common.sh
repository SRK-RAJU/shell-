Print ()
{
  echo -n -e "\e[1m$1\e[0m ... "
  echo -e "\n\e[36m================= $1 ================\e[0m" &>>$LOG
}
Start() {
  if [ "$1" -eq 1 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
    else
      echo -e "\e[1;31mFAILURE\e[0m"
      echo -e "\e[1;33mScript failed and check the detailed log in $LOG file\e[0m]"
      exit 1
    fi
}
LOG=/tmp/roboshop.log
rm -f $LOG