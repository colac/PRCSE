#!/bin/bash
# CSV files needs to have an empty line at the end of the file, so that IFS reads the last line (needs \n)
varCsvFile="$1"

# Ex. 4 a)
funcHighestSalary () {
    if [[ -f "$varCsvFile" ]]; then
        # Get number of lines in csv and remove one, the heading
        # Used to know when to printf the highest earner or array of highest eaners
        varNumberOfLines=$(cat "$varCsvFile" | wc -l)
        varNumberOfLines=("`expr $varNumberOfLines - 1`")
        varLineIncrement=0
        varSalarySaved=0
        # Ignored the 1st line of the csv due to the headings, sed feeds the output after 1st line to IFS (Internal Field Separator)
        sed 1d $varCsvFile | while IFS=, read -r varName varAge varSalary
        do
            #printf ""$varName" $varAge $varSalary\n"
            # Increment counter that will flag the program to printf the highest earner or array of highest eaners 
            let "varLineIncrement++"
            # Regex validates if the var starts with a number 0 to 9. Accepts a dot if it has numbers after (12 or 12.1 OK) (12. NOK)
            varRegexSalary='^[0-9]+([.][0-9]+)?$'
            if [[ $varSalary =~ $varRegexSalary ]]; then
                            # First scenario, where $varSalarySaved is still 0
                if [[ $varSalarySaved -eq 0 ]]; then
                    varNameSaved="$varName"
                    varSalarySaved=$varSalary
                elif [[ $varSalary -eq $varSalarySaved ]] && [[ $varSalarySaved -ne 0 ]]; then
                    arrayNamesSaved+=("$varName")
                    varSalarySaved=$varSalary
                elif [[ $varSalary -gt $varSalarySaved ]] && [[ $varSalarySaved -ne 0 ]]; then
                    arrayNamesSaved=()
                    varNameSaved="$varName"
                    varSalarySaved=$varSalary
                    arrayNamesSaved+=("$varName")
                fi
            else
                printf "\nERROR: $varSalary Not a number\n"
            fi
            # If IFS= loop has gotten to the end of file, then display the highest payed employees
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