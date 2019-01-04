#!/bin/bash
# Program name: pingall.sh
date
cat synology.txt |  while read output
do
    echo "$output"
    ./beta.sh "$output" > /dev/null
done
