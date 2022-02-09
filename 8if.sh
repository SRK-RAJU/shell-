#!/bin/bash

read -p 'Enter username: ' username
if ["$username" == "root"];then
  echo "hey , you are root user"
  else
    echo hey, you are nonroot user
    fi

    if [$UID -eq 0]; then
      echo you are root user
      else
        echo you are nonroot user
        fi