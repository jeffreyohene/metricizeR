@echo off

:: Define paths
set R_SCRIPT_PATH=C:\metricize\scripts\R\fetch_data.R
set OUTPUT_DIR=C:\metricize\_data
set LOG_DIR=C:\metricize\logs

:: Check if Rscript command is available
where Rscript >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Unable to execute script or script is unavailable. Please ensure R is installed and check scripts/R if fetch_data is present.
    exit /b 1
)

:: Create output and log directories if they don't exist
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

:: Run the R script and capture output and errors in the logs folder
echo Running R script...
Rscript "%R_SCRIPT_PATH%" > "%LOG_DIR%\output.log" 2>&1

:: Notify completion
if %ERRORLEVEL% equ 0 (
    echo R script completed successfully. Log saved in %LOG_DIR%\output.log
) else (
    echo R script encountered an error. Check %LOG_DIR%\output.log for details.
)
