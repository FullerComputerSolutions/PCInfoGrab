@Echo Off
echo PCInfoGrab Build Script
goto endauthorblock
======================================================================================================
Build.bat
Builds PCInfoGrab Exe Build 2018.05.17
BuildInfo
copy /b 7zS.sfx + config.txt + PCInfoGrab.7z PCInfoGrab.exe
Tested with encryption/password
::%~dp07z.exe u -py -mhe+ -x!build -x!PCInfoGrab -x!Releases PCInfoGrab.7z %~dp0..\
======================================================================================================
:endauthorblock

::Time
for /f "Tokens=1-4 Delims=/ " %%i in ('date /t') do  set dt=%%l.%%k.%%j
set filenameexe=PCInfoGrab%dt%.exe
set filename7z=PCInfoGrab%dt%.7z

Echo .
Echo Output Filename7z: %filename7z%
Echo Output FilenameExe: %filenameexe%
Echo .


%~dp07z.exe u -x!build -x!PCInfoGrab -x!Releases -x!.git -x!.gitattributes -x!README.md PCInfoGrab.7z %~dp0..\
copy /b 7zS.sfx + config.txt + PCInfoGrab.7z %filenameexe%
%~dp07z.exe u %filename7z% %filenameexe%
move %filename7z% %~dp0..\Releases
move %filenameexe% %~dp0..\Releases
del /q %~dp0PCInfoGrab.7z
::copy /b 7zS.sfx + config.txt + PCInfoGrab.7z PCInfoGrab.exe

ECHO Build Complete
pause




