@Echo Off
echo PCInfoGrab Rev 18.05.17
goto endauthorblock
======================================================================================================
PCInfoGrab.cmd
Gets PC Information. Rev 18.05.17
BuildInfo
copy /b 7zS.sfx + config.txt + PCInfoGrab.7z PCInfoGrab.exe
 v18.05.17 Added build script to make building exe easier, allowing option to skip speedtest on slow connections, re-added Admin elevation to config.txt, added PSTPassword.
 v18.05.08 Added AutoCAD Serial Prompt, updated apps. Replaced iepv.exe with webbrowserpassview.exe
 v17.01.18 Added notes prompt
======================================================================================================
:endauthorblock

::Set output filename
set text=%~dp0%username%.%computername%.PCinfo.txt
::Remove whitespace in filename
set text=%text: =%
Echo Creating filename: %text%

echo Workgroup, Domain, NBT Info...
echo Workgroup, Domain, NBT Info >> %text%
C:\Windows\sysnative\nbtstat.exe -a %computername% >> %text%
C:\Windows\syswow64\nbtstat.exe -a %computername% >> %text%
C:\Windows\system32\nbtstat.exe -a %computername% >> %text%
nbtstat.exe -a %computername% >> %text%
echo .............................................. >> %text%
echo .............................................. >> %text%
pause
::cleanup
Echo Performing Cleanup...
del keys.txt email.txt wireless.txt iepwd.txt printers.txt software.txt downtest.txt produkey.txt pstpwd.txt
notepad %text%