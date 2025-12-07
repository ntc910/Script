@echo off
for /f "tokens=1" %%d in ('adb devices ^| findstr /r /c:"^[a-zA-Z0-9]"') do (
    adb -s %%d shell "date 07171010.00 ; am broadcast -a android.intent.action.TIME_SET"
)
pause

set /p DUMMY=Press ENTER to exit...