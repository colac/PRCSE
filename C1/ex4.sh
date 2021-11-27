#!/bin/bash

#creating dirArg for ease of reading
dirArg="$1"

if [[ -d "$dirArg" ]]
	then
		# used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs 
		for fileTxt in $(find $dirArg -maxdepth 1 -type f -name "*.txt")
		do
			printf "$fileTxt is a txt file\n"
			head -n 1 "$fileTxt"
		done
else
		printf "$dirArg is not a dir\n"
fi