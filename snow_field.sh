#!/bin/bash

# taken from @BubBobz and @climagic

COLUMNS=80

for((I=0;J=--I;)) do
    clear;
    for((D=LINES;S=++J**3%COLUMNS,--D;)) do
        printf %*s.\\n $S;
    done;
    sleep 0.1;
done