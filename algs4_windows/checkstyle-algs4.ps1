# ************************************************
# checkstyle-algs4.ps1
# Hayk Martirosyan                   
# -------------
# Easy-to-understand wrapper for using checkstyle.
# ************************************************

# Path to the installation directory
$install = "$env:userprofile" + "\algs4"

# Wildcard for the directory of the checkstyle installation
$checkstyleWild = "${install}\checkstyle-?.?"

# Chooses the most recent version of checkstyle
$checkstyle = get-childitem $checkstyleWild -name | select -last 1

# Sets the final paths
$jar = "${install}\${checkstyle}\${checkstyle}-all.jar"
$xml = "${install}\${checkstyle}\checkstyle.xml"

# Exits if there are no arguments
if (!($args.length)) {
    "Specify .java files as arguments."
    "Usage: 'checkstyle Test.java'"
    exit
}

# Ensures that all arguments are .java files that exist
foreach ($arg in $args) {
    if ([System.IO.Path]::GetExtension($arg) -ne ".java") {
        "Checkstyle needs .java files as arguments!"
        "Filenames are case sensitive."
        exit
    } elseif (!(test-path "$arg")) {
        "File not found! Make sure the specified path is correct."
        "Filenames are case sensitive."
        exit
    }
}

# Runs checkstyle
"Running checkstyle on ${args}:"
java -jar "$jar" -c "$xml" $args