#!/bin/bash


# to print some text on the screen then we use echo or printf commands
## we choose to go with echo command because of low syntaxing

# syntax of echo is

# echo message to print

echo welcome raju

echo hello

# esc sequences, \n (new line), \t ( new tab) , \e (new color)
# syntax of sequences is
# echo -e "message\nNew line"

# to enable any esc sequences we need to enable -e option
# also the input should be in quotes, preferably double quotes


echo -e "welcome raju\nhello"
echo -e "raju\tkumar"

echo -e "raju\t\tkumar"

# coloured output

# syntax of the colour is

# echo -e "\e[COLmMessage"


## COlors     CODE
# red         31
# green       32
# yellow      33
# blue        34
# magenta     35
#cyan         36

echo -e "\e[31mText in red colour"
echo -e "\e[33mText in yellow colour"
echo -e "\e[32mText in green colour"
echo -e "\e[34mText in blue colour"
echo -e "\e[35mText in magenta colour"
echo -e "\e[36mText in cyan colour"


echo -e "\e[31mText in red colour"

# if we get in normal color then we write the syntax in 0.     syntax is \e[0m


# write the syntax is

echo -e "\e[31mtext in red color\e[0m"
# then we have to get red color as normal color we have to check this in bwelow syntax

echo text in normal color

