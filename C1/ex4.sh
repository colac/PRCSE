#!/bin/bash

EXPECTED_N_ARGUMENTS=1
# Creating dirArg for ease of reading
dirArg="$1"

# Associative array with all files in the directory and all their number of lines
declare -A arrayFilesLines

# Associative array with only 5 files and their number of lines, the ones that have the highest number of lines
declare -A arrayTopFiveFiles

# echo "${arrayFilesLines[@]}" -> gets the values, in this case the number of lines of the files in the directory
# echo "${!arrayFilesLines[@]}" -> gets the keys, in this case the files names

if [[ $# -eq EXPECTED_N_ARGUMENTS ]]; then
    if [[ -d "$dirArg" ]]; then
        # Array with the lines of all the files in the directory
        arrayTotalNrOfLines=()
        # Array with the number of lines of the files that have the highest number of lines
        arrayTopFiveLines=()
        # Used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs
        for fileTxt in $(find $dirArg -maxdepth 1 -type f -name "*.txt"); do
            # Gets the number of lines of the $file, https://linuxhint.com/count-the-number-of-lines-in-a-file-in-bash/
            varGetNrOfLines=$(sed -n '$=' "$fileTxt")
            # Strip directory and suffix from filenames, https://explainshell.com/explain?cmd=basename
            fileTxt=$(basename $fileTxt)
            # Adding 
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
        echo "${arrayTopFiveFiles[@]}"
        echo "${!arrayTopFiveFiles[@]}"
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