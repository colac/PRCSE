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
        # Simple array with the lines of all the files in the directory
        arrayTotalNrOfLines=()
        # Simple array with the number of lines of the files that have the highest number of lines
        arrayTopFiveLines=()
        # Used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs
        for fileTxt in $(find $dirArg -maxdepth 1 -type f -name "*.txt"); do
            # Gets the number of lines of the $file, https://linuxhint.com/count-the-number-of-lines-in-a-file-in-bash/
            varGetNrOfLines=$(sed -n '$=' "$fileTxt")
            # Strip directory and suffix from filenames, https://explainshell.com/explain?cmd=basename
            fileTxt=$(basename $fileTxt)
            # Adding all the number of lines to the simple array arrayTotalNrOfLines. Ex.: arrayTotalNrOfLines=(3 7 5 11 8 20 2 15)
            arrayTotalNrOfLines+=("$varGetNrOfLines")
            # Adding the the files and their respective number of lines to associative array. Ex.: "arrayFilesLines[newfile.txt]=6" / "File:newfile.txt ; Lines:6"
            arrayFilesLines[$fileTxt]=$varGetNrOfLines
        done
        # Creating simple array with 5 entries, the highest 5 number of lines
        # sort -rn -> sorts the number of lines outputed of the printed array in a reverse numerical order. Ex.: 20 15 11 8 7 5 3 2
        # head -n 5 -> limits the output to 5 results, since we only want the 5 files with most lines. Ex.: Ex.: 20 15 11 8 7
        for varTopFiveLines in $(printf "%s\n" "${arrayTotalNrOfLines[@]}" | sort -rn | head -n 5); do
            arrayTopFiveLines+=("$varTopFiveLines")
        done
        # Create the associative array arrayTopFiveFiles, that will contain the 5 files with the highest line count and the line count
        for numberOfLines in "${arrayTopFiveLines[@]}"; do
            # This regex operation checks if the number of lines ${numberOfLines} exists in the array that has the highest 5 number count of lines arrayTopFiveLines
            if [[ " ${arrayTopFiveLines[*]} " =~ " ${numberOfLines} " ]]; then
            # For each filename (filetxt) in associative array ${!arrayFilesLines[@]} the IF statement is performed
                for fileTxt in "${!arrayFilesLines[@]}"; do 
                    #echo "$fileTxt => ${arrayFilesLines[$fileTxt]}";
                    # Checks if the number of lines registred to the filename (filetxt) appears in the simple array arrayTopFiveLines
                    # If the condition is true, then the file name and respective number of lines is added to associative array, arrayTopFiveFiles
                    if [[ " ${arrayTopFiveLines[*]} " =~ " ${arrayFilesLines[$fileTxt]} " ]]; then
                        arrayTopFiveFiles[$fileTxt]=${arrayFilesLines[$fileTxt]}
                    fi
                done
            fi
        done
        # Print the final results
        printf "These ${#arrayFilesLines[@]} directories have the higher line count of directory: "$dirArg"\n"
        # Print the 5 files with the highest line count and the line count
        for fileTxt in "${!arrayTopFiveFiles[@]}"; do echo "File: $fileTxt has ${arrayTopFiveFiles[$fileTxt]} lines"; done
    else
        printf "ERROR - $dirArg is not a directory.\n"
    fi
else
	printf "ERROR - Invalid number of arguments (expected %d, given %d)\n" $EXPECTED_N_ARGUMENTS $#
fi
# Give terminal new line
printf "\n"