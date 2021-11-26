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

        sed 1d $varCsvFile | while IFS=, read -r varName varAge varSalary
        do
            #printf ""$varName" $varAge $varSalary\n"
            # Increment counter that will flag the program to printf the highest earner or array of highest eaners 
            let "varLineIncrement++"
            # Regex validates if the var starts with a number 0 to 9. Accepts a dot if it has numbers after (12 or 12.1 OK) (12. NOK)
            varRegexSalary='^[0-9]+([.][0-9]+)?$'
            if [[ $varSalary =~ $varRegexSalary ]]; then
                echo "$varSalary $varSalarySaved"
                if [[ $varSalary -gt $varSalarySaved ]] && [[ $varSalarySaved -ne 0 ]]; then
                    echo "-GT"
                    arrayNamesSaved=()
                    varNameSaved="$varName"
                    varSalarySaved=$varSalary
                    arrayNamesSaved+=("$varName")
                elif [[ $varSalary -eq $varSalarySaved ]] && [[ $varSalarySaved -ne 0 ]]; then
                    echo "-EQ"
                    arrayNamesSaved+=("$varName")
                    varSalarySaved=$varSalary
                elif [[ $varSalarySaved -eq 0 ]]; then
                    echo "-LT"
                    varNameSaved="$varName"
                    varSalarySaved=$varSalary
                fi
            else
                printf "\nERROR: $varSalary Not a number\n"
            fi
            # If IFS= loop has gotten to the end of file and the associative array was created, then display the highest payed employees
            if [[ $varLineIncrement -eq $varNumberOfLines ]]; then
                printf "\nName of the employee(s) with the highest salary of $varSalarySaved€:"
                for varNameArray in "${arrayNamesSaved[@]}"
                    do
                        printf "\n$varNameArray"; 
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