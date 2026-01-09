@echo off
set "version=0.1"
title Simple Antivirus v%version%
chcp 65001 >nul
echo [Система] Проверка обновлений...

curl -f -s -L "https://raw.githubusercontent.com/Koti9013/Simple-antivirus/refs/heads/main/version.txt" -o "%temp%\ver.txt"

if %errorlevel% neq 0 (
    echo [!] Сервер обновлений недоступен. Работа в офлайн-режиме.
    timeout /t 2 >nul
    goto scan
)

set /p remote_ver=<%temp%\ver.txt
set "remote_ver=%remote_ver: =%"

if "%remote_ver%"=="%version%" (
    echo [OK] У вас актуальная версия.
    timeout /t 2 >nul
    goto scan
)

echo [!] Найдена новая версия: %remote_ver%
echo [!] Загрузка обновления...
curl -f -s -L "https://raw.githubusercontent.com/Koti9013/Simple-antivirus/refs/heads/main/Simple%20antivirus.bat" -o "%~f0"
echo [OK] Обновление завершено. Перезапустите программу!
pause
exit

:scan
cls
echo ==========================================
echo       Simple Antivirus v%version%
echo ==========================================
echo [!] WARNING: need administrator rights to work normally.
echo.

chcp 65001 >nul
echo ==========================================
echo        STARTING SIMPLE ANTIVIRUS...
echo ==========================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $tasks = Get-ScheduledTask | Where-Object {$_.State -ne 'Disabled'}; $found = $false; foreach ($task in $tasks) { $action = $task.Actions.Execute; if (!$action) { $action = $task.Actions.Arguments }; if ($action -match 'AppData|Temp' -and $action -notmatch 'OneDrive|Discord|Steam') { $found = $true; Write-Host '[!] INTRUDER FOUND!' -ForegroundColor Red; Write-Host 'Task: ' $task.TaskName -ForegroundColor Yellow; Write-Host 'Path: ' $action -ForegroundColor White; $choice = Read-Host 'Disable this task? (y/n)'; if ($choice -eq 'y') { Disable-ScheduledTask -TaskName $task.TaskName; Write-Host 'Successfully disabled!' -ForegroundColor Cyan } Write-Host '-----------------------------------' } }; if (-not $found) { Write-Host 'No intruders found. System processes were ignored.' -ForegroundColor Green }; Write-Host ''; Write-Host 'Scan complete. Press Enter to exit...'; Read-Host"
pause
goto menu

