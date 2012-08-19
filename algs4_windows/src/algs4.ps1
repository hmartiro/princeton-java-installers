# ************************************************
# algs4.ps1                   
# Hayk Martirosyan                   
# -------------
# Windows installation script for algs4.exe
# ************************************************

# The only difference between algs4 and introcs installations are these
# three variables, the commenting out of Java3D and algs4.jar, and renumbering steps
$install_directory = "algs4"
$url_base = "http://algs4.cs.princeton.edu/windows/"
$testFile = "TestAlgs4"
 
### COLOR PRINTING FUNCTIONS ###############################################

function red    { write-host $args -foregroundcolor "red"   }
function green  { write-host $args -foregroundcolor "green" }
function blue   { write-host $args -foregroundcolor "blue"  }

### INTRODUCTION SCREEN ####################################################

# Creating the install directory
$home_dir = "$env:userprofile"
$install = "$home_dir" + "\" + "$install_directory"

# Starting the log file recording
$logFile = "$install" + "Log.txt"
start-transcript -force -path "$logFile" | Out-Null

clear

green '####################################################################'
green '#                                                                  #'
green '#            d8888 888      .d8888b.   .d8888b.        d8888       #'
green '#           d88888 888     d88P  Y88b d88P  Y88b      d8P888       #'
green '#          d88P888 888     888    888 Y88b.          d8P 888       #'
green '#         d88P 888 888     888         "Y888b.      d8P  888       #'
green '#        d88P  888 888     888  88888     "Y88b.   d88   888       #'
green '#       d88P   888 888     888    888       "888   8888888888      #'
green '#      d8888888888 888     Y88b  d88P Y88b  d88P         888       #'
green '#     d88P     888 88888888 "Y8888P88  "Y8888P"          888       #'
green '#                                                                  #'
green '####################################################################'
green '#                                                                  #'
green '# Java Programming Environment Setup                               #'
green '# for Microsoft Windows - v3.0                                     #'
green '# Princeton University - Hayk Martirosyan                          #'
green '#                                                                  #'
green '####################################################################'

''
'Initializing functions and beginning installation...'

### INSTALL COUNTER VIA EMAIL ##############################################

try {
    $target = "princeton.java.installers@gmail.com"
    $subject = "The ${install_directory}.exe installer has been run!"
    $SMTP = New-Object Net.Mail.SmtpClient("smtp.gmail.com")
    $SMTP.Port = 587
    $SMTP.EnableSsl = $true
    $SMTP.Credentials = New-Object System.Net.NetworkCredential("princeton.java.installers", "princeton java installers")
    $SMTP.Send($target, $target, $subject, "")
} catch { 
''
'Could not connect to send counter.'
}

### ENVIRONMENT VARIABLE FUNCTIONS  ########################################

function setEnv ($var, $value) {
    [Environment]::SetEnvironmentVariable($var, $value, "user")
    [Environment]::SetEnvironmentVariable($var, $value, "process")
}

function setSystemEnv ($var, $value) {
    [Environment]::SetEnvironmentVariable($var, $value, "machine")
}
 
function getUserEnv ($var) {
    [Environment]::GetEnvironmentVariable($var, "user")
}

function getProcessEnv ($var) {
    [Environment]::GetEnvironmentVariable($var, "process")
}

function getSystemEnv ($var) {
    [Environment]::GetEnvironmentVariable($var, "machine")
}

function addToClasspath ($jarfile) {
   ''
   'Setting the user CLASSPATH environment variable to include'
    blue "$jarfile"
    $matcher = [regex]::escape($jarfile);
    if (!((getUserEnv "classpath") -match "$matcher")) {
        $new_classpath = $jarfile + ";" + (getUserEnv "classpath")
        setEnv "classpath" $new_classpath
    }
}

function addToPath ($directory) {
    ''
    'Setting the user PATH environment variable to include'
    blue "$directory"
    $matcher = [regex]::escape($directory);
    if (!((getUserEnv "path") -match "$matcher")) {
        $new_path = $directory + ";" + (getUserEnv "path")
        setEnv "path" $new_path
    }
}

function addToSystemPath ($directory) {
    $matcher = [regex]::escape($directory);
    if (!((getSystemEnv "path") -match "$matcher")) {
        $new_path = $directory + ";" + (getSystemEnv "path")
        setSystemEnv "path" $new_path
    }
}

### UTILITY FUNCTIONS  #####################################################

# Executing directory of this script
$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
set-location "$myDir"

function logAndExit () {
    ''
    red 'NOTE: If there were any error messages during this setup, check the'
    red 'troubleshooting section on the website or ask for help.'

    $newLogFile = "$install" + "\log.txt"
    ''
    'A log file of this installation is saved at'
    blue "$newLogFile"

    ''
    green 'You should now close this window...'

    # Stops recording the log and moves it to the installation folder
    stop-transcript | Out-Null
    move-item -force "$logFile" "$newLogFile"

    $Host.UI.RawUI.FlushInputBuffer()
    Read-Host | Out-Null
    exit
}

function download ($url, $destination, $name, [switch]$quiet) {
   if(!($quiet)) {
     ''
     "Downloading $name from"
     blue "$url"
     "to"
     blue "$destination"
   }
   
   try {
       $web_client = new-object System.Net.WebClient
       $web_client.DownloadFile($url, $destination)
   } catch [Exception] {
     ''
     red "Cannot download $url"
     red "Make sure you have a working internet connection"
     red "and rerun this installation."
     
     logAndExit
  }
}

function extractAndDelete ($zipFile) {
    ''
    "Extracting zip archive in place at"
    blue "$zipFile"
    $dest = split-path -parent $zipFile
    .\unzip -qo "$zipFile" -d "$dest"
    
    "and deleting .zip file."
    remove-item -force "$zipFile"
}

function deleteOldVersion ($dir, $name) {
  if (test-path "$dir") {
      ''
      "Deleting old version of $name at"
      blue "$dir"
      try {
      remove-item -recurse -force "$dir" -ErrorAction Stop
      } catch [Exception] {
        ''
        red "The $name directory above is currently in use by another program."
        red "Please exit unnecessary programs and rerun installation."
        $Host.UI.RawUI.FlushInputBuffer()
        Read-Host | Out-Null
        exit
      }
  }
}

function replaceInFile ($filename, $initial, $final) {
  ''
  "Replacing text in file"
  blue "$filename"
  "from"
  blue "$initial"
  "to"
  blue "$final"
  (get-content "$filename") | 
  foreach-object { $_ -replace "$initial", "$final" } | 
  set-content "$filename"
}

function createFolderIfNeeded ($directory, $name) {
  if (!(test-path "$directory")) {
      ''
      "Creating $name directory at"
      blue "$directory"
      new-item -path "$directory" -type directory | out-null
  }
}

### INITIALIZATION AND PRE-INSTALLATION SETUP ############################

# Setting correct initial process and user env variables.
if (!(getUserEnv "path")) {
    setEnv "path" (getUserEnv "path")#(getSystemEnv "path")
} else {
    setEnv "path" (getUserEnv "path")
}
if (!(getUserEnv "classpath")) {
    setEnv "classpath" (getSystemEnv "classpath")
} else {
    setEnv "classpath" (getUserEnv "classpath")
}

createFolderIfNeeded "$install" "installation"

$bin = "$install" + "\bin"
createFolderIfNeeded "$bin" "bin"

sleep 1

### BEGINNING OF ACTUAL INSTALLATION #####################################

''
'Checking system architecture...'
$architecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
if ("$architecture".StartsWith("64")) {
    '64-bit machine detected.'
    $javaURL = "$url_base" + "java64.zip"
    $j3dURL = "$url_base" + "j3d64.zip"
} else {
    '32-bit machine detected.'
    $javaURL = "$url_base" + "java32.zip"
    $j3dURL = "$url_base" + "j3d32.zip"
}

''
red '#### Step 1 - Java #################################################'

$java = "$install" + "\java"
deleteOldVersion "$java" "Java"

$javaZip = "$install" + "\java.zip"
download "$javaURL" "$javaZip" "Java"

extractAndDelete "$javaZip"

$javaBin = "$java" + "\bin"
addToPath "$javaBin"
addToSystemPath "$javaBin"

<#''
red '#### Step 2 - Java3D ###############################################'

$j3d = "$install" + "\j3d"
deleteOldVersion "$j3d" "Java3D"

$j3dZip = "$install" + "\j3d.zip"
download "$j3dURL" "$j3dZip" "Java3D"

extractAndDelete "$j3dZip"

$j3dBin  = "$j3d" + "\bin"
addToPath "$j3dBin"

$vecmath  = "$j3d" + "\lib\ext\vecmath.jar";
$j3dcore  = "$j3d" + "\lib\ext\j3dcore.jar";
$j3dutils = "$j3d" + "\lib\ext\j3dutils.jar";
addToClasspath "$vecmath"
addToClasspath "$j3dcore"
addToClasspath "$j3dutils"
#>
''
red '#### Step 2 - Textbook Libraries ###################################'

$stdlib  = "$install" + "\stdlib.jar"
$algs4 = "$install" + "\algs4.jar"

$stdlibURL = "http://introcs.cs.princeton.edu/java/stdlib/stdlib.jar";
download "$stdlibURL" "$stdlib" "stdlib.jar"

$algs4URL = "http://algs4.cs.princeton.edu/code/algs4.jar";
download "$algs4URL" "$algs4" "algs4.jar"

addToClasspath "$stdlib"
addToClasspath "$algs4"

''
red '#### Step 3 - Checkstyle ###########################################'

$checkstyleWild = "$install" + "\checkstyle-?.?"
deleteOldVersion "$checkstyleWild" "checkstyle"

$checkstyleZip = "$install" + "\checkstyle.zip"
$checkstyleURL = "$url_base" + "checkstyle.zip"
download "$checkstyleURL" "$checkstyleZip" "checkstyle"

extractAndDelete "$checkstyleZip"

$checkstyle = "$install" + "\" + (ls -name "$checkstyleWild")
$checkstyleXML = "$checkstyle" + "\checkstyle.xml"
$checkstyleXMLURL = "$url_base" + "checkstyle.xml"
download "$checkstyleXMLURL" "$checkstyleXML" "checkstyle configuration file"

$checkstyleCMD = "$bin" + "\checkstyle.bat"
$checkstyleCMDURL = "$url_base" + "checkstyle.bat"
download "$checkstyleCMDURL" "$checkstyleCMD" "checkstyle execution script"

$checkstylePS1 = "$bin" + "\checkstyle.ps1"
$checkstylePS1URL = "$url_base" + "checkstyle.ps1"
download "$checkstylePS1URL" "$checkstylePS1" "checkstyle wrapper script"

addToPath "$bin"

''
red '#### Step 4 - Findbugs #############################################'

$findbugsWild = "$install" + "\findbugs-?.?.?"
deleteOldVersion "$findbugsWild" "findbugs"

$findbugsZip = "$install" + "\findbugs.zip"
$findbugsURL = "$url_base" + "findbugs.zip"
download "$findbugsURL" "$findbugsZip" "findbugs"

extractAndDelete "$findbugsZip"

$findbugs = "$install" + "\" + (ls -name "$findbugsWild")
$findbugsXML = "$findbugs" + "\findbugs.xml"
$findbugsXMLURL = "$url_base" + "findbugs.xml"
download "$findbugsXMLURL" "$findbugsXML" "findbugs configuration file"

$findbugsCMD = "$bin" + "\findbugs.bat"
$findbugsCMDURL = "$url_base" + "findbugs.bat"
download "$findbugsCMDURL" "$findbugsCMD" "findbugs execution script"

$findbugsPS1 = "$bin" + "\findbugs.ps1"
$findbugsPS1URL = "$url_base" + "findbugs.ps1"
download "$findbugsPS1URL" "$findbugsPS1" "findbugs wrapper script"

addToPath "$bin"

# BUGFIX: Apparently, the first time you run findbugs, it makes a registry change, so you need to be admin..
# This is an attempt to run it in the installer so that the registry key is made.
''
'Adding findbugs to registry...'
java -jar "${findbugs}\lib\findbugs.jar" -textui -longBugCodes -exclude "$findbugsXML" "nonsense" 2>1 $null

''
red '#### Step 6 - DrJava ###############################################'

$drjava = "$install" + "\drjava.jar"
$drjavaURL = "$url_base" + "drjava.jar"
download "$drjavaURL" "$drjava" "DrJava"

$drjavaConfig = "$home_dir" + '\' + '.drjava'
$drjavaConfigURL = "$url_base" + "drjava-config.txt"
download "$drjavaConfigURL" "$drjavaConfig" "DrJava configuration file"

$install_formatted = $install -replace "\\", '\\'
replaceInFile "$drjavaConfig" "INSTALL_DIR" "$install_formatted"

''
'Creating a shortcut to DrJava from'
$shortcut = "$install" + "\DrJava.lnk"
blue "$shortcut"
"to"
blue "$drjava"
$link = (New-Object -ComObject WScript.Shell).CreateShortcut("$shortcut")
$link.TargetPath = "`"$javaBin" + "\javaw.exe`""
$link.Arguments = " -jar " + "`"$drjava`""
$link.Save()

''
'Creating a shortcut to DrJava from'
$shortcut = [Environment]::GetFolderPath("Desktop") + "\DrJava.lnk"
blue "$shortcut"
"to"
blue "$drjava"
$link = (New-Object -ComObject WScript.Shell).CreateShortcut("$shortcut")
$link.TargetPath = "`"$javaBin" + "\javaw.exe`""
$link.Arguments = " -jar " + "`"$drjava`""
$link.Save()

''
red '#### Step 7 - Command Prompt #######################################'

''
'Editing registry to customize Command Prompt preferences...'
'Setting Quick Edit mode to on.'
'Setting Insert Mode to on.'
'Setting the Screen Buffer Size to 80 x 500.'

function setCMDProperties ($path) {
    if (test-path "$path") {
        set-itemproperty -path "$path" -name QuickEdit -value 1
        set-itemproperty -path "$path" -name InsertMode -value 1
        # This value is (500 << 16) + 80 for a 80x500 buffer.
        set-itemproperty -path "$path" -name ScreenBufferSize -value 32768080
    }
}

# Locations that the CMD may store keys
setCMDProperties "HKCU:Console"
setCMDProperties "HKCU:Console\%SystemRoot%_system32_cmd.exe"

''
'Creating a shortcut to Command Prompt on the desktop from'
$shortcut = [Environment]::GetFolderPath("Desktop") + "\Command Prompt.lnk"
blue "$shortcut"
"to"
blue "$env:ComSpec"
$link = (New-Object -ComObject WScript.Shell).CreateShortcut("$shortcut")
$link.TargetPath = "$env:ComSpec"
$link.Save()

# Adds the . directory for the classpath
$matcher = [regex]::escape('.;');
if (!((getUserEnv "classpath") -match "$matcher")) {
    $new_classpath = '.;' + (getUserEnv "classpath")
    setEnv "classpath" $new_classpath
}

''
red '#### Step 7 - Test it out! #########################################'

''
'Installation complete! Downloading test Java program...'
$javaTestURL = "$url_base" + "$testFile" + ".java"
$javaTest = "$myDir" + "\" + "$testFile" + ".java"
download "$javaTestURL" "$javaTest" "test Java program" -quiet

$coverURL = "$url_base" + "cover.jpg"
$cover = "$myDir" + "\cover.jpg"
download "$coverURL" "$cover" "textbook cover image" -quiet

''
'Compiling test Java program...'
javac "${testFile}.java"

'Test program compiled. Running...'
java "${testFile}"

remove-item "${testFile}.class"
remove-item "${testFile}.java"
remove-item "cover.jpg"

''
green 'If you saw the bullseye and textbook graphic, the installation'
green 'was successful and you are ready to start programming in Java.'
green 'Continue with the introductory tutorial on the website.'

logAndExit