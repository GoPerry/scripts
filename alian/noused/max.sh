#!/bin/bash

E_PARAM_ERR=198
EQUAL=199


max2()
{
	if [ -z "$2" ]
	then
		return $E_PARAM_ERR
	fi
	
	if [ "$1" -eq "$2" ]
	then
		return $EQUAL
	else
		if [ "$1" -gt "$2" ]
		then
			return $1
		else
			return $2
		fi
	fi
}

echo "Please enter the first number:"
read firstnum
echo "Please enter the second number:"
read secondnum
max2 $firstnum $secondnum
return_val=$?

if [ "$return_val" -eq $E_PARAM_ERR ]
then
	echo "Need to pass two parameters to the funcion."
elif [ "$return_val" -eq $EQUAL ]
then
	echo "The two numbers are equal."
else
	echo "The larger of the two numbers is $return_val."
fi

exit 0
