#!/bin/bash
#number to validate
printf 'Number to validate \n'
read number

i=2

#flag that determines if it's prime or not
f=0

# -eq - Integer_a is equal to integer_b.
# -ne - Integer_a is not equal to integer_b
# -ge - Integer_a is greater than or equal to integer_b.
# -gt - Integer_a is greater than integer_b.
# -le - Integer_a is less than or equal to integer_b.
# -lt - Integer_a is less than integer_b.
#running a loop from 2 to number/2
while test $i -le `expr $number / 2` 
    do
#checking if $i is factor of number
        if test `expr $number % $i` -eq 0 
            then f=1
        fi
#increment the loop variable
        i=`expr $i + 1`
    done
if test $f -eq 1 
    then
        echo "Not Prime"
    else
        echo "Prime"
fi