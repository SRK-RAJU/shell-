#!/bin/bash

source components/common.sh

Print "Downloading REPO"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo

Start $?

