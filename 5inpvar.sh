#!/bin/bash

# 0 is script name
echo 0=$0

# 1 denotes 1 argument to script
echo 1=$1
# 2 denotes second argument to the script
echo 2=$2
# n denotes n number of arguments
echo n=$n
 # * and @ are giving all the arguments
echo "* =$*"
echo "@ =$@"

# # denotes that how many number of values we have parsed to the shell
echo "# =$#"

echo -e "your name =$1\nyour age =$2"
