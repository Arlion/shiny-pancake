#!/bin/bash

prompt -p "IP? " ip
prompt -p "Username? " username

for x in {1..100}; do ssh $username@$ip ; sleep 5; done
