#!/bin/bash

source components/common.sh
MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Shipping
COMPONENT=shipping

MAVEN

sleep 10
Print "its checking sleep"

Print "Checking DB Connections from App"
echo "Sleep is running "
sleep 5
STAT=$(curl -s http://localhost:8080/health)
if [ "$STAT" == "ok" ] ; then
  Stat 0
else
  Stat 1
fi