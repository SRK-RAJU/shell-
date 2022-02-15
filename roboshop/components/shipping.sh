#!/bin/bash

source components/common.sh
MSPACE=$(cat $0 components/common.sh | grep Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Shipping
COMPONENT=shipping

MAVEN
##CHECK_SHIPPING_FROM_APP
Print "Checking DB Connections from App"
sleep 15
echo status = $STAT

STAT=$(curl -s "http://localhost:8080/health")
if [ "$STAT" == "OK" ]; then
  Stat 0
else
 Stat 1
fi