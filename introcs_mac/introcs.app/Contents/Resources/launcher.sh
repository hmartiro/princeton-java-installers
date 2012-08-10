#!/bin/bash

# The installation directory
name=introcs

# Executing directory of the script
myDir="$( cd "$( dirname "$0" )" && pwd )"

# Runs the installation script, teeing to a log file
bash ${myDir}/${name}.sh 2>&1 | tee ~/log.txt

# Takes out the color coding from the log file
ESC=`echo -e "\033"`
sed -iE 's,'${ESC}[\[][0-9]*[a-zA-Z]',,g' ~/log.txt 2> /dev/null
rm ~/log.txtE 2> /dev/null

# Moves the log to its final location
mv ~/log.txt ~/${name}/log.txt 2> /dev/null

# Sets the owner of everything back to the original,
# since this script runs under root.
chown -R ${1} ~/${name} 2> /dev/null
chown -R ${1} /Applications/DrJava.app 2> /dev/null
chown -R ${1} ~/.drjava 2> /dev/null
chown -R ${1} ~/Library/Java/Extensions 2> /dev/null
