#!/bin/bash

#Number of arguments
#echo $#

#List each argument
#echo $@

#checking if $i is odd or even
for i in $@
do
	#echo $i
	if [ $((i%2)) -eq 0 ]
	then
		printf "\nNumber $i is even"
	else
		printf "\nNumber $i is odd"
	fi
done

#just to get command line in \n newline
printf "\n"
