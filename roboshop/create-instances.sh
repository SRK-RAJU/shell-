#!/bin/bash
##  AWS CLI To create Instance in command line we have to using this script.
 COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=cart" | jq ".Reservations[].Instances[].InstanceId" | wc  -l)

if [ $COUNT -eq 0 ]; then
aws ec2 run-instances --image-id ami-0d997c5f64a74852c  --instance-type t2.micro --security-group-ids sg-0ff43ca729a6c7843  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq

else
  echo "Instance Already Exists"
  fi