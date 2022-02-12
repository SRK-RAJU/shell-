#!/bin/bash

source components/common.sh
MSPACE=$(cat $0 components/common.sh | grep ^Print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=User
COMPONENT=user

NODEJS


Print "Checking DB connections from App"
sleep 5
STAT=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STAT" == "true" ]; then
  Start 0
  else
    Start 1
    fi


exit