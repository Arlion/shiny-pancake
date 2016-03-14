#!/bin/bash



count=0
value=""

function game {
	echo "1) Human vs Human"
	echo "2) Human vs AI"
	echo "3) AI vs AI"
	read -p "Which game would you like to play? " game_input
	case $game_input in
		1) human_vs_human
			;;
		exit|quit) exit 0
			;;
		2) human_vs_ai
			;;
	esac
}

function human_player1 {
	echo "Player 1! What is your number?"
	read -p "What is your number? " player_1_input
	if [ -z $player_1_input ] ; then human_player1 ; fi
	echo "Got It!"
	
}
function human_player2 {
	read -p "Please guess a number: " player_2_input
	if [ -z $player_2_input ]; then human_player2 ; fi
	
}

function high_or_low {

        if [[ "$player_2_input" == "$player_1_input" ]] ; then
                echo "You win!"
                echo "You did it in $count turns!"
                exit 0
        fi
        if [[ "$player_2_input" -gt "$player_1_input" ]] ; then
                echo "lower"
                let "count += 1"
		value=lower
        fi

        if [[ "$player_2_input" -lt "$player_1_input" ]] ; then
                echo "higher"
                let "count += 1"
		value=higher
        fi

}

highlimit=100
lowlimit=0

function ai {
	echo "high: $highlimit low: $lowlimit number: $number"
	number=$((RANDOM%$highlimit+$lowlimit))
	player_2_input=$number
	echo "AI is guessing number $player_2_input"
	high_or_low
	if [ $value == "higher" ] ; then 
		lowlimit=$number
		#lowlimit=$((RANDOM%$highlimit+$number))
		echo "new low limit is $lowlimit"
		
	fi
	if [ $value == "lower" ] ; then
		highlimit=$number
		#highlimit=$((RANDOM%$number+$lowlimit))
		echo "new high limit is $highlimit"
	fi
}

function human_vs_human {
	human_player1
	while true; do
		human_player2
		high_or_low
	done
}

function human_vs_ai {
	human_player1
	while true; do
		ai
		sleep 10
	done
}
while true; do
	game
done
