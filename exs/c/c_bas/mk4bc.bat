@echo off
set BCPATH=c:\prg\cmp\bc

if not exist %BCPATH%\nul goto msg

bcc.exe -c -X -d -mm -f2 -G -O2l -I%BCPATH%\include;..\..\..\inc %1.c

if [%DEBUG%]==[TRUE] goto deb
set UGLLIB=..\..\..\lib\uglc.lib

:dolink
rem tlink /Tde /3 /L%BCPATH%\lib c0fm+%1,%1.exe,nul,cm+fp87+mathm+%UGLLIB%
goto end

:deb
set UGLLIB=..\..\..\lib\uglcd.lib
goto dolink

:msg
echo.The %BCPATH% path doesn't exist, please edit this batch file 
echo.pointing BCPATH env var to the correct path where BC is installed

:end
rem if exist %1.obj del %1.obj
set UGLLIB=
