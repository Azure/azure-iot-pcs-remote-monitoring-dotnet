@ECHO off
setlocal

:: strlen("\scripts\git\") => 13
SET APP_HOME=%~dp0
SET APP_HOME=%APP_HOME:~0,-13%

cd %APP_HOME%

echo Adding pre-commit hook...

mkdir .git\hooks\ 2> nul
del /F .git\hooks\pre-commit 2> nul
copy scripts\git\pre-commit-runner.sh .git\hooks\pre-commit
IF NOT ERRORLEVEL 0 GOTO FAIL

echo Done.

:: - - - - - - - - - - - - - -
goto :END

:FAIL
echo Command failed
endlocal
exit /B 1

:END
endlocal