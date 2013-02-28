#!/bin/bash

JUST_A_SECOND=1

funky()
{	# this is a simple function .
	echo "This is a funky funcion."
	echo "Now exiting funky funcion."
}


fun()
{	# this is a more complicated function
	i=0
	REPEATS=30

	echo
	echo "And now the fun really begins."
	echo

	sleep $JUST_A_SECOND
	while [ $i -lt $REPEATS ]
	do
		echo "-------FUNCTIONS--------->"
		echo "<-------ARE-----------"
		echo "<--------FUN---------"
		echo
		let "i+=1"
	done
}


funky
fun

exit 0
