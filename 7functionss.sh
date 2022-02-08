#!/bin/bash

# functions should be always declared before using it, some like variables.
# so that is the reason why we can choose functions in scripts

# how to write function syntax is :

function abc() {
  echo i am a function abc
  a=100
  echo a in function =$a
  b=20
retun
# if we return the value from 0 to 255 we can enter the values as return 125
return 120
echo first argument in function =$1
}

#also write function syntax like this
xyz(){

  echo i am a function xyz
}

## main program

a=10
#abc rahul
abc $1
echo exit status of abc=$?
echo b in main program =$b
xyz

echo first argument in main program =$1


