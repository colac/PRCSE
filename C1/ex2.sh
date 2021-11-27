#!/bin/bash

### Initializations ###

# Function that the user intends to call
varUserOption="$1"
varCsvFile="$2"

### Functions ###

funcSortUsernames () {
    # Sort the file given by the user in reverse order -r
    # Cut the line from the comma onwards ("hugo,password" will only display "hugo")
    # Apply the awk filter, lines starting with p or P are excluded
    # Tee allows the output to be redirected to the file noNamesWithLetterP.txt and to the console at the same time
    sort -r "$varCsvFile" | cut -d , -f 1 | awk '/^[^p|^[^P]/' | tee noNamesWithLetterP.txt
}

funcCountUsernames () {
    # 
    sort -r "$varCsvFile" | awk '/^[^p|^[^P]/ { print $1 }'
}

### Execution of script ###

case $varUserOption in
  a)
    # Sort  the  usernames  not  started  with  “p” in reverse alphabetical  order  and  store  the output to a new file.
    funcSortUsernames
    ;;
  b)
    # Count the number of usernames whose password starts with the letter “b”.
    funcCountUsernames
    ;;
  *)
    printf "\nNot a valid option\n"
    ;;
esac

# Give terminal new line
printf "\n"