#!/bin/bash

prices=(9.20 8.03 10.02 8.08 8.14 8.10 8.31 8.28 8.35 8.34 8.39 8.45 8.38 8.38 8.32 8.36 8.28 8.28 8.38 8.48 8.49 8.54 8.73 8.72 8.76 8.74 8.87 8.82 8.81 8.82 8.85 8.85 8.86 8.63 8.70 8.68 8.72 8.77 8.69 8.65 8.70 8.98 8.98 8.87 8.71 9.17 9.34 9.28 8.98 9.02 9.16 9.15 9.07 9.14 9.13 9.10 9.16 9.06 9.10 9.15 9.11 8.72 8.86 8.83 8.70 8.69 8.73 8.73 8.67 8.70 8.69 8.81 8.82 8.83 8.91 8.80 8.97 8.86 8.81 8.87 8.82 8.78 8.82 8.77 8.54 8.32 8.33 8.32 8.51 8.53 8.52 8.41 8.55 8.31 8.38 8.34 8.34 8.19 8.17 8.16)

# Start with zero profit, and a placeholder answer
max_profit=0
answer=(0 0)

n=${#prices[@]}

# Fugly eval/echo to utilize {lo..hi} expansion in for loop
for ((i=0; i<$n; i++)); do
	buy=${prices[i]}
	# Skip 2 ticker prices ahead, nested loop for checking sell price
	for ((j=$(($i+2)); j<$n; j++)); do
		sell=${prices[j]}
		#echo "Checking Buy: $buy   Sell: $sell"
		profit=$(bc <<< "$sell - $buy")
		if [[ $profit > $max_profit ]]; then
			# We have a more profitable buy/sell combo
			max_profit=$profit
			answer=($buy $sell)
		fi
	done
done

echo ${answer[@]}
