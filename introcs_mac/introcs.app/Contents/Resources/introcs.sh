#!/bin/bash

# ************************************************
# introcs.sh                                     
# Hayk Martirosyan  
# -------------
# Mac OS X installation script for introcs.app 
# ************************************************

# The differences between algs4 and introcs installations are these
# three variables, the commenting out of Java3D, the inclusion of 
# algs4.jar and renumbering steps
name=introcs
url_base=http://introcs.cs.princeton.edu/java/mac
testFile=TestIntroCS

### COLOR PRINTING FUNCTIONS ###############################################

function normal {
	tput sgr0
}
function red { 
	tput setaf 1
	print "${1}"
	normal
}
function green { 
	tput setaf 2 
	print "${1}"
	normal
}
function blue { 
	tput setaf 4
	print "${1}"
	normal
}
function print {
	echo "${1}"
}

### INTRODUCTION SCREEN ####################################################

# Ensures terminal emulator can handle color
export TERM=xterm-color

# Creating the install directory
install=~/${name}

clear

green '####################################################################'
green '#                                                                  #'
green '#  8888888          888                     .d8888b.   .d8888b.    #'
green '#    888            888                    d88P  Y88b d88P  Y88b   #'
green '#    888            888                    888    888 Y88b.        #'
green '#    888   88888b.  888888 888d888 .d88b.  888         "Y888b.     #'
green '#    888   888 "88b 888    888P"  d88""88b 888            "Y88b.   #'
green '#    888   888  888 888    888    888  888 888    888       "888   #'
green '#    888   888  888 Y88b.  888    Y88..88P Y88b  d88P Y88b  d88P   #'
green '#  8888888 888  888  "Y888 888     "Y88P"   "Y8888P"   "Y8888P"    #'
green '#                                                                  #'
green '####################################################################'
green '#                                                                  #'
green '# Java Programming Environment Setup                               #'
green '# for Mac OS X - v3.5                                              #'
green '# Princeton University - Hayk Martirosyan                          #'
green '#                                                                  #'
green '####################################################################'

print
print 'Initializing functions and beginning installation...'

### UTILITY FUNCTIONS  #####################################################

# Executing directory of the script
myDir="$( cd "$( dirname "$0" )" && pwd )"

# Handy to supress output
null="/dev/null"

function logAndExit {
	
	print
	red 'NOTE: If there were any error messages during this setup, check the'
	red 'troubleshooting section on the website or ask for help.'
	
	print
	print 'A log file of this installation is saved at'
	blue "${install}/log.txt"
	
	print
	green 'You should now close this window.'
	exit
}

function download {
	print
	print "Downloading ${3} from"
	blue "${1}"
	print "to"
	blue "${2}"
	downloadQuiet "${1}" "${2}"
}

function downloadQuiet {


	if curl -sL "${1}" > "${2}" 2> ${null}; then
		return 1
	else
		print
		red "Cannot download ${1}"
		red "Make sure you have a working internet connection"
		red "and rerun this installation."
	
		logAndExit
	fi
}

function extractAndDelete {
	print
	print "Extracting zip archive in place at"
	blue "${1}"
	dest=`dirname ${1}`
	unzip -qqo "${1}" -d "${dest}"
	print "and deleting .zip file."
	rm -f "${1}"
}

function deleteOldVersion {
	if [ -d "${1}" ]; then
		print
		print "Deleting old version of ${2} at"
		blue "${1}"
		rm -rf "${1}"
	fi
}

function replaceInFile {
	print
	print "Replacing text in file"
	blue "${1}"
	print "from"
	blue "${2}"
	print "to"
	blue "${3}"
	sed -i '' 's|'${2}'|'${3}'|g' "${1}"
}

function createFolderIfNeeded {
	if [ ! -d "${1}" ]; then
		print
		print "Creating ${2} directory at"
		blue "${1}"
		mkdir "${1}"
	fi
}

### INITIALIZATION AND PRE-INSTALLATION SETUP ############################

createFolderIfNeeded "$install" "installation"

local="/usr/local"
createFolderIfNeeded "${local}" "user local"
bin="${local}/bin"
createFolderIfNeeded "$bin" "bin"

sleep 1

# Sends an email to count usage
python ${myDir}/counter.py 2> ${null}

### BEGINNING OF ACTUAL INSTALLATION #####################################

print
red '#### Step 1 - Java #################################################'

if /usr/bin/which -s java ; then
	print
	print 'Java is already installed.'
else
	print
	red 'No Java runtime detected.'
	red 'Install Java 6 Runtime Environment, then retry this installer.'
	print
	java -version
	print
	red 'You can close this window'
	exit
fi

javaCMD="${bin}/java-${name}"
javaCMDURL="${url_base}/java-${name}"
download "$javaCMDURL" "$javaCMD" "java execution script"

print
print "Granting executable permission to"
blue "${javaCMD}"
chmod +x "$javaCMD"

javacCMD="${bin}/javac-${name}"
javacCMDURL="${url_base}/javac-${name}"
download "$javacCMDURL" "$javacCMD" "javac execution script"

print
print "Granting executable permission to"
blue "${javacCMD}"
chmod +x "$javacCMD"

print
red '#### Step 2 - Java3D and Java OpenGL ###############################'

javaLib=~/Library/Java
createFolderIfNeeded "$javaLib" "Java library"

extensions=~/Library/Java/Extensions
createFolderIfNeeded "$extensions" "Java extensions"

java3d="${install}/java3d"
deleteOldVersion "$java3d" "Java3D"

java3dURL="${url_base}/java3d.zip"
java3dZip="${install}/java3d.zip"
download "$java3dURL" "$java3dZip" "Java3D"

extractAndDelete "$java3dZip"

print
print "Copying jni files from"
blue "${java3d}"
print "to"
blue "${extensions}"
cp -R ${java3d}/*.jnilib "${extensions}"

print
red '#### Step 3 - Textbook Libraries ##################################'

stdlib="${install}/stdlib.jar"

stdlibURL="http://introcs.cs.princeton.edu/java/stdlib/stdlib.jar"
download "$stdlibURL" "$stdlib" "stdlib.jar"

#print
#print "Copying library from"
#blue "${stdlib}"
#print "to"
#blue "${extensions}"
#cp ${stdlib} ${extensions}

print
red '#### Step 4 - Checkstyle ##########################################'

checkstyleWild="${install}/checkstyle-?.?"
deleteOldVersion "$checkstyle" "checkstyle"

checkstyleZip="${install}/checkstyle.zip"
checkstyleURL="${url_base}/checkstyle.zip"
download "$checkstyleURL" "$checkstyleZip" "checkstyle"

extractAndDelete "$checkstyleZip"

checkstyle="`print ${checkstyleWild}`"
checkstyleXML="${checkstyle}/checkstyle.xml"
checkstyleXMLURL="${url_base}/checkstyle.xml"
download "$checkstyleXMLURL" "$checkstyleXML" "checkstyle configuration file"

checkstyleCMD="${bin}/checkstyle-${name}"
checkstyleCMDURL="${url_base}/checkstyle-${name}"
download "$checkstyleCMDURL" "$checkstyleCMD" "checkstyle execution script"

print
print "Granting executable permission to"
blue "${checkstyleCMD}"
chmod +x "$checkstyleCMD"

print
red '#### Step 5 - Findbugs ############################################'

findbugsWild="${install}/findbugs-?.?.?"
deleteOldVersion "$findbugsWild" "findbugs"

findbugsZip="${install}/findbugs.zip"
findbugsURL="${url_base}/findbugs.zip"
download "$findbugsURL" "$findbugsZip" "findbugs"

extractAndDelete "$findbugsZip"

findbugs="`print ${findbugsWild}`"
findbugsXML="${findbugs}/findbugs.xml"
findbugsXMLURL="${url_base}/findbugs.xml"
download "$findbugsXMLURL" "$findbugsXML" "findbugs configuration file"

findbugsCMD="${bin}/findbugs-${name}"
findbugsCMDURL="${url_base}/findbugs-${name}"
download "$findbugsCMDURL" "$findbugsCMD" "findbugs execution script"

print
print "Granting executable permission to"
blue "${findbugsCMD}"
chmod +x "$findbugsCMD"

print
red '#### Step 6 - DrJava ##############################################'

drjavaApp="/Applications/DrJava.app"
deleteOldVersion "$drjavaApp" "DrJava"

drjava="/Applications/drjava.tar.gz"
drjavaURL="${url_base}/drjava-osx.tar.gz"
download "$drjavaURL" "$drjava" "DrJava"

print
print 'Extracting DrJava into the Applications directory'
blue "${drjavaApp}"
cd "/Applications"
tar xzf "$drjava"
rm "$drjava"

drjavaConfig=~/.drjava
drjavaConfigURL="${url_base}/drjava-config.txt"
download "$drjavaConfigURL" "$drjavaConfig" "DrJava configuration file"

replaceInFile "${drjavaConfig}" "INSTALL_DIR" "${install}"

print
print 'Creating a shortcut to DrJava on the desktop...'
ln -sf "$drjavaApp" ~/Desktop

print
red '#### Step 7 - Terminal #############################################'

terminalApp="/Applications/Utilities/Terminal.app"

print
print 'Creating a shortcut to Terminal on the desktop...'
ln -sf "$terminalApp" ~/Desktop

print
red '#### Step 8 - Test it out! #########################################'

print
print 'Downloading the test Java program...'
javaTestURL="${url_base}/${testFile}.java"
javaTest="${myDir}/${testFile}.java"
downloadQuiet "$javaTestURL" "$javaTest"

coverURL="${url_base}/cover.jpg"
cover="${myDir}/cover.jpg"
downloadQuiet "$coverURL" "$cover"

cd "$myDir"

print
print 'Installation complete! Compiling test program...'
javac-${name} ${testFile}.java

print 'Test program compiled. Running...'
java-${name} ${testFile}

rm -f "${testFile}.class"
rm -f "${testFile}.java"
rm -f "cover.jpg"

print
green 'If you saw the bullseye and textbook graphic, the installation'
green 'was successful and you are ready to start programming in Java.'
green 'Continue with the introductory tutorial on the website.'

logAndExit
