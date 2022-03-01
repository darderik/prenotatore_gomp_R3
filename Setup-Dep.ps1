
Install-Module Selenium -AllowPreRelease -Scope currentuser

cd $HOME\Documents\PowerShell\Modules\Selenium\4.0.0

.\Selenium-Binary-Updater.ps1 -Browser Chrome

Set-Location $PSScriptRoot

$TextContent = "{
    ""username"": ""nom.cognome"",
    ""password"": """",
    ""corso"" : ""Ingegneria elettronica l-8"",
    ""lezioni"": [
        15,
        14
    ]
}"

New-Item -Path .\config.json -Force 
Set-Content .\config.json $TextContent
