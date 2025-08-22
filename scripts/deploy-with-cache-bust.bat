@echo off
REM Azure Static Web Apps Deployment Script with Cache Busting
REM Run this script after deploying to Azure Static Web Apps

echo Starting cache invalidation process...

REM Get the current timestamp for versioning
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,14%

echo Build timestamp: %TIMESTAMP%

REM Update index.html with new timestamp (requires PowerShell)
powershell -Command "(Get-Content wwwroot\index.html) -replace 'Date\.now\(\)', '%TIMESTAMP%' | Set-Content wwwroot\index.html"

echo Updated index.html with timestamp: %TIMESTAMP%

echo Cache invalidation process completed!
echo.
echo Additional manual steps you can take:
echo 1. Clear browser cache (Ctrl+Shift+R)
echo 2. Use incognito/private browsing mode to test
echo 3. Check Azure Static Web Apps logs for deployment status
echo 4. Verify the deployment completed successfully in Azure portal

pause