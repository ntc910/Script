@echo off
:: #############################################
:: # Title     : Put the Computer to Sleep     #
:: # Created By: Paul Black                    #
:: # Created On: 26-Dec-2021                   #
:: # Filename  : Put_The_Computer_To_Sleep.bat #
:: #############################################
set "Title=Put the Computer to Sleep" & set "Author=Paul Black"
title %Title% - Written by %Author%. & mode con: cols=80 lines=34

setlocal EnableDelayedExpansion
set "Params=%*"
cd /d "%~dp0" && ( if exist "%Temp%\getadmin.vbs" del "%Temp%\getadmin.vbs") && fsutil dirty query %SystemDrive% 1>nul 2>nul || ( echo set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %Params%", "", "runas", 1 >> "%Temp%\getadmin.vbs" && "%Temp%\getadmin.vbs" && Exit /b)
%WinDir%\system32\reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || ( echo. & echo  ERROR: This Batch file MUST be run in an ELEVATED cmd prompt [ Administrator ] & echo. & echo         Right-click the Batch file and click ^<Run as Administrator^>. & echo. & echo ^>Press ANY key to EXIT . . . & pause >nul & Exit )

set var_1=900
set var_2=1800
set var_3=2700
set var_4=3600
set var_5=4500
set var_6=5400
set var_7=6300
set var_8=7200

:Options

echo. & echo  ==============================================================================
        echo  %Title%:-
        echo  ==============================================================================
echo. & echo  Options:
echo. & echo  [0] EXIT this Program.
echo. & echo  [1]  15 minutes.
        echo  [2]  30 minutes.
        echo  [3]  45 minutes.
        echo  [4]  60 minutes.
echo. & echo  [5]  75 minutes - 1 hour  15 minutes.
        echo  [6]  90 minutes - 1 hour  30 minutes.
        echo  [7] 105 minutes - 1 hour  45 minutes.
        echo  [8] 120 minutes - 2 hours -- minutes.
echo. & echo  [9] User Defined.
echo. & echo  ==============================================================================& echo.

CHOICE /N /C 0123456789 /M ">Enter an Option number: "

if %ErrorLevel%==10                  echo. & goto :User_Defined
if %ErrorLevel%==9 set var=%var_8% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==8 set var=%var_7% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==7 set var=%var_6% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==6 set var=%var_5% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==5 set var=%var_4% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==4 set var=%var_3% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==3 set var=%var_2% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==2 set var=%var_1% & echo. & goto :Go_2_Sleep
if %ErrorLevel%==1 Exit

:Go_2_Sleep

echo  The Computer is getting ready to go to Sleep . . . & echo.
      timeout %var% /nobreak >nul
      %SystemRoot%\System32\rundll32.exe powrprof.dll, SetSuspendState 0,1,0
echo  The Computer has just Woken up. & echo.
echo ^>Press ANY key to EXIT . . . & pause >nul & Exit

:User_Defined

set "time="
set /p "time=>Enter the Time in Minutes and press <Enter>: " & echo.
set /a  time=%time% * 60

if %time% GEQ 1 (
  echo  The computer is getting ready to go to Sleep . . .
        timeout %time% /nobreak >nul
        %SystemRoot%\System32\rundll32.exe powrprof.dll, SetSuspendState 0,1,0
  echo  The Computer has just Woken up. & echo.
  echo ^>Press ANY key to EXIT . . . & pause >nul & Exit
) else (
  echo  ------------------------------------------------------------------------------
  echo  ERROR: You MUST enter the number of MINUTES.
  echo  ------------------------------------------------------------------------------& echo.
  echo ^>Press ANY key to return to the Options . . . & pause >nul & cls & goto :Options