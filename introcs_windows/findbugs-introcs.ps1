# ************************************************
# findbugs-introcs.ps1
# Hayk Martirosyan                   
# -------------
# Easy-to-understand wrapper for using findbugs.
# ************************************************

# Path to the installation directory
$install = "$env:userprofile" + "\introcs"

# Wildcard for the directory of the checkstyle installation
$findbugsWild = "${install}\findbugs-?.?.?"

# Chooses the most recent version of findbugs
$findbugs = get-childitem $findbugsWild -name | select -last 1

# Sets the final paths
$jar = "${install}\${findbugs}\lib\findbugs.jar"
$xml = "${install}\${findbugs}\findbugs.xml"
$aux = "${install}\stdlib.jar;${install}\j3d\lib\ext\vecmath.jar;${install}\j3d\lib\ext\j3dcore.jar;${install}\j3d\lib\ext\j3dutils.jar"

# Exits if there are no arguments
if (!($args.length)) {
    "Specify .class or .jar files as arguments."
    "Usage: 'findbugs Test.class'"
    exit
}

# Ensures that all arguments are .class or .jar files that exist
foreach ($arg in $args) {
    if ((".class",".jar") -notcontains [System.IO.Path]::GetExtension($arg)) {
        "Findbugs needs .class or .jar files as arguments!"
        "Filenames are case sensitive."
        exit
    } elseif (!(test-path "$arg")) {
        "File not found! Make sure the specified path is correct."
        "Filenames are case sensitive."
        exit
    }
}

# Runs findbugs
"Running findbugs on ${args}:"
java -jar "$jar" -textui -longBugCodes -exclude "$xml" -auxclasspath "$aux" $args