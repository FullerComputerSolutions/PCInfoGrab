@Echo Off
echo PCInfoGrab Rev 18.05.17
goto endauthorblock
======================================================================================================
PCInfoGrab.cmd
Gets PC Information. Rev 18.05.17
BuildInfo
copy /b 7zS.sfx + config.txt + PCInfoGrab.7z PCInfoGrab.exe
 v18.05.17 Added build script to make building exe easier, allowing option to skip speedtest on slow connections, re-added Admin elevation to config.txt, added PSTPassword, fixed NBTStat not running in 64bit OS. Properly synced with github.
 v18.05.08 Added AutoCAD Serial Prompt, updated apps. Replaced iepv.exe with webbrowserpassview.exe
 v17.01.18 Added notes prompt
======================================================================================================
:endauthorblock

::Set output filename
set text=%~dp0%username%.%computername%.PCinfo.txt
::Remove whitespace in filename
set text=%text: =%
Echo Creating filename: %text%

set arch=x86

echo Start configuration info > %text% 2> nul
echo PCInfoGrab Rev 18.05.17 >> %text% 2> nul
Echo Generating Timestamps...
date /t >> %text% 2> nul
time /t >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

::VERSION Check
ECHO OS Version Checks...
ver | find "2003" > nul
if %ERRORLEVEL% == 0 goto ver_2003
ver | find "XP" > nul
if %ERRORLEVEL% == 0 goto ver_xp
ver | find "2000" > nul
if %ERRORLEVEL% == 0 goto ver_2000
ver | find "NT" > nul
if %ERRORLEVEL% == 0 goto ver_nt

if not exist %SystemRoot%\system32\systeminfo.exe goto skipvercheck

systeminfo | find "OS Name" > %TEMP%\osname.txt
FOR /F "usebackq delims=: tokens=2" %%i IN (%TEMP%\osname.txt) DO set vers=%%i
echo OS Name: %vers% >> %text% 2> nul
echo %vers% | find "Windows 7" > nul
if %ERRORLEVEL% == 0 goto ver_7

echo %vers% | find "2008" > nul
if %ERRORLEVEL% == 0 goto ver_2008

echo %vers% | find "Windows Vista" > nul
if %ERRORLEVEL% == 0 goto ver_vista

echo %vers% | find "Windows 8" > nul
if %ERRORLEVEL% == 0 goto ver_8

echo %vers% | find "Windows 10" > nul
if %ERRORLEVEL% == 0 goto ver_10

goto skipvercheck

:ver_10
:Run Windows 10 specific commands here.
echo Windows 10 >> %text% 2> nul
goto vercheckdone

:ver_8
:Run Windows 8 specific commands here.
echo Windows 8 >> %text% 2> nul
goto vercheckdone

:ver_7
:Run Windows 7 specific commands here.
echo Windows 7 >> %text% 2> nul
goto vercheckdone

:ver_2008
:Run Windows Server 2008 specific commands here.
echo Windows Server 2008 >> %text% 2> nul
goto vercheckdone

:ver_vista
:Run Windows Vista specific commands here.
echo Windows Vista >> %text% 2> nul
goto vercheckdone

:ver_2003
:Run Windows Server 2003 specific commands here.
echo Windows Server 2003 >> %text% 2> nul
goto vercheckdone

:ver_xp
:Run Windows XP specific commands here.
echo Windows XP >> %text% 2> nul
goto vercheckdone

:ver_2000
:Run Windows 2000 specific commands here.
echo Windows 2000 >> %text% 2> nul
goto vercheckdone

:ver_nt
:Run Windows NT specific commands here.
echo Windows NT >> %text% 2> nul
goto vercheckdone

:vercheckskipped
echo systeminfo.exe missing, OS undetermined. >> %text% 2> nul

:vercheckdone

::Arch Check
echo Arch Detection...
for /F "tokens=3" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set arch=%%a
if %arch%==AMD64 goto 64BIT 
echo 32-bit OS >> %text% 2> nul
set arch=x86
goto donearch 
:64BIT 
echo 64-bit OS >> %text% 2> nul
set arch=x64
:donearch

echo Current User Shell Folder Locations...
echo Current User Shell Folder Locations >> %text% 2> nul
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /s | find /i /v "HKEY" | find /i /v "REG.EXE" >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Default Browser...
echo Default Browser >> %text% 2> nul
reg QUERY HKEY_CLASSES_ROOT\http\shell\open\command /ve >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo IE Current User Homepage Setting...
echo IE Current User Homepage Setting >> %text% 2> nul
for /f "usebackq tokens=4" %%a in (`reg query "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" ^| find /i "Start"`) do echo %%a >> %text% 2> nul
echo IE Current User Secondary Homepage Setting >> %text% 2> nul
for /f "usebackq tokens=5" %%a in (`reg query "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Secondary Start Pages" ^| find /i "Secondary"`) do echo %%a >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

::Chrome HP Check
if exist "%userprofile%\Local Settings\Application Data\Google\Chrome" goto chromehp
if exist "%userprofile%\appdata\local\google\chrome" goto chromehp
goto skipchrome
:chromehp
echo Chrome HomePage...
echo Chrome HomePage >> %text% 2> nul
type "%userprofile%\Local Settings\Application Data\Google\Chrome\User Data\Default\Preferences" | find /i "homepage" >> %text% 2> nul
:skipchrome

::Firefox HP Check
if exist "%programfiles%\Mozilla Firefox" goto ffhp
if exist %programfiles(x86)%\Mozilla Firefox" goto ffhp
goto skipff
:ffhp
echo Firefox Homepage...
echo Firefox Homepage >> %text% 2> nul
for /f "tokens=2 delims==" %%a in ('find /i "path=" "%appdata%\mozilla\firefox\profiles.ini"') do set p=%%a
set p=%appdata%\mozilla\firefox\%p%
echo %p% >> %text% 2> nul
::type %userprofile%
:skipff

::echo Current User Homepage Setting >> %text%
::reg query "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" >> %text%
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Speedtest >> %text% 2> nul
echo Speedtest (this can take some time)... Press N to skip, Y to continue.
choice /T 5 /C YN /D Y
if %ERRORLEVEL%==1 goto :YesST
if %ERRORLEVEL%==2 goto :NoST
:YesST
echo Speedtest Running, please wait...
echo Speedtest >> %text% 2> nul
downtester.exe /hidden /stext "" >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul
goto :AfterST
:NoST
echo Skipped
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul
:AfterST

echo Network Info...
echo Network Info >> %text% 2> nul
ipconfig /all >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Workgroup, Domain, NBT Info...
echo Workgroup, Domain, NBT Info >> %text% 2> nul
if %arch%==x86 (
nbtstat.exe -a %computername% >> %text% 2> nul
) ELSE (
C:\Windows\sysnative\nbtstat.exe -a %computername% >> %text% 2> nul
)
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo WAN IP Info...
echo WAN IP Info >> %text%
nslookup myip.opendns.com resolver1.opendns.com >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Mapped drives...
echo Mapped drives >> %text% 2> nul
net use >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Shares...
echo Shares >> %text% 2> nul
net share >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Wireless Keys...
echo Wireless Keys >> %text% 2> nul
if %arch%==x86 (
wirelesskeyview.exe /stext wireless.txt
) ELSE (
wirelesskeyview64.exe /stext wireless.txt
)
copy /a %text% + wireless.txt > NUL 2>&1
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Email Info...
echo Email Info >> %text% 2> nul
mailpv.exe /stext email.txt 2> nul
copy /a %text% + email.txt > NUL 2>&1
::echo Below data decrypt all but password using hex to ascii decryptor >> %text%
::reg query HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Profiles\Outlook\ /s >> %text%
::type email.reg | find "POP3 User"
::for /f "tokens=3 delims==" %%a in ('type email.reg | find "POP3 User"') do set p=%%c
::echo %%c
::set /a dec=0x%hex%
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo PST Passwords...
echo PST Passwords >> %text% 2> nul
PSTPassword.exe /stext pstpwd.txt 2> nul
copy /a %text% + pstpwd.txt > NUL 2>&1
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul


echo DUN/VPN Info...
echo DUN/VPN Info >> %text% 2> nul
dialupass.exe /stext vpn.txt 2> nul
copy /a %text% + vpn.txt > NUL 2>&1
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo WebsitePW...
echo WebsitePW >> %text% 2> nul
WebBrowserPassView.exe /stext webpwd.txt 2> nul
copy /a %text% + webpwd.txt > NUL 2>&1
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Product Keys...
echo Product Keys >> %text% 2> nul
keyfinder /save /close /file keys.txt 2> nul
copy /a %text% + keys.txt > NUL 2>&1
produkey.exe /stext produkey.txt 2> nul
copy /a %text% + produkey.txt > NUL 2>&1
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Default Printer...
echo Default Printer >> %text% 2> nul
reg query "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v Device >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul
REM Debug Pause
pause
cls
color 0C
::[1;31m
echo ..............................................
echo Printer Detection (This part may take a while)...
echo ..............................................
::[1;37m
echo Printers >> %text% 2> nul
cscript //H:CScript //S
prnmngr -l -s %computername% >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Printer Ports...
echo Printer Ports >> %text% 2> nul
prnport -l >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo VNC >> %text% 2> nul
VNCPassView.exe /stext vnc.txt 2> nul
copy /a %text% + vnc.txt > NUL 2>&1
vncpwdump -c >> %text% 2> nul
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

echo Installed Software...
echo Installed Software >> %text% 2> nul
cscript InstalledSoftware.vbs 2> nul
copy /a %text% + software.txt > NUL 2>&1
echo .............................................. >> %text% 2> nul
echo .............................................. >> %text% 2> nul

::Quickbooks Check
if exist "%localappdata%\Intuit\Quickbooks" goto qbcheck
goto skipqbcheck
:qbcheck
echo Possible QuickBooks Detected, sending prompt...
echo Possible QuickBooks Detected, sending prompt >> %text% 2> nul
::Input Source
ECHO Wscript.Echo Inputbox("Possible QuickBooks Detected, open qb and press F2 to obtain the license and product key, enter both here:")>%TEMP%\~input.vbs
FOR /f "delims=/" %%G IN ('cscript //nologo %TEMP%\~input.vbs') DO set qbkey=%%G
DEL %TEMP%\~input.vbs
echo QuickBooks Details: %qbkey% >> %text% 2> nul
:skipqbcheck


::AutoCAD Check
if exist "%localappdata%\AutoCAD" goto accheck
goto skipaccheck
:accheck
echo Possible AutoCAD Detected, sending prompt...
echo Possible AutoCAD Detected, sending prompt >> %text% 2> nul
::Input Source
ECHO Wscript.Echo Inputbox("Possible AutoCAD Detected, open AutoCAD and goto About AutoCAD and enter serial number:")>%TEMP%\~input.vbs
FOR /f "delims=/" %%G IN ('cscript //nologo %TEMP%\~input.vbs') DO set ackey=%%G
DEL %TEMP%\~input.vbs
echo AutoCAD Details: %ackey% >> %text% 2> nul
:skipaccheck

::Outlook Check
if exist "%localappdata%\Intuit\Quickbooks" goto olcheck
goto skipolcheck
:accheck
echo Possible Outlook Detected, sending prompt...
echo Possible Outlook Detected, sending prompt >> %text% 2> nul
::Input Source
ECHO Wscript.Echo Inputbox("Possible Outlook Detected, open Outlook and confirm the pst locations:")>%TEMP%\~input.vbs
FOR /f "delims=/" %%G IN ('cscript //nologo %TEMP%\~input.vbs') DO set olkey=%%G
DEL %TEMP%\~input.vbs
echo Outlook Details: %ackey% >> %text% 2> nul
:skipolcheck


::cleanup
Echo Performing Cleanup...
del keys.txt email.txt wireless.txt iepwd.txt printers.txt software.txt downtest.txt produkey.txt pstpwd.txt 2> nul
notepad %text% 2> nul