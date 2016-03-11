#!/bin/bash

function prompt {
	
	#set which prompt we are on
	currentcommand=$1
	#ask the user a question, $1 is the function prompt
	read -p "What is your $1? " input

	#exit if the user supplies exit or quit
	if [[ "$input" == "exit" || "$input" == "quit" ]] ; then exit ; fi
	
	##call the testinput function to make sure something is given
	if [ "$currentcommand" == "username" ]; then
		testinput $input
		testwhitespace $input
	else
		testinput $input
		testvalue $input
	fi

	##store the checked variable into an array	
	finished=(${finished[@]} "$input")

}


function testinput {
	#check to see if input has the length > 0
	if [ -z $1 ] ; then
		echo "You entered nothing!"
		prompt $currentcommand
	fi		
}

function testwhitespace {
	##check if the variable has any spaces in it
	if [[ $1 = *[[:space:]]* ]]; then
		echo "There is a whitespace in your response, please check your input and try again"
		prompt $currentcommand
	fi
}

function testvalue {
	## test to see if input is a number
	if ! [[ $1 == ?(-)+([0-9]) ]] ; then 
		echo "Invalid number, please enter a valid number"
		prompt $currentcommand
	fi
	## test input to make sure value is inbetween 0 and 99999
	if [[ $1 -gt 99999 || $1 -lt 0 ]] ; then
		echo "Invalid number, please enter a number above 0 and below 99999"
                prompt $currentcommand
        fi

}

prompt username
prompt userid
prompt age

echo "You are ${finished[0]}, aged ${finished[1]} next year you will be $((${finished[1]} + 1 )), with user id ${finished[2]}, the next user is $((${finished[2]} + 1 ))"
