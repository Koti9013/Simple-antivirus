@echo off
:: Устанавливаем версию (строго без пробелов)
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

:: Читаем версию из файла и убираем пробелы
set /p remote_ver=<%temp%\ver.txt
set "remote_ver=%remote_ver: =%"

:: Если версии совпадают - сразу идем к сканированию
if "%remote_ver%"=="%version%" (
    echo [OK] У вас актуальная версия.
    timeout /t 1 >nul
    goto scan
)

:: Если версии разные - скачиваем обновление
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
echo [!] Запуск сканирования "самозванцев"...
echo [!] ВНИМАНИЕ: Требуются права администратора.
echo.

:: Основная логика сканера (игнорирует OneDrive, Steam, Discord)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$tasks = Get-ScheduledTask | Where-Object {$_.State -ne 'Disabled'}; $found = $false; foreach ($task in $tasks) { $action = $task.Actions.Execute; if (!$action) { $action = $task.Actions.Arguments }; if ($action -match 'AppData|Temp' -and $action -notmatch 'OneDrive|Discord|Steam') { $found = $true; Write-Host '[!] НАЙДЕН ПОДОЗРИТЕЛЬНЫЙ ОБЪЕКТ!' -ForegroundColor Red; Write-Host 'Задача: ' $task.TaskName -ForegroundColor Yellow; Write-Host 'Путь:   ' $action -ForegroundColor White; $choice = Read-Host 'Отключить эту задачу? (y/n)'; if ($choice -eq 'y') { Disable-ScheduledTask -TaskName $task.TaskName; Write-Host 'Успешно отключено!' -ForegroundColor Cyan } Write-Host '-----------------------------------' } }; if (-not $found) { Write-Host 'Самозванцев не обнаружено. Ваша система в безопасности.' -ForegroundColor Green }; Write-Host ''; Write-Host 'Сканирование завершено. Нажмите Enter для выхода...'; Read-Host"

exit
=======
:run_scanner
:: Встановлюємо кодування UTF-8 для підтримки кирилиці
chcp 65001 >nul
echo ==========================================
echo       ЗАПУСК СКАНЕРА BATHUB...
echo ==========================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "$tasks = Get-ScheduledTask | Where-Object {$_.State -ne 'Disabled'}; $found = $false; foreach ($task in $tasks) { $action = $task.Actions.Execute; if (!$action) { $action = $task.Actions.Arguments }; if ($action -match 'AppData|Temp' -and $action -notmatch 'OneDrive') { $found = $true; Write-Host '[!] ЗНАЙДЕНО ПІДОЗРІЛИЙ ОБЄКТ!' -ForegroundColor Red; Write-Host 'Задача: ' $task.TaskName -ForegroundColor Yellow; Write-Host 'Шлях:   ' $action -ForegroundColor White; $choice = Read-Host 'Вимкнути цю задачу? (y/n)'; if ($choice -eq 'y') { Disable-ScheduledTask -TaskName $task.TaskName; Write-Host 'Вимкнено успішно!' -ForegroundColor Cyan } Write-Host '-----------------------------------' } }; if (-not $found) { Write-Host 'Самозванців не виявлено (системні процеси проігноровано).' -ForegroundColor Green }; Write-Host 'Скан завершено. Натисніть Enter...'; Read-Host"
pause
goto menu

