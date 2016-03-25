#!/bin/bash

inputfile=input.txt

totalcount=$(sort -d $inputfile | uniq -c | awk '{ print $1}')
inputcount=$(sort -d $inputfile | uniq -c | awk '{ print $2}')
totalarray=($totalcount)
inputarray=($inputcount)

tLen=${#totalarray[@]}

for (( i=0; i<${tLen}; i++ )); do
	echo "${totalarray[$i]}" = "${inputarray[$i]}"
done


