#!/bin/bash
# Info: Auto switch single/extend display with disper on Multiple Monitor.

lines=`disper -l | wc -l`
display_count=$((lines / 2))

if [ $display_count -eq "1" ]; then
    disper -d DFP-0 -s
else
    disper -d auto -e -t left
fi
