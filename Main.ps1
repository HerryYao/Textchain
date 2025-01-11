Import-Module -Name .\Saves.ps1, .\Characters.ps1, .\Stories.ps1 -Force
function Static-Console {#PS window resize to fit map
    [console]::windowwidth=101
    [console]::windowheight=52
    [console]::bufferwidth=[console]::WindowWidth
}
function Find-Char([string]$targetObject) {#player location
    for ($y = 0; $y -lt 49; $y++) {
        for ($x = 0; $x -lt 99; $x++) {
            if (($map[$y])[$x] -eq $targetObject) {
                $global:y = $y; $global:x = $x; return
            }
        }
    }
}
function Provide-Choice([string]$storyQuestion, [sByte]$availableSelections) {#display choose section
    Write-Host "Question: " -NoNewline -ForegroundColor Yellow; $storyQuestion
    $inCorrectSelection = $true
    while ($inCorrectSelection) {
        $global:choice = Read-Host "Select (number)"
        if ($choice -lt 1 -or $choice -gt $availableSelections) {Char 0; "Invalid selection"} else {
            $inCorrectSelection = $false
            }
    }
}

function Forward-W([string]$movables) {
    if (($map[$y - 1])[$x] -match " ") {
        $map[$y] = $map[$y].Remove($x,1).Insert($x," ")
        $map[$y - 1] = $map[$y - 1].Remove($x,1).Insert($x,$movables)
        --$y
    }
}

function Forward-A([string]$movables) {
    if (($map[$y])[$x - 1] -match " ") {
        $map[$y] = $map[$y].Remove($x,1).Insert($x - 1,$movables)
        --$x
    }
}

function Forward-S([string]$movables) {
    if (($map[$y + 1])[$x] -match " ") {
            $map[$y] = $map[$y].Remove($x,1).Insert($x," ")
            $map[$y + 1] = $map[$y + 1].Remove($x,1).Insert($x,$movables)
            ++$y
    }
}

function Forward-D([string]$movables) {
    if (($map[$y])[$x + 1] -match " ") {
        $map[$y] = $map[$y].Remove($x,1).Insert($x + 1,$movables)
        ++$x
    }
}

#player functions:
function Pick-Up {#pick item(s) up
    $canHaveIt = $true
    #EVERY ITEM IS UNIQUE
    for ($i = 0; $i -lt $inventory.Count; $i++) {
        for ($j = 0; $j -lt $item.Count; $j++) {
            if ($inventory[$i] -match $item[$j]) {$canHaveIt = $false}
        }
    }
    if ($inventory.Count -eq 9) {Char 0; "Inventory full"; return}
    if ($item.Count -eq 0) {"No items to pick up!"} else {
        Char 0; [sByte]$itemToPick = Read-Host "Item to take? (Item number)"
        if ($itemToPick -gt $item.Count -or $itemToPick -lt 1) {"No such item"} elseif ($canHaveIt -eq $false) {
            Char 0; "You already have it!"
            } else {
                $null = $inventory.Add($item[$itemToPick - 1])
                Char 0; "You have picked up " + $item[$itemToPick - 1]
                $global:item.RemoveAt($itemToPick - 1)
            }
    }
}
function Drop-Item {#leave item(s) on floor
    if ($inventory.Count -eq 0) {"Empty inventory!"} else {
    Char 0; [sByte]$itemToLeave = Read-Host "Item to drop? (Inventory slot number)"
        if ($itemToLeave -gt $inventory.Count -or $itemToLeave -lt 1) {"Invalid slot"} else {
            $null = $item.Add($inventory[$itemToLeave - 1])
            $null = $inventory.RemoveAt($itemToLeave - 1)
            Char 0 ;"Item Droped"
        }
    }
}
function See-Inventory {#display inventory item(s)
    Char 1; Write-Host $inventory
}
function Interact-Object {#interact with any available objects
    if ($map[$y - 1][$x], $map[$y][$x - 1], $map[$y + 1][$x], $map[$y][$x + 1] -match "#") {
    #if ($map[$y - 1][$x] -match "#" -or $map[$y][$x - 1] -match "#" -or $map[$y + 1][$x] -match "#" -or $map[$y][$x + 1] -match "#") {
        ++$global:gameStep
        Story-Line $gameStep
        Char 0; "You are on step " + $gameStep
    }
}
#declare initials:
Char 0 # character function
Write-Host "Console mode: In game"
$gameRunning = $true; [System.Collections.ArrayList]$inventory = @(); [int]$global:gameStep = 0
[sByte]$global:choice = 0; [System.Collections.ArrayList]$global:item = @(); $playerName = Get-Content -Path ".\PlayerName.txt"
[System.Collections.ArrayList]$map = Get-Content -Path .\map.txt
$map; $clearHost = 0; $global:mapRunning = $true; Static-Console; $player = "@"

while ($mapRunning) {
    Static-Console
    Find-Char $player
    #player controls:
    $KeyPress = [System.Console]::ReadKey()
    if ($clearHost -eq 100) {Clear-Host; $clearHost = 0}
    "`n"
    switch ($KeyPress.Key) {
        w {Forward-W $player; break}
        
        a {Forward-A $player; break}

        s {Forward-S $player; break}

        d {Forward-D $player; break}

        e {Interact-Object; break}

        i {See-Inventory; break}

        q {Drop-Item; break}

        m {
            Write-Host "GAME PAUSED`n[1]SAVE`t[2]LOAD"`t[3]EXIT
            $exitOption = Read-Host
            switch ($exitOption) {
                1 {Save-Game $global:gameStep; break}
                2 {Load-Game; break}
                3 {$global:mapRunning = $false; break}
                default {"ERR..."}
            }
        }

        p {Pick-Up; break}
        
        default {break}
    }
    #mob moves after player
    Get-Moving Z $x $y
    $randNum = Get-Random -Minimum 0 -Maximum 101
    if ($randNum -lt 90) {
    Get-Moving S $x $y}

    Write-Host $map
    $clearHost++
}

Char 0; Write-Host "Console mode: Back to system" -NoNewline
Remove-Module -Name Saves, Characters, Stories
Read-Host