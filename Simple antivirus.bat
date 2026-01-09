@echo off
set "version=0.2"
title Simple Antivirus v%version%
chcp 65001 >nul
echo [System] Checking updates...

curl -f -s -L "https://raw.githubusercontent.com/Koti9013/Simple-antivirus/refs/heads/main/version.txt" -o "%temp%\ver.txt"

if %errorlevel% neq 0 (
    echo [!] Server isn't connected. Working offline.
    timeout /t 2 >nul
    goto scan
)

set /p remote_ver=<%temp%\ver.txt
set "remote_ver=%remote_ver: =%"

if "%remote_ver%"=="%version%" (
    echo [OK] you have an actual version.
    timeout /t 2 >nul
    goto scan
)

echo [!] New version foung: %remote_ver%
echo [!] Uploading the new version...
curl -f -s -L "https://raw.githubusercontent.com/Koti9013/Simple-antivirus/refs/heads/main/Simple%20antivirus.bat" -o "%~f0"
echo [OK] Antivirus updated. Restart it, please!
pause
exit

:scan
cls
echo ==========================================
echo       Simple Antivirus v%version%
echo ==========================================
echo [!] WARNING: need administrator rights to work property.
echo.

chcp 65001 >nul
echo ==========================================
echo        STARTING SIMPLE ANTIVIRUS...
echo ==========================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $tasks = Get-ScheduledTask | Where-Object {$_.State -ne 'Disabled'}; $found = $false; foreach ($task in $tasks) { $action = $task.Actions.Execute; if (!$action) { $action = $task.Actions.Arguments }; if ($action -match 'AppData|Temp' -and $action -notmatch 'OneDrive|Discord|Steam') { $found = $true; Write-Host '[!] INTRUDER FOUND!' -ForegroundColor Red; Write-Host 'Task: ' $task.TaskName -ForegroundColor Yellow; Write-Host 'Path: ' $action -ForegroundColor White; $choice = Read-Host 'Disable this task? (y/n)'; if ($choice -eq 'y') { Disable-ScheduledTask -TaskName $task.TaskName; Write-Host 'Successfully disabled!' -ForegroundColor Cyan } Write-Host '-----------------------------------' } }; if (-not $found) { Write-Host 'No intruders found. System processes were ignored.' -ForegroundColor Green }; Write-Host ''; Write-Host 'Scan complete. Press Enter to exit...'; Read-Host"
pause
goto menu

