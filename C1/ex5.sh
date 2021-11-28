#!/bin/bash

# Crontab Job: 30 23 * * * PRCSE/C1/ex5.sh > password_notices.log

# Variable that defines the number of days that triggers the alert to write the user, date and number of days till password expires
# According to Exercise 5, the number of days is set to 5
varDaysToExpireDesired=5

# Change a user's password expiration date to 5 days from now: chage -M 5 user
declare -A arrayUserPasswordDate
varCurrentDate=$(date +%Y%m%d)

for user in $(cut -d: -f1 /etc/passwd); do
    #varExpirationDate=$(echo -e "\n $user \n" && chage -l $user | grep "Password expires" | cut -d ":" -f2)
    varExpirationDate=$(chage -l $user | grep "Password expires" | cut -d ":" -f2)
    #echo $varExpirationDate
    arrayUserPasswordDate[$user]=$varExpirationDate
done

for user in "${!arrayUserPasswordDate[@]}"; do
    #echo "$user => ${arrayUserPasswordDate[$user]}";
    #echo ${arrayUserPasswordDate[$user]}
    if [[ ${arrayUserPasswordDate[$user]} =~ [0-9]+$ ]]; then
        varExpirationDate=$(date -d "${arrayUserPasswordDate[$user]}" +%Y%m%d)
        varDaysToExpire=$(echo $((($(date -u -d $varExpirationDate +%s) - $(date -u -d $varCurrentDate +%s)) / 86400)))
        if [[ $varDaysToExpire -le $varDaysToExpireDesired ]]; then
            echo $user $varExpirationDate $varDaysToExpire
        fi
    fi
done