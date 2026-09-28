#!/bin/bash

arr=()
counter=0

> report.log

while true
do
    arr+=(1 2 3 4 5 6 7 8 9 10)
    counter=$((counter + 1))

    if (( counter % 100000 == 0 ))
    then
        echo "step: $counter ; array size: ${#arr[@]}" >> report.log
    fi
done