
Install-Module Selenium -AllowPreRelease -Scope currentuser

cd $HOME\Documents\PowerShell\Modules\Selenium\4.0.0

.\Selenium-Binary-Updater.ps1 -Browser Chrome

Set-Location $PSScriptRoot