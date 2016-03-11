#!/bin/bash
sqlusername=username
sqlpassword=password


#input information into database
function sqlinputfunction {
	
	#asks question and stores values into two variables
        read -p "Please enter your name and age! " name age
	
	#allow exit
	if [ $name == exit ] || [ $age == exit ] ; then exit 0 ; fi
	# input info into database
	mysql -u$sqlusername -p$sqlpassword test << EOF
	insert into user_information (name,age) VALUES ('$name', '$age') ;
EOF
}

function ask {

	read -p "What would you like to do? output or input data? " input
	case $input in
	output|Output|O|o) mysql -u$sqlusername -p$sqlpassword -e "use test; select * from user_information;"
		;;
	input|I|i) sqlinputfunction
		;;
	exit) exit 0
		;;
	quit) exit 0
		;;
	*) echo "Please use either the command, "input" or "output". "
		;;
	
	esac

}
while true; do
	ask
done
