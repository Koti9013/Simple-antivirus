:run_scanner
:: Встановлюємо кодування UTF-8 для підтримки кирилиці
chcp 65001 >nul
echo ==========================================
echo       ЗАПУСК СКАНЕРА BATHUB...
echo ==========================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "$tasks = Get-ScheduledTask | Where-Object {$_.State -ne 'Disabled'}; $found = $false; foreach ($task in $tasks) { $action = $task.Actions.Execute; if (!$action) { $action = $task.Actions.Arguments }; if ($action -match 'AppData|Temp' -and $action -notmatch 'OneDrive') { $found = $true; Write-Host '[!] ЗНАЙДЕНО ПІДОЗРІЛИЙ ОБЄКТ!' -ForegroundColor Red; Write-Host 'Задача: ' $task.TaskName -ForegroundColor Yellow; Write-Host 'Шлях:   ' $action -ForegroundColor White; $choice = Read-Host 'Вимкнути цю задачу? (y/n)'; if ($choice -eq 'y') { Disable-ScheduledTask -TaskName $task.TaskName; Write-Host 'Вимкнено успішно!' -ForegroundColor Cyan } Write-Host '-----------------------------------' } }; if (-not $found) { Write-Host 'Самозванців не виявлено (системні процеси проігноровано).' -ForegroundColor Green }; Write-Host 'Скан завершено. Натисніть Enter...'; Read-Host"
pause
goto menu