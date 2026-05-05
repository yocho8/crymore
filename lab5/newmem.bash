#!/bin/bash

N=$1

if [ -z "$N" ]
then
    echo "need ./newmem.bash N"
    exit 1
fi

arr=()

while true
do
    arr+=(1 2 3 4 5 6 7 8 9 10)

    if (( ${#arr[@]} > N ))
    then
        exit 0
    fi
done