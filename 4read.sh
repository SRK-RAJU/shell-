#!/bin/bash

# inputs , there are to types of inputs one is during the execution user can enter the inputs another one is after the execution

# during the execution if we run the inputs we have using read command syntax of the read command is
read -p 'enter your name: ' name
read -p 'enter your age: ' age

# if data coming in new  line then  using \n  and printing done through echo command

echo -e "your name = $name\nYour age = $age"
