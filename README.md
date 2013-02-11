princeton-java-installers
=========================

A set of installers for Windows and OS X that set up the programming environment used in Princeton's introductory computer science classes (COS 126 and COS 226).

Anatomy of the installation scripts:

  * Windows:
	* introcs.exe is made from four files: a core PowerShell script, a launcher batch file, an icon, and an unzip utility
	* The core script, introcs.ps1 (423 lines), is written in PowerShell, a .NET scripting language which is very simple to use:  http://ss64.com/ps/. A free IDE is included with Windows (Windows PowerShell ISE).
	* The launcher script launcher.bat (10-15 lines) serves to execute the PowerShell script, and provides a helpful error message if it can't find PowerShell. A small utility called [Quick Batch File Compiler](http://www.abyssmedia.com/quickbfc/) is used to turn launcher.bat into an executable (introcs.exe) that bundles the PowerShell script, the introcs icon, and an unzip utility unzip.exe.
	* To compile introcs.exe, open QuickBFC, load the batch script, add the icon and unzip.exe in the embedded files, and hit build. The embedded file is accessed in the PowerShell script with the environment variable %MYFILES%, which QuickBFC creates.

  * OS X:
	* introcs.app is made from three files: an applescript app, a core bash script, and a launcher bash script
	* The core script introcs.sh (346 lines) is written in bash and has the exact same functionality as the PowerShell script.
	* The launcher script launcher.sh (25 lines) executes and logs the core script and sets some permissions
	* The .app directory is created through Applescript. You can open it directly using applescript, and see the applescript code that invokes the bash scripts in a terminal window. The icon and bash scripts are included, and you can save as an application diretly from applescript.
	* To compile introcs.app, no work is needed. You can change the bash scripts directly, and the applescript code in applescript.

  * Both
	* There are functions with identical names at the start of the two core scripts, so beyond the function definitions the PowerShell and bash scripts should be almost identical.
	* The algs4 versions have only a few differences: the icons, the filenames, the fact that java3d installation is commented out, and that only the algs4 version includes algs4.jar.
