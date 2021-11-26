#!/bin/bash
# CSV files needs to have an empty line at the end of the file, so that IFS reads the last line (needs \n)
varCsvFile="$1"

funcHighestSalary () {
    if [[ -f "$varCsvFile" ]]; then
        # Get number of lines in csv and remove one, the heading
        # Used to know when to printf the highest earner or array of highest eaners
        varNumberOfLines=$(cat "$varCsvFile" | wc -l)
        varNumberOfLines=("`expr $varNumberOfLines - 1`")
        varLineIncrement=0
        varSalarySaved=0
        varArraySalariesSavedFlag=0
        declare -A arraySalariesSaved
        sed 1d $varCsvFile | while IFS=, read -r varName varAge varSalary
        do
            #printf "$varName $varAge $varSalary\n"
            # Increment counter that will flag the program to printf the highest earner or array of highest eaners 
            let "varLineIncrement++"
            # Regex validates if the var starts with a number 0 to 9. Accepts a dot if it has numbers after (12 or 12.1 OK) (12. NOK)
            varRegexSalary='^[0-9]+([.][0-9]+)?$'
            if [[ $varSalary =~ $varRegexSalary ]]; then
                # printf "$varSalarySaved varSalarySaved\n"
                # printf "$varSalary varSalary\n"
                if [[ $varSalary -gt $varSalarySaved ]]; then
                    #echo "unsetted arraySalariesSaved"
                    if [[ $varArraySalariesSavedFlag -eq 1 ]]; then
                        unset arraySalariesSaved
                        declare -A arraySalariesSaved
                    # for varNameArray in "${!arraySalariesSaved[@]}"; 
                    #     do
                    #         echo "FOR ${arraySalariesSaved[$varNameArray]}"
                    #         unset arraySalariesSaved[varNameArray]
                    #     done
                    fi
                    varArraySalariesSavedFlag=0
                    varNameSaved=$varName
                    varSalarySaved=$varSalary
                elif [[ $varSalary -eq $varSalarySaved ]]; then
                    # echo "varLineIncrement -eq "$varLineIncrement
                    varArraySalariesSavedFlag=1
                    arraySalariesSaved["$varName"]+="$varSalary"
                    #echo "ELIF for ${arraySalariesSaved[@]}"
                else
                    toDelete=1
                    #echo "varNumberOfLines neither "$varNumberOfLines
                    #echo "varLineIncrement neither "$varLineIncrement
                fi
            else
                printf "\nERROR: $varSalary Not a number\n"
            fi
            # echo $varLineIncrement
            # echo $varNumberOfLines
            # If IFS= loop has gotten to the end of file and the associative array was not created, then display the highest payed employee
            if [[ $varLineIncrement -eq $varNumberOfLines ]] && [[ $varArraySalariesSavedFlag -ne 1 ]]; then
                printf "\nEmployee $varNameSaved has the highest salary, at $varSalarySaved€\n"
            # If IFS= loop has gotten to the end of file and the associative array was created, then display the highest payed employees
            elif [[ $varLineIncrement -eq $varNumberOfLines ]] && [[ $varArraySalariesSavedFlag -eq 1 ]]; then
                #echo $varArraySalariesSavedFlag
                echo "${arraySalariesSaved[@]}"
                for varNameArray in "${!arraySalariesSaved[@]}"; 
                    do 
                        printf "\nEmployee $varNameArray, has a salary of ${arraySalariesSaved[$varNameArray]}"; 
                    done
            fi
        done #< "$varCsvFile"
    else
            printf "No csv file passed or $varCsvFile is not a file\n"
    fi
}

# Get highest payed employee(s)
funcHighestSalary
# Give terminal new line
printf "\n"

# var1=1
# var2=1
# if [ $var1 -gt $var2 ]; then
#     printf "$var1 -gt $var2"
# elif [[ $var1 -eq $var2 ]]; then
#     printf "$var1 -eq $var2"
# fi