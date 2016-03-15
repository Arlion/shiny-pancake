#!/bin/bash

read -p "IP? " ip
read -p "Username? " username


ssh -o connectionattempts=1000 $username@$ip

