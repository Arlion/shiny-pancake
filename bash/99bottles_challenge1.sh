#!/bin/bash
beer=99
until [ $beer -lt 1 ]; do 
	if [ $beer -gt 1 ]; then
		echo $beer bottles of beer on the wall
		echo $beer bottles of beer on the wall
		echo $beer bottles of beer, take one down pass it around.
		let beer=beer-1
	else
		echo $beer bottle of beer on the wall
		echo $beer bottle of beer on the wall
		echo $beer bottle of beer, take one down pass it around
		let beer=beer-1
	fi
sleep 0.5
done

