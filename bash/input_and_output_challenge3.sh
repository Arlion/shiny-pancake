#!/bin/bash

array1=$(cut -d ' ' -f 2 bhaarat.text | grep 'H\|S')

echo $array1 > out.text
echo "23. English" >> bhaarat.text
