# copy_files.ps1

$convertedPath = Join-Path $PSScriptRoot "converted"
$packRoot = Join-Path $PSScriptRoot "mod\sounds"
$distPath = Join-Path $PSScriptRoot "dist"
$mcpackPath = Join-Path $distPath "Poly-C418-Fixes.mcpack"

$musicGame       = Join-Path $packRoot "music\game"
$musicNether     = Join-Path $packRoot "music\nether"
$musicEnd        = Join-Path $packRoot "music\end"
$musicUnderwater = Join-Path $packRoot "music\underwater"
$records         = Join-Path $packRoot "records"

# Create all directories if missing
$folders = @($musicGame, $musicNether, $musicEnd, $musicUnderwater, $records)
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
    }
}

# Route files based on name
Get-ChildItem -Path $convertedPath -Filter *.ogg | ForEach-Object {
    $file = $_.Name
    $src = $_.FullName
    $dest = $null

    switch -Wildcard ($file) {
        "calm*.ogg" {
            $dest = Join-Path $musicGame $file
            break
        }
        "hal*.ogg" {
            $dest = Join-Path $musicGame $file
            break
        }
        "nuance*.ogg" {
            $dest = Join-Path $musicGame $file
            break
        }
        "piano*.ogg" {
            $dest = Join-Path $musicGame $file
            break
        }
        "creative*.ogg" {
            $dest = Join-Path $musicGame $file
            break
        }
        "nether*.ogg" {
            $dest = Join-Path $musicNether $file
            break
        }
        "underwater*.ogg" {
            $dest = Join-Path $musicUnderwater $file
            break
        }
        "end.ogg" {
            $dest = Join-Path $musicEnd $file
            break
        }
        { $_ -in @("13.ogg", "cat.ogg", "blocks.ogg") } {
            $dest = Join-Path $records $file
            break
        }
        default {
            $dest = Join-Path $musicGame $file
        }
    }

    Write-Host "Copying $file to $dest"
    Copy-Item -Path $src -Destination $dest -Force
}
New-Item -ItemType Directory -Force -Path $distPath | Out-Null

if (Test-Path $mcpackPath) {
    Remove-Item $mcpackPath -Force
}

Write-Host "`nPacking resource pack to $mcpackPath..."
Compress-Archive -Path "mod\*" -DestinationPath $mcpackPath -Force

Write-Host "✅ Done! Pack created: $mcpackPath"
