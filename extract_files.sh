#!/bin/sh

#version 0.1

# this script renames a file with respect to the name of the student who
# submitted that file and then copies it under a directory to compare it
# with other students' code for similarity check.
# plagiarism check is made by moss tool.
DEBUG=0

# test unnecessarily
if [ -d ./plagiarism_check ] ; then
    
    echo "info: directory exists, overwriting the directory"
    rm -rf plagiarism_check

else

    echo "info: directory does not exist, creating a new one"

fi

# change the directory
if [ -d ./grading ] ; then

    mkdir plagiarism_check # create the directory
    cd grading

else

    echo "error: cannot find the directory 'grading' "
    exit $?

fi

SUBMISSIONS=./*
FILENAME=ipr.cpp

# traverse the directory
for s in $SUBMISSIONS

    do
    
        DIRNAME=`dirname $s/$FILENAME`
        EXTDIRNAME=${DIRNAME#./}
        
        if [ $DEBUG -eq 1 ]; then
        
            echo $EXTDIRNAME
        
        fi
        
        cp $s/$FILENAME ../plagiarism_check/$EXTDIRNAME.cpp

done