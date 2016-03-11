#!/bin/bash

number=$((RANDOM%100+0))
count=0

function high_or_low {

	if [[ "$input" == "$number" ]] ; then
		echo "You win!"
		echo "You did it in $count turns!"
		exit 0
	fi
	if [[ $input -gt $number ]] ; then
		echo "lower"
		let "count += 1"
		question
	fi

	if [[ $input -lt $number ]] ; then
		echo "higher"
		let "count += 1"
		question
	fi

}

function question {

	read -p "Please guess a number between 1-100: " input

	# exit or quit will result in a exit with status 0
	if [[ "$input" == "exit" || "$input" == "quit" ]] ; then exit 0 ; fi

        ## test to see if input is a number
        if ! [[ $input == ?(-)+([0-9]) ]] ; then
                echo "Invalid number, please enter a valid number"
		question
        fi
        ## test input to make sure value is inbetween 0 and 99999
        if [[ $input -gt 100 || $1 -lt 0 ]] ; then
                echo "Invalid number, please enter a number above 0 and below 100"
		question
        fi
}


question
while true; do
high_or_low $input
done
