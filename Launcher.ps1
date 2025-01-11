function Start-GameInLobby {
    Start-Process powershell.exe -ArgumentList ".\Main.ps1"
    Remove-Module -Name Characters, Saves
}
CD C:\TextChain
Import-Module -Name .\Characters.ps1, .\Saves.ps1 -Force

Write-Host "Textchain DEMO version`n[1]NEW GAME`t[2]LOAD GAME"
$startMenuOption = Read-Host
switch ($startMenuOption) {
    1 {
        #The welcome message from laucher
        Char 0; "Welcome`n"
        Write-Host "Textchain is " -NoNewline
        Write-Host "Command-Based" -ForegroundColor Yellow
        "You will have to type commands to perform an action
There is a file called CMD.txt in the game library, check it out if anything`n"
        $playerName = Get-Content -Path .\PlayerName.txt

        #To see if the player is new or wants to change name
        if ($playerName -eq $null) {
            Char 0; Write-Host "Wait! What is your NAME? " -NoNewline
            $playerName = $Host.UI.ReadLine()
            $playerName >> .\PlayerName.txt
        } else {
            Char 0; Write-Host "Is"$playerName" your name?[Yes/No]" -NoNewline
            $isYourName = $Host.UI.ReadLine()
            if ($isYourName -notmatch "yes") {
                Set-Content -Path .\PlayerName.txt -Value $null
                Char 0; $playerName = Read-Host "Tell me your name then"
                Set-Content -Path .\PlayerName.txt -Value $playerName
            }
        #Start game
        Start-GameInLobby
        }
    }

    2 {
        Load-Game
        Start-GameInLobby
    }

    default {"`tERR..."; Start-Sleep -Seconds 3; exit}
}