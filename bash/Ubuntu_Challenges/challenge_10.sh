#!/bin/bash


count=1
function reversetest {
	if [[ $count -eq 30 ]] ; then echo "lychrel number could not be reached"; continue ; fi

	reversetestnumber=$(rev <<< $addednumber)
	if [[ $addednumber -gt 10 ]] ; then
		if [[ $addednumber = $reversetestnumber ]] ; then
			echo "$testnumber's Lychrel number is: $addednumber"
			continue
		else
			let "count+=1"
			add $addednumber
		fi
	else
		add $addednumber
	fi
}

function add {
	reversednumber=$(rev <<< $1)
	addednumber=$((10#$1 + 10#$reversednumber))
	reversetest $addednumber
}


for x in {1..10000} ; do
	testnumber=$x
	count=0
	add $x
done
