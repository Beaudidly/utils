#!/bin/sh

clock () {
    time=$(date '+%H:%M')
    echo -n "$time"
}

while true; 
do
    echo "%{c}%{F#a8a8a8}%{B#2a2a2a}$(clock)"
    sleep 1;
done
