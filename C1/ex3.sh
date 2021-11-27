#!/bin/bash

EXPECTED_N_ARGUMENTS=1
# Creating dirArg for ease of reading
dirArg="$1"


if [[ $# -eq EXPECTED_N_ARGUMENTS ]]; then
    if [[ -d "$dirArg" ]]; then
        # Used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs
        # -perm -o+w means that it will search for files that the "Other's" have write permissions
        for filePermOthers in $(find "$dirArg" -maxdepth 1 -type f -perm -o+w)
		do
			printf "'Others' have write permission on this file -> $filePermOthers\n"
		done
    else
        printf "ERROR - $dirArg is not a directory.\n"
    fi
else
	printf "ERROR - Invalid number of arguments (expected %d, given %d)\n" $EXPECTED_N_ARGUMENTS $#
fi

# Give terminal new line
printf "\n"