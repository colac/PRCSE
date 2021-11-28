#!/bin/bash

EXPECTED_N_ARGUMENTS=1
# Creating dirArg for ease of reading
dirArg="$1"
# Declare associative array
# echo "${arrayFilesLines[@]}" -> gets the values
# echo "${!arrayFilesLines[@]}" -> gets the keys
declare -A arrayFilesLines

# Array with only 5 elements, the highest number of lines
declare -A arrayTopFiveFiles

if [[ $# -eq EXPECTED_N_ARGUMENTS ]]; then
    if [[ -d "$dirArg" ]]; then
        # Array with the lines of all the files 
        arrayTotalNrOfLines=()
        # Array with only 5 elements, the highest number of lines
        arrayTopFiveLines=()

        # Used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs
        for fileTxt in $(find $dirArg -maxdepth 1 -type f -name "*.txt"); do
            varGetNrOfLines=$(sed -n '$=' "$fileTxt")
            fileTxt=$(basename $fileTxt)
            arrayTotalNrOfLines+=("$varGetNrOfLines")
            arrayFilesLines[$fileTxt]=$varGetNrOfLines
        done
        # Creating simple array with 5 entries, the highest 5 number of lines
        for varTopFiveLines in $(printf "%s\n" "${arrayTotalNrOfLines[@]}" | sort -rn | head -n 5); do
            arrayTopFiveLines+=("$varTopFiveLines")
        done
        # Print array with 5 entries, the highest 5 number of lines
        #printf "%s\n" "${arrayTopFiveLines[@]}" | sort -rn
        for key in "${arrayTopFiveLines[@]}"; do
            if [[ " ${arrayTopFiveLines[*]} " =~ " ${key} " ]]; then
                for key in "${!arrayFilesLines[@]}"; do 
                    #echo "$key => ${arrayFilesLines[$key]}";
                    if [[ " ${arrayTopFiveLines[*]} " =~ " ${arrayFilesLines[$key]} " ]]; then
                        arrayTopFiveFiles[$key]=${arrayFilesLines[$key]}
                    fi
                done
            fi
        done
        printf "These ${#arrayFilesLines[@]} directories have the higher line count of directory: "$dirArg"\n"
        for key in "${!arrayTopFiveFiles[@]}"; do echo "File: $key has ${arrayTopFiveFiles[$key]} lines"; done
    else
        printf "ERROR - $dirArg is not a directory.\n"
    fi
else
	printf "ERROR - Invalid number of arguments (expected %d, given %d)\n" $EXPECTED_N_ARGUMENTS $#
fi

# Give terminal new line
printf "\n"














    # # Array with the lines of all the files 
    # arrayTotalNrOfLines=()
    # # Array with only 5 elements, the highest number of lines
    # arrayTopFiveLines=()

    # countToFive=0

    # for varTotalNrOfLines in $(find $dirArg -maxdepth 1 -type f -name "*.txt"); do
    #     varGetNrOfLines=$(sed -n '$=' "$varTotalNrOfLines")
    #     arrayTotalNrOfLines+=("$varGetNrOfLines")
    # done
    # #printf "%s\n" "${arrayTotalNrOfLines[@]}" | sort -rn | head -n 5


    # for varTopFiveLines in $(printf "%s\n" "${arrayTotalNrOfLines[@]}" | sort -rn | head -n 5); do
    #     arrayTopFiveLines+=("$varTopFiveLines")
    # done
    # printf "%s\n" "${arrayTopFiveLines[@]}" | sort -rn