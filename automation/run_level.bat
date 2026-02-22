@echo off
REM =============================================================================
REM  run_level.bat  –  Run a single level (or range of levels)
REM =============================================================================
REM
REM  Usage:
REM    run_level.bat <level_number>
REM    run_level.bat <level_start> <level_end>
REM
REM  Examples:
REM    run_level.bat 1          run Level 1 only
REM    run_level.bat 1 3        run Levels 1, 2 and 3
REM    run_level.bat 6 6        run Level 6 only
REM
REM  The output is written to:
REM    <script_dir>\output_level_<N>\Verilog_Lab_Report_Level_<N>.pdf
REM =============================================================================

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

IF "%~1"=="" (
    echo Usage: run_level.bat ^<level_number^> [level_end]
    echo.
    echo Examples:
    echo   run_level.bat 1
    echo   run_level.bat 1 3
    exit /B 1
)

SET LEVEL_START=%~1
SET LEVEL_END=%~1
IF NOT "%~2"=="" SET LEVEL_END=%~2

SET SCRIPT_DIR=%~dp0
IF "%SCRIPT_DIR:~-1%"=="\" SET SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

IF "%LEVEL_START%"=="%LEVEL_END%" (
    SET OUT_LABEL=level_%LEVEL_START%
) ELSE (
    SET OUT_LABEL=levels_%LEVEL_START%_to_%LEVEL_END%
)
SET OUTPUT_DIR=%SCRIPT_DIR%\output_%OUT_LABEL%
SET PDF_OUT=%OUTPUT_DIR%\Verilog_Lab_Report_%OUT_LABEL%.pdf

echo Running automation for level(s) %LEVEL_START% to %LEVEL_END%...
echo Output: %OUTPUT_DIR%
echo.

REM Delegate to run_all.bat  (it reads LEVEL_START, LEVEL_END, OUTPUT_DIR
REM from the environment because SETLOCAL is active in both scripts)
CALL "%SCRIPT_DIR%\run_all.bat"
