#!/bin/bash

# [2016-02-01] Challenge #252 [Easy] Sailors and monkeys and coconuts, oh my!

inputfunc() {
	echo -n "How many sailors are there?"
	read sailors
}

while true; do 
	inputfunc
	re='^[0-9]+$'
	if ! [[ $sailors -gt 2 ]] || ! [[ $sailors =~ $re ]] ; then
		echo "Please enter a number that is a whole number and greater than 2"
	else
		break
	fi
done

while true; do
	n=$sailors
	n=($n ** $n - $n + 1 )
	echo $n 
	if (( $n / 2 )) ; then 
		break
	else 
		((($n - 1) * ($n ** $n - 1)))
	fi
echo $n
done

#for x in $sailors ;  do
	

exit 0
