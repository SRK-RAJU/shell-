#!/bin/bash
##  AWS CLI To create Instance in command line we have to using this script.
CREATE() {

COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | wc -1 )

if [ $COUNT -eq 0 ]; then
aws ec2 run-instances --image-id ami-0d997c5f64a74852c  --instance-type t2.micro  --security-group-ids sg-0ff43ca729a6c7843   --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq &>/dev/null
else
  echo -e "\e[1;33m$1 Instance Already Exists\e[0m"
  return
  fi
  sleep 2

 IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null  | xargs )

 ## xargs is used to remove the double quotes in displaying the output

 sed -e "s/DNSNAME/$1.roboshop.internal/"  -e "s/IPADDRESS/${IP}/" record.json >/tmp/record.json
 aws route53 change-resource-record-sets --hosted-zone-id Z034785541G9EV6BV8GL  --change-batch  file:///tmp/record.json | jq &>/dev/null


}
if [ "$1" == "all" ]; then
  ALL=(frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment)
  for component in ${ALL[*]}; do
    echo "Creating Instance - $component "
    CREATE $component
  done
else
  CREATE $1
fi