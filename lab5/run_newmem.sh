#!/bin/bash

N=$1
K=$2

if [ -z "$N" ] || [ -z "$K" ]
then
    echo "need ./run_newmem.bash N K"
    exit 1
fi

for (( i=1; i<=K; i++ ))
do
    echo "staring process $i with N=$N"
    ./newmem.bash "$N" &
    sleep 1
done

wait

echo "all process finished"