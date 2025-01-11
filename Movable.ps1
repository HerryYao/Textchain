function Static-Console {
    [console]::windowwidth=101
    [console]::windowheight=52
    [console]::bufferwidth=[console]::windowwidth
}

#Function to find for moveble object's location in map
function Find-Char([string]$movableObject) {
    for ($y = 0; $y -lt 49; $y++) {
        for ($x = 0; $x -lt 99; $x++) {
            if (($map[$y])[$x] -eq $movableObject) {
                $global:y = $y; $global:x = $x; return
            }
        }
    }
}

[System.Collections.ArrayList]$map = Get-Content -Path .\map.txt
$map; $clearHost = 0; $global:mapRunning = $true

Find-Char "@"
Static-Console

while ($mapRunning) {
    Static-Console
    $KeyPress = [System.Console]::ReadKey()
    if ($clearHost -eq 50) {Clear-Host; $clearHost = 0}
    #if ($KeyPress.Key -eq '27') {exit}
    "`n"
    switch ($KeyPress.Key) {
        w {
            if (($map[$y - 1])[$x] -match " ") {
                $map[$y] = $map[$y].Remove($x,1).Insert($x, " ")
                $map[$y - 1] = $map[$y - 1].Remove($x,1).Insert($x,"@")
                --$y
            }
        }
        
        a {
            if (($map[$y])[$x - 1] -match " ") {
                $map[$y] = $map[$y].Remove($x,1).Insert($x - 1,"@")
                --$x
            }
        }

        s {
            if (($map[$y + 1])[$x] -match " ") {
                    $map[$y] = $map[$y].Remove($x,1).Insert($x, " ")
                    $map[$y + 1] = $map[$y + 1].Remove($x,1).Insert($x, "@")
                    ++$y
            }
        }

        d {
            if (($map[$y])[$x + 1] -match " ") {
                $map[$y] = $map[$y].Remove($x,1).Insert($x + 1,"@")
                ++$x
            }
        }

        e {INT..}
        
        "0" {exit}
    }

    Write-Host $map
    $clearHost++
}