#!/bin/bash

#Number of arguments
#echo $#

#List each argument
#echo $@

EXPECTED_N_ARGUMENTS=1
dirArg = $1
printf "$dirArg"
if [[ -d $dirArg ]]
then
	printf "Its a dir\n"
	find $dirArg -type f -name "*.txt"
else
	printf "Its not a dir\n"
fi
