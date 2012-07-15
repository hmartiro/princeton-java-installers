princeton-java-installers
=========================

A set of installers for Windows and OS X that set up the programming environment used in Princeton's introductory computer science classes (COS 126 and COS 226).

Anatomy of the installation scripts:

  * Windows:
	* 
		* introcs.exe is made from four files: a core PowerShell script, a launcher batch file, an icon, and an unzip utility
		* The core script, introcs.ps1 (423 lines), is written in PowerShell, a pretty cool .NET scripting language which is very simple to use:  http://ss64.com/ps/. There is a free IDE which comes with windows (Windows PowerShell ISE) that I used to edit it.
		* The launcher script launcher.bat (10-15 lines) basically just invokes the PowerShell script, or provides a helpful error message if it can't find PowerShell. I used a program called Quick Batch File Compiler to turn the batch file into an executable, and within that program included the introcs icon and an unzip utility unzip.exe (PowerShell was extremely slow to unzip).
		* To compile introcs.exe, open QuickBFC, load the batch script, add the icon and unzip.exe in the embedded files, and hit build. The embedded file is accessed in the PowerShell script with the environment variable %MYFILES%, which QuickBFC creates.

	* OS X:
	* 
		* introcs.app is made from three files: an applescript app, a core bash script, and a launcher bash script
		* The core script introcs.sh (346 lines) is written in bash and has the exact same functionality as the PowerShell script.
		* The launcher script (25 lines), launcher.sh executes and logs the core script and sets some permissions
		* The .app directory is created through Applescript. You can open it directly using applescript, and see the applescript code that invokes the bash scripts in a terminal window. The icon and bash scripts are included, and you can save as an application diretly from applescript.
		* To compile introcs.app, no work is needed. You can change the bash scripts directly, and the applescript code in applescript.

	* I created functions with identical names at the start of the two core scripts, so 90% of the code should look the same between the Windows and OSX versions.
	* The algs4 versions have only a few differences: the icons, the filenames, the fact that java3d installation is commented out, and now that only the algs4 version includes algs4.jar.
