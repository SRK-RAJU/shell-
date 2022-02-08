#!/bin/bash

##if we assign a name to set of data the it is called as variable.

# actually variable is nothing but storing the data , data is nothing but numbers and string .

# number 123 , string is nothing but abc

# in bash shell there is no default data types , so shell is considering everything as a string in shell.

# syntax of the variables in shell is

# var=data
# number
r=86
#string
k=raju



# how to accessing data in shell is using the $ symbol.

echo value of r = $r
echo value of k = $k

echo value of r = ${r}

x=20
y=10

echo ${y}x${x} = 200

# how to write date format is DATE=2022-02-08
DATE=$(date +%F)
echo good morning, Welcome, Today date is $DATE

#arth sustitution in shell is


ADD=$((2+3+4+5+6*7/2-5))
echo added = $ADD

# variables are 3 types of hold properties that is
# 1 readwrite 2 scalar  3 local know days every one using local properied

# how to wtie this is

echo Course Name = $COURSE_NAME

# if we unable to display the Course name then we need to write the export command
course name = devops
export devops
