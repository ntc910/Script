@echo off
if defined JAVA_HOME (
    echo JAVA_HOME is set to: %JAVA_HOME%
) else (
    echo JAVA_HOME is not set. Please install zulu and add it to environment. Exiting.
    exit /b 1
)

set KEYTOOL=%JAVA_HOME%\bin\keytool
echo KEYTOOL=%KEYTOOL%

set KEYSTORE=%JAVA_HOME%\lib\security\cacerts
echo KEYSTORE=%KEYSTORE%

set ALIAS=samsung
set PASSWORD=changeit
set CERT_FILE=./SAPL_2022.crt

:: Temporary file for capturing output
set OUTPUT_FILE=temp_keytool_output.txt

:: Run the keytool command and capture output (stdout and stderr)
"%KEYTOOL%" -import -alias %ALIAS% -file "%CERT_FILE%" -keystore "%KEYSTORE%" -storepass %PASSWORD% -noprompt > %OUTPUT_FILE% 2>&1

:: Check for success conditions
set SUCCESS=0

:: Check if certificate was added
findstr /C:"Certificate was added to keystore" %OUTPUT_FILE% >nul 2>&1
if %ERRORLEVEL% equ 0 set SUCCESS=1

:: Check if alias already exists (treat as success)
findstr /C:"alias <samsung> already exists" %OUTPUT_FILE% >nul 2>&1
if %ERRORLEVEL% equ 0 set SUCCESS=1

:: If success, print success message; otherwise, show failure and output
if %SUCCESS% equ 1 (
    echo Certificate imported successfully.
) else (
    echo Failed to import certificate.
    echo Keytool output:
    type %OUTPUT_FILE%
    del %OUTPUT_FILE%
    exit /b 1
)

:: Clean up temporary file
del %OUTPUT_FILE%

pause
endlocal
exit /b 0
