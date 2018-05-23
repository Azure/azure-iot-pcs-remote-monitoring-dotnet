@ECHO off & setlocal enableextensions enabledelayedexpansion

IF "%MESH_WEB_PORT%" == "" (
    echo Error: the MESH_WEB_PORT environment variable is not defined.
    exit /B 1
)