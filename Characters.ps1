 function Char([int]$currentCharacterPrompt) {
    switch($currentCharacterPrompt) {
        0 {Write-Host "[Info] " -ForegroundColor Magenta -NoNewline}
        1 {Write-Host $playerName"> " -ForegroundColor Cyan -NoNewline}
        2 {Write-Host "[Void] " -ForegroundColor Gray -NoNewline}
    }
}

function Get-Line {$global:currentCharacterLine = (Get-Content -Path .\characterlines\$currentSpeakingCharacter.txt)[$currentCharacterAction]}

function Char0([int]$currentCharacterAction) {
    Char 0; $global:currentSpeakingCharacter = 0
    switch ($currentCharacterAction) {
        0 {
            Get-Line; $currentCharacterLine | Write-Host
        }
    }
}

function Char1([int]$currentCharacterAction) {
    Char 1; $global:currentSpeakingCharacter = 1
    switch ($currentCharacterAction) {
        0 {Get-Line; $currentCharacterLine | Write-Host}
    }
}

function Char2([int]$currentCharacterAction) {
    Char 2; $global:currentSpeakingCharacter = 2
    switch ($currentCharacterAction) {
        0 {
            Get-Line; $currentCharacterLine | Write-Host
            $storyQuestion = "
What is your reaction?
IGNORE`tI AM FINE`tGIVE ME A DYNAMITE PLEASE"
            Provide-Choice $storyQuestion 3
            switch ($choice) {
                1 {"ignored"}
                2 {"void happy"}
                3 {"Here is your DYNAMITE"; $null = $global:item.Add("DYNAMITE")}
            }
        }
    }
}

function Get-Moving([string]$char,[int16]$playerX,[int16]$playerY) {
    Find-Char $char
    if ($map[$y - 1][$x], $map[$y][$x - 1], $map[$y + 1][$x], $map[$y][$x + 1] -match " ") {
        $randNum = Get-Random -Minimum 0 -Maximum 101
        if ($randNum -lt 70) {
            if ($playerX - $x -lt 0) {Forward-A $char} else {Forward-D $char}
        } else {
            if ($playerY - $y -lt 0) {Forward-W $char} else {Forward-S $char}
        }
    }
}