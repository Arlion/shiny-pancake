#!/bin/bash


function game {
	#iniatlize game variable
	#high random value
	highlimit=100000
	#low random value, always must be positive and not a decimal.
	lowlimit=0
	#initilze the random value
	number=0
	#keeps track how many guesses it takes to guess the number
	count=0

	echo "1) Human vs Human"
	echo "2) Human vs AI"
	echo "3) AI vs AI"
	#Do you want to play a game?
	read -p "Which game would you like to play? " game_input
	case $game_input in
		1) human_vs_human
			;;
		2) human_vs_ai
			;;
		3) ai_vs_ai
			;;	
		exit|quit) exit 0
			;;
	esac
}

# in the game, human vs human, this is player 1
function human_player1 {
	echo "Player 1! What is your number?"
	read -p "What is your number? " player_1_input
	if [ -z $player_1_input ] ; then human_player1 ; fi
	echo "Got It!"
	
}

#in the game, human vs human, this is player 2
function human_player2 {
	read -p "Please guess a number: " player_2_input
	if [ -z $player_2_input ]; then human_player2 ; fi
}

#core of the game right here, is the guess high or low?
function high_or_low {
	#check to see if player 2 input is the correct guess
        if [[ "$player_2_input" == "$player_1_input" ]] ; then
                echo "You win!"
                echo "You did it in $count turns!"
		break
        fi
	#if player 2's guess is higher than player 1's value, than lower
        if [[ "$player_2_input" -gt "$player_1_input" ]] ; then
                echo "lower"
                let "count += 1"
		value=lower
        fi
	
	#if player 2's guess is too low, then tell the player "higher"
        if [[ "$player_2_input" -lt "$player_1_input" ]] ; then
                echo "higher"
                let "count += 1"
		value=higher
        fi

}

# in the game, human vs ai and ai vs ai, this function will..
function ai {

	number=0
	# guess a number, the limit variables are always ment to be changing
	#high variable is the top end, low variable is the low end.
	#so as the computer guesses, if the response is high, it will replace the high value with the new highest value, and vice versa for the low side.
	while [ "$number" -le $lowlimit ] ; do
		number=$RANDOM
		let "number %= $highlimit"
	done
	#debug and verbosity, tells me what the high limit, low limit and within those bounds, which random number got generated from that bound, $number.
	echo "high: $highlimit low: $lowlimit number: $number"
	#assign player'2 value to be the same as $number, important so that high_or_low function is universal for human and ai players
	player_2_input=$number
	echo "AI is guessing number $player_2_input"
	high_or_low
	#$value is retrieved from high_or_low function, if $value=higher, then I resign the $low limit to that value because I know, the number can't possible be that low.
	if [ $value == "higher" ] ; then 
		lowlimit=$number
		echo "new low limit is $lowlimit"
		
	fi
	#same thing but now the value is lower, so the highlimit gets changed to that value.
	if [ $value == "lower" ] ; then
		highlimit=$number
		echo "new high limit is $highlimit"
	fi
}

function player_1_ai {
        number_ai=0
	#guess a number between high and low limit, which is 10000, 0. Once it chooses a number
        while [ "$number_ai" -le $lowlimit ] ; do
                number_ai=$RANDOM
                let "number_ai %= $highlimit"
        done
	#it will shove the number into the player_1_input and the high_or_low function can evaluate this number against "player 2"
        player_1_input=$number_ai
	echo ""
	echo "player 1 ai chooses $number_ai"
	echo ""
}

function play_again {
	#Do you want to player again?	
	echo "----------------"
        read -p "Play Again (Y|n)? " game_input
        case $game_input in
                No|N|n) exit 0
                        ;;

                exit|quit) exit 0
                        ;;
		
                *) game
                        ;;
        esac	
}
#in function game, option 1 is choosen is here. 
function human_vs_human {
	human_player1
	while true; do
		human_player2
		high_or_low
	done
	play_again
}
#in function game, option 2 is choosen is here. 
function human_vs_ai {
	human_player1
	while true; do
		ai
	done
	play_again
}
#in function game, option 3 is choosen is here. 
function ai_vs_ai {
	player_1_ai
	while true; do
		ai	
	done
	play_again
}
#always playing a game.
while true; do
	game
done
