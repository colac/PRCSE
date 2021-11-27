#!/bin/bash

# Creating dirArg for ease of reading
dirArg="$1"

if [[ -d "$dirArg" ]]; then
    # Used "-maxdepth 1" so that find only searches the given dir by the user, if not, find will go to subdirs
    # -perm -o+w means that it will search for files that the "Other's" have write permissions
    find "$dirArg" -maxdepth 1 -type f -perm -o+w
else
		printf "$dirArg is not a dir\n"
fi