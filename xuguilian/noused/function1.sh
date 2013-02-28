#!/bin/bash

DEFAULT=default

func2()
{
	if [ -z "$1" ]
	then
		echo "-Parameter #1 is zero length.-"
	else
		echo "-Parameter #1 is \"$1\".-"
	fi

	variable=${1-$DEFAULT}
	echo "variable=$variable"


	if [ "$2" ]
	then
		echo "-Parameter #2 is \"$2\".-"
	fi

	return 0
}

echo

echo "Nothing passed."
func2
echo


echo "Zero-length parameter passed."
func2 ""
echo

echo "Null parameter passed."
func2 "$uninitialized_param"
echo

echo "One parameter passed."
func2 first
echo

echo "Two parameters passed."
func2 first second
echo

echo "\"\" \"second\" passed."
func2 "" second
echo

echo "\"first\" \"\" passed."
func2 first ""
echo

exit 0
