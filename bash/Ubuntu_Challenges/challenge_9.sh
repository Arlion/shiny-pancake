#!/bin/bash -x

inputfile=input.txt

totalcount=$(sort -d $inputfile | uniq -c | awk '{ print $1}')
inputcount=$(sort -d $inputfile | uniq -c | awk '{ print $2}')
totalarray=($totalcount)
inputarray=($inputcount)
echo ${totalarray[*]}
echo ${inputarray[*]}


for x in ${totalarray[@]} ; do
	echo "${totalarray[$x]} - ${inputarray[$x]}"
done


