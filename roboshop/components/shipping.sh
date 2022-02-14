#!/bin/bash

source components/common.sh
MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Shipping
COMPONENT=shipping

MAVEN

Print "Checking DB Connections from App"
sleep 15
STAT=$(curl -s http://localhost:8080/health) &>>$LOG
if [ "$STAT" == "true" ]; then &>>$LOG
  Stat 0
else
  Stat 1
fi