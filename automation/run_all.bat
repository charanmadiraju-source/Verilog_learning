@echo off
REM =============================================================================
REM  run_all.bat  –  Windows launcher for the Verilog Lab Report automation
REM =============================================================================
REM
REM  What this does
REM  --------------
REM  1. Validates that Vivado is on the PATH  (or uses VIVADO_PATH if set).
REM  2. Runs vivado_run_all.tcl in batch mode:
REM       - Creates a temporary Vivado project per experiment
REM       - Runs behavioural simulation  → exports waveform PNG
REM       - Runs RTL elaboration          → exports schematic PNG
REM       - Writes   output\summary.json
REM  3. Runs generate_pdf_with_images.py with Python to build the final PDF.
REM
REM  Prerequisites
REM  -------------
REM   - Xilinx Vivado 2022.x or later installed
REM   - Python 3.9+ on PATH
REM   - fpdf2 and Pillow installed:   pip install fpdf2 Pillow
REM
REM  Customise the following three variables if needed, then double-click
REM  this file or run it from a Command Prompt.
REM
REM  Variables
REM  ---------
REM    VIVADO_PATH   Full path to vivado.bat  (only needed when Vivado is NOT
REM                  already on your PATH)
REM    LEVEL_START   First level to process  (default 1)
REM    LEVEL_END     Last  level to process  (default 12)
REM    OUTPUT_DIR    Where images & PDF are written  (default: output\ next to
REM                  this script)
REM =============================================================================

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM ----------------------------------------------------------------------------
REM  *** CUSTOMISE THESE IF NEEDED ***
REM ----------------------------------------------------------------------------

REM  Leave blank to find vivado on PATH automatically, or set a full path, e.g.:
REM    SET VIVADO_PATH=C:\Xilinx\Vivado\2022.2\bin\vivado.bat
SET VIVADO_PATH=

REM  Levels to process  (set both to the same number to run only one level)
SET LEVEL_START=1
SET LEVEL_END=12

REM  Output directory (relative to this script's folder)
REM  Note: run_level.bat may override OUTPUT_DIR before calling this script.
IF NOT DEFINED OUTPUT_DIR SET OUTPUT_DIR=output

REM ----------------------------------------------------------------------------
REM  Derived paths  –  do not change below this line unless you know what you
REM  are doing.
REM ----------------------------------------------------------------------------

SET SCRIPT_DIR=%~dp0
REM Remove trailing backslash
IF "%SCRIPT_DIR:~-1%"=="\" SET SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

SET REPO_ROOT=%SCRIPT_DIR%\..
REM If OUTPUT_DIR is already an absolute path use it directly
IF "%OUTPUT_DIR:~1,1%"==":" (
    SET OUTPUT_DIR_FULL=%OUTPUT_DIR%
) ELSE (
    SET OUTPUT_DIR_FULL=%SCRIPT_DIR%\%OUTPUT_DIR%
)

SET TCL_SCRIPT=%SCRIPT_DIR%\vivado_run_all.tcl
SET PY_SCRIPT=%SCRIPT_DIR%\generate_pdf_with_images.py
SET PDF_OUT=%OUTPUT_DIR_FULL%\Verilog_Lab_Report_With_Images.pdf

echo.
echo ========================================================
echo   Verilog Lab Automation – Windows Batch Runner
echo ========================================================
echo   Repo root   : %REPO_ROOT%
echo   Script dir  : %SCRIPT_DIR%
echo   Output dir  : %OUTPUT_DIR_FULL%
echo   Levels      : %LEVEL_START% to %LEVEL_END%
echo ========================================================
echo.

REM ----------------------------------------------------------------------------
REM  Step 0: Create output directory
REM ----------------------------------------------------------------------------
IF NOT EXIST "%OUTPUT_DIR_FULL%" (
    echo [Step 0] Creating output directory: %OUTPUT_DIR_FULL%
    mkdir "%OUTPUT_DIR_FULL%"
)

REM ----------------------------------------------------------------------------
REM  Step 1: Locate vivado executable
REM ----------------------------------------------------------------------------
IF "%VIVADO_PATH%"=="" (
    WHERE vivado >NUL 2>&1
    IF ERRORLEVEL 1 (
        echo.
        echo ERROR: vivado not found on PATH.
        echo        Either:
        echo          a) Add Vivado's bin directory to your PATH, or
        echo          b) Set the VIVADO_PATH variable at the top of this file.
        echo.
        echo        Example PATH addition:
        echo          C:\Xilinx\Vivado\2022.2\bin
        echo.
        GOTO :error
    )
    SET VIVADO_EXE=vivado
) ELSE (
    IF NOT EXIST "%VIVADO_PATH%" (
        echo ERROR: VIVADO_PATH not found: %VIVADO_PATH%
        GOTO :error
    )
    SET VIVADO_EXE="%VIVADO_PATH%"
)
echo [Step 1] Using Vivado: !VIVADO_EXE!

REM ----------------------------------------------------------------------------
REM  Step 2: Locate Python
REM ----------------------------------------------------------------------------
WHERE python >NUL 2>&1
IF ERRORLEVEL 1 (
    WHERE python3 >NUL 2>&1
    IF ERRORLEVEL 1 (
        echo ERROR: python / python3 not found on PATH.
        GOTO :error
    )
    SET PYTHON_EXE=python3
) ELSE (
    SET PYTHON_EXE=python
)
echo [Step 2] Using Python: !PYTHON_EXE!

REM ----------------------------------------------------------------------------
REM  Step 3: Check Python dependencies
REM ----------------------------------------------------------------------------
echo [Step 3] Checking Python dependencies (fpdf2, Pillow)...
!PYTHON_EXE! -c "import fpdf; import PIL" >NUL 2>&1
IF ERRORLEVEL 1 (
    echo          Installing missing packages...
    !PYTHON_EXE! -m pip install --quiet fpdf2 Pillow
    IF ERRORLEVEL 1 (
        echo ERROR: Could not install fpdf2 / Pillow.
        echo        Run manually:  pip install fpdf2 Pillow
        GOTO :error
    )
)
echo          OK.

REM ----------------------------------------------------------------------------
REM  Step 4: Run Vivado in batch mode
REM ----------------------------------------------------------------------------
echo.
echo [Step 4] Running Vivado batch simulation + schematic export...
echo          This may take several minutes for levels %LEVEL_START% to %LEVEL_END%.
echo          Log: %OUTPUT_DIR_FULL%\vivado_run_all.log
echo.

!VIVADO_EXE! -mode batch -source "%TCL_SCRIPT%" ^
    -tclargs "%REPO_ROOT%" "%OUTPUT_DIR_FULL%" %LEVEL_START% %LEVEL_END% ^
    -log "%OUTPUT_DIR_FULL%\vivado.log" ^
    -journal "%OUTPUT_DIR_FULL%\vivado.jou"

IF ERRORLEVEL 1 (
    echo.
    echo WARNING: Vivado exited with errors.  Some images may be missing.
    echo          Continuing with PDF generation using whatever was produced.
)

REM ----------------------------------------------------------------------------
REM  Step 5: Generate PDF with images
REM ----------------------------------------------------------------------------
echo.
echo [Step 5] Generating PDF report...

!PYTHON_EXE! "%PY_SCRIPT%" "%OUTPUT_DIR_FULL%" "%PDF_OUT%"

IF ERRORLEVEL 1 (
    echo.
    echo ERROR: PDF generation failed.
    GOTO :error
)

echo.
echo ========================================================
echo   DONE!
echo   PDF report: %PDF_OUT%
echo ========================================================
echo.

REM Open the PDF automatically
IF EXIST "%PDF_OUT%" (
    echo Opening PDF...
    start "" "%PDF_OUT%"
)
GOTO :eof

:error
echo.
echo Script finished with errors.  See log files in: %OUTPUT_DIR_FULL%
exit /B 1
