@echo off

set LOG_DIR=C:\metricize\logs
set ARCHIVE_DIR=C:\metricize\_logs\log_archives
set ARCHIVE_OLDER_THAN_DAYS=7
set DELETE_OLDER_THAN_DAYS=21
set DATE_FORMAT=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%  :: Format date as YYYYMMDD

:: create the archive directory if it doesn't exist
if not exist "%ARCHIVE_DIR%" (
    mkdir "%ARCHIVE_DIR%"
)

echo Archiving log files older than %ARCHIVE_OLDER_THAN_DAYS% days...
forfiles /p "%LOG_DIR%" /s /m *.log /d -%ARCHIVE_OLDER_THAN_DAYS% /c "cmd /c powershell -Command Compress-Archive -Path @path -DestinationPath \"%ARCHIVE_DIR%\log_archive_%DATE_FORMAT%.zip\""

:: Delete the original log files after archiving
forfiles /p "%LOG_DIR%" /s /m *.log /d -%ARCHIVE_OLDER_THAN_DAYS% /c "cmd /c del @path"

:: Delete archived files older than 21 days
echo Deleting archived files older than %DELETE_OLDER_THAN_DAYS% days...
forfiles /p "%ARCHIVE_DIR%" /s /m *.zip /d -%DELETE_OLDER_THAN_DAYS% /c "cmd /c del @path"

echo Cleanup completed.