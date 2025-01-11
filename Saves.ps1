function Save-Game($gameStepSave, [System.Collections.ArrayList]$inventoryToSave) {
        Char 0; [sByte]$saveSlot = Read-Host "Slot to save to" -ErrorAction SilentlyContinue
        if ($saveSlot -lt 1 -or $saveSlot -gt 5) {Char 0; "This is not a legit slot, try again"} else {
            Set-Content -Path .\saves\$saveSlot.txt -Value $null
            Add-Content -Path .\saves\$saveSlot.txt -Value $gameStepSave
            if ($inventory.Count -eq 0) {Add-Content -Path .\saves\$saveSlot.txt -Value "EMPTYINVENTORY"} else {
                for ($i = 0; $i -lt $inventory.Count - 1; $i++) {
                    Add-Content -Path .\saves\$saveSlot.txt -Value ($inventory[$i] + ",") -NoNewline
                }
                Add-Content -Path .\saves\$saveSlot.txt -Value ($inventory[$inventory.Count - 1])
                Char 0; "Game Saved"
            }
        }
}

function Load-Game {
    Char 0; [int]$saveSlot = Read-Host "Save slot to load"
    if ($saveSlot -lt 1 -or $saveSlot -gt 5) {Char 0; "Load failed"; Set-Variable -scope 1 -Name "gameStep" -Value 0} else {
        Set-Variable -scope 1 -Name "gameStep" -Value (Get-Content -Path .\saves\$saveSlot.txt)[0]
        if ((Get-Content -Path .\saves\$saveSlot.txt)[1] -match "EMPTYINVENTORY") {
            [System.Collections.ArrayList]$inventory = $inventory.Clear() ; Char 0; "Game Loaded[EMPTYINVENTORY]"
        } else {
                $null = ((Get-Content -Path .\saves\$saveSlot.txt)[1] -split ",") | ForEach-Object {$inventory.Add($_)}
                Char 0; "Game Loaded"
            }
    }
}

function Add-Item([int]$theItemNumToAdd) {
    if ((Get)) {}
        $item.Add((Get-Content -Path .\originalvalue\GlobalItem.txt)[$theItemNumToAdd])
}

function Reset-Game {}