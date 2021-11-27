#!/bin/bash

### Initializations ###

# Function that the user intends to call
varUserOption="$1"
varCsvFile="$2"

### Functions ###

funcSortUsernames () {
    # Sort the file given by the user in reverse order -r and then apply the awk filter, lines starting with p or P are excluded, and only the first collumn is printed
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