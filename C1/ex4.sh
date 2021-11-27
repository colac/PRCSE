#!/bin/bash

EXPECTED_N_ARGUMENTS=1
# Creating dirArg for ease of reading
dirArg="$1"
# Declare associative array
# echo "${arrayFilesLines[@]}" -> gets the values
# echo "${!arrayFilesLines[@]}" -> gets the keys
declare -A arrayFilesLines

if [[ $# -eq EXPECTED_N_ARGUMENTS ]]; then
    if [[ -d "$dirArg" ]]; then
        # Used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs
        for fileTxt in $(find $dirArg -maxdepth 1 -type f -name "*.txt"); do
            varGetLines=$(cat "$fileTxt" | wc -l)
            arrayFilesLines[$fileTxt]=$varGetLines
		done
        for keyTest in "${!arrayFilesLines[@]}"; do
            for key in "${!arrayFilesLines[@]}"; do 
                if [[ ${arrayFilesLines[$key]} -gt ${arrayFilesLines[$keyTest]} && ${#arrayFilesLines[@]} -gt 5 ]]; then
                    unset arrayFilesLines[$keyTest]
                fi
            done
        done
        echo "${!arrayFilesLines[@]}"
        echo "${arrayFilesLines[@]}"
    else
        printf "ERROR - $dirArg is not a directory.\n"
    fi
else
	printf "ERROR - Invalid number of arguments (expected %d, given %d)\n" $EXPECTED_N_ARGUMENTS $#
fi

# Give terminal new line
printf "\n"