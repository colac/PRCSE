#!/bin/bash

# To open the crontab file: crontab -e
# Crontab Job: 30 23 * * * PRCSE/C1/ex5.sh > /tmp/password_notices.log
# Change a user's password expiration date to 5 days from now: chage -M 5 user

# Variable that defines the number of days that triggers the alert to write the user, date and number of days till password expires
# According to Exercise 5, the number of days is set to 5
varDaysToExpireDesired=5

# Associative array that will have all the users and their password expiration date (including the ones that have it set to "never"), hence why we filter the numbers in the IF bellow ${arrayUserPasswordDate[$user]} =~ [0-9]+$
declare -A arrayUserPasswordDate
# Get current date in format 20201201
varCurrentDate=$(date +%Y%m%d)

# For loop gets the users present in file /etc/passwd, by cutting all text after the special char : and keeping the users. lacerda:x:1001:1001::/home/lacerda:/bin/bash -> lacerda
for user in $(cut -d: -f1 /etc/passwd); do
    # "chage" command allows changing/getting user password expiry information -> https://explainshell.com/explain?cmd=chage
    # "grep" is used to get only the line that relates to password expiring, "Password expires : Dec 01, 2021"
    # "cut" removes the text before the special char :
    varExpirationDate=$(chage -l $user | grep "Password expires" | cut -d ":" -f2)
    # Filling the associative array with the user name and password expiration date
    arrayUserPasswordDate[$user]=$varExpirationDate
done

# For each user in the Associative array
for user in "${!arrayUserPasswordDate[@]}"; do
    # Filtering the users that have a password expiration date set and the ones that don't (those have "never") 
    if [[ ${arrayUserPasswordDate[$user]} =~ [0-9]+$ ]]; then
        # Convert the date to 20201201 format
        varExpirationDate=$(date -d "${arrayUserPasswordDate[$user]}" +%Y%m%d)
        # https://newbedev.com/shell-script-to-get-difference-between-two-dates
        # date "-u" option sets the date in UTC
        # date -u -d $varExpirationDate +%s -> Gets us the number of seconds since the EPOCH, 1 January 1970, until the expiration date set in the file /etc/shadow for the user
        # date -u -d $varCurrentDate +%s -> Gets us the number of seconds since the EPOCH, 1 January 1970, until the current time, set in variable $varCurrentDate
        # After subtracting the 2 dates we divide by 86400 seconds (number of seconds in a day), and get the number of days until the password expires
        varDaysToExpire=$(echo $((($(date -u -d $varExpirationDate +%s) - $(date -u -d $varCurrentDate +%s)) / 86400)))
        if [[ $varDaysToExpire -le $varDaysToExpireDesired ]]; then
            # Finak step, print the user, expiration date and number of days until the expiration date
            echo -e "\nUser:" $user";" "Expiration date:" $varExpirationDate";" "Number of days:" $varDaysToExpire";"
        fi
    fi
done