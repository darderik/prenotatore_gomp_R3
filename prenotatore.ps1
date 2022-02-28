Import-Module Selenium
Set-Location $PSScriptRoot
$Options = New-SeDriverOptions -Browser Chrome
$Options.AddArgument("headless")
$browser = Start-SeDriver -Browser Chrome -StartURL https://gomp.uniroma3.it/ -Options $Options
$userBox = Get-SeElement -By CssSelector -Value "#userName"
$pwdBox = Get-SeElement -By CssSelector -Value "#password"
$submitBtn = Get-SeElement -By CssSelector -Value "#loginButton"

$config = Get-Content .\config.json | ConvertFrom-Json
$uname = $config.username
$pwd = $config.password
$corsi = $config.corsi

Invoke-SeKeys -Element $userBox $uname
Invoke-SeKeys -Element $pwdBox $pwd

Invoke-SeClick -Element $submitBtn -Sleep 2

$prenotaBtn = Get-SeElement -By CssSelector -Value "#homeIconList > li:nth-child(9)"
if (-not $prenotaBtn) {
    Write-Host "Credenziali errate." -ForegroundColor Red
    Stop-SeDriver 
    Exit 
}
Write-Host "Loggato in gomp." -ForegroundColor Green

Invoke-SeClick -Element $prenotaBtn -Sleep 1


foreach ($corso in $corsi) {
    if ($corso -gt 0) {
        Write-Host "In corso la prenotazione del corso nr. $corso" -ForegroundColor Green
        $cssSelector = "#studyPlanBody > tr:nth-child($corso)"
        $curPrenota = Get-SeElement -By CssSelector -Value $cssSelector
        if ($curPrenota) { 
            Invoke-SeClick -Action Click_JS -Element $curPrenota -Sleep 1
            $jsScript = Get-Content .\selezionaSlot.js -Encoding UTF8 -Raw
            $dateSessioni = Invoke-SeJavascript -Script $jsScript
            for ($i = 0; $i -lt $dateSessioni.Count; $i++) {
                $curData = $dateSessioni[$i]
                $dataOggi = Get-Date
                $curData = [regex]::Replace($curData, "\s+", " ") 
                $dataParsed = [Datetime]::ParseExact($curData, 'dd/MM/yyyy HH:mm', $null)
                $giorniDiDifferenza = $dataParsed - $dataOggi
                if ($giorniDiDifferenza.Days -lt 8) {
                    $cssSelectorCourse = "#slotListBody > tr:nth-child($($i+1))"
                    $prenotaCorsoClick = Get-SeElement -By CssSelector -value $cssSelectorCourse
                    $giaPrenotato = Get-SeElement -Element $prenotaCorsoClick -By ClassName "fa-trash-alt" -ErrorAction SilentlyContinue
                    if (-not $giaPrenotato) {
                        Write-Host "In corso la prenotazione della lezione del $dataParsed" -ForegroundColor Green
                        Invoke-SeClick -Element $prenotaCorsoClick -Sleep 0.5
                        $ConfirmBtn = Get-SeElement -By ID -Value "partialQuestionYesNoConfirmButton"
                        Invoke-SeClick -Element $ConfirmBtn -Sleep 1.5
                        $torna = Get-SeElement -By CssSelector -Value "#backArrowReservs"
                        Invoke-SeClick -Element $torna -Sleep 0.5
                    }
                }
            }
        
        }     
        #Fine prenotazione del corso singolo, ritorniamo alla pagina principale
        $torna = Get-SeElement -By CssSelector -Value "#backArrow"
        Invoke-SeClick -Action Click_JS -Element $torna 
    }
}

Stop-SeDriver 