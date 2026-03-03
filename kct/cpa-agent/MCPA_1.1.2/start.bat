@echo off
SETLOCAL EnableDelayedExpansion

REM ==================================================
SET "JAVA_HOME=..\jdks\18\windows"
SET "JAVA=%JAVA_HOME%\bin\java"
SET "JPS=%JAVA_HOME%\bin\jps"
SET "LOCK_FILE=MCPA.lock"
SET "APP_NAME=MCPA.jar"
SET "CONFIG_NAME=../../CPA_SMS_local.conf"
REM ==================================================
SET "APP_STATUS="
SET "PID="
SET "ARG=%1"

REM check JDK
IF NOT EXIST "%JAVA_HOME%" (
    IF EXIST "..\jdks\jdk18-windows.zip" (
        echo tar xfz ..\jdks\jdk18-windows.zip -C ..\jdks
        tar xfz ..\jdks\jdk18-windows.zip -C ..\jdks
    ) else (
        echo not found JAVA_HOME and jdk18-windows.zip file
        exit /b
    )
)

:help
if "%ARG%"=="" goto :print_help
if /I "%ARG%"=="help" goto :print_help
IF /I "%ARG%"=="start" goto :start_app
IF /I "%ARG%"=="restart" goto :restart_app
IF /I "%ARG%"=="stop" goto :stop_app
IF /I "%ARG%"=="status" goto :status_app

:: Function to display help
:print_help
    echo usage: %~nx0 help
    echo        %~nx0 (start^|stop^|restart^|status)
    echo.
    echo         help       - this screen
    echo         start      - start SMS-MO service
    echo         stop       - stop  SMS-MO service
    echo         restart    - restart or start SMS-MO service
    echo         status     - show the status of SMS-MO service
    goto :EOF

:: Function to check if the app is running
:is_running
    SET "PID="
    FOR /F "tokens=1" %%A IN ('cmd /C "%JPS%" -l ^| findstr /i "%APP_NAME%"') DO (
        SET "PID=%%A"
    )

    IF DEFINED PID (
        SET "APP_STATUS=%APP_NAME% already running. ^(pid: %PID%^)"
        EXIT /B 1
    ) ELSE (
        SET "APP_STATUS=%APP_NAME% is not running"
        EXIT /B 0
    )
    goto :EOF

:: Function to start the app
:start_app
    CALL :is_running
    IF %ERRORLEVEL% EQU 1 (
        echo %~nx0 %ARG% : %APP_STATUS%
        goto :EOF
    )

    IF EXIST "%LOCK_FILE%" (
        echo delete lock file: %LOCK_FILE%
        del %LOCK_FILE%
    )

    START "" "%JAVA%" ^
        -Xms32m ^
        -Xmx64m -XX:+UseG1GC ^
        -XX:MetaspaceSize=32M ^
        -XX:MaxMetaspaceSize=64M ^
        -Djdk.nio.maxCachedBufferSize=10488760 ^
        -jar "%APP_NAME%" "%CONFIG_NAME%"

    echo %~nx0 Wait 10 seconds to make sure it's working well
    TIMEOUT /T 10 /NOBREAK >NUL

    CALL :is_running
    IF %ERRORLEVEL% EQU 1 (
        echo %~nx0 %ARG%: %APP_NAME% started
    ) ELSE (
        echo %~nx0 %ARG%: %APP_NAME% could not be started
    )
    EXIT /B %ERRORLEVEL%

    goto :EOF

:: Function to stop the app
:stop_app
    CALL :is_running
    IF %ERRORLEVEL% EQU 0 (
        echo %~nx0 %ARG% : %APP_STATUS%
        goto :EOF
    )

    TASKKILL /PID %PID% /F >NUL 2>&1

    TIMEOUT /T 3 /NOBREAK >NUL

    CALL :is_running
    IF %ERRORLEVEL% EQU 0 (
        echo %~nx0 %ARG%: %APP_NAME% stopped
    ) ELSE (
        echo %~nx0 %ARG%: %APP_NAME% could not be stopped
    )
    goto :EOF

:: Function to show status
:status_app
    CALL :is_running
    echo %APP_STATUS%
    goto :EOF

:: Function to restart the app
:restart_app
    CALL :stop_app
    IF %ERRORLEVEL% EQU 0 (
        CALL :start_app
    )
    goto :EOF

ENDLOCAL