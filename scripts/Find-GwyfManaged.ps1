#Requires -Version 5.0
<#
.SYNOPSIS
  Prints the path to Gamble With Your Friends_Data\Managed (where Mirror.dll lives) for use as -p:GameManaged=...

.EXAMPLE
  .\scripts\Find-GwyfManaged.ps1
  dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged="$(.\scripts\Find-GwyfManaged.ps1)"
#>
$ErrorActionPreference = "Stop"

function Test-GwyfManaged([string]$SteamAppsRoot) {
    $managed = Join-Path $SteamAppsRoot "common\Gamble With Your Friends\Gamble With Your Friends_Data\Managed"
    $mirror = Join-Path $managed "Mirror.dll"
    if (Test-Path -LiteralPath $mirror) { return $managed }
    return $null
}

function Get-SteamInstallPaths {
    $paths = [System.Collections.Generic.List[string]]::new()
    foreach ($key in @(
        "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam",
        "HKLM:\SOFTWARE\Valve\Steam"
    )) {
        if (Test-Path $key) {
            $ip = (Get-ItemProperty -Path $key -Name InstallPath -ErrorAction SilentlyContinue).InstallPath
            if ($ip) { [void]$paths.Add((Join-Path $ip "steamapps")) }
        }
    }
    # Optional: common extra-library roots (registry + libraryfolders.vdf are tried first)
    foreach ($guess in @(
        "D:\SteamLibrary\steamapps",
        "E:\SteamLibrary\steamapps"
    )) {
        if (Test-Path -LiteralPath $guess) { [void]$paths.Add($guess) }
    }
    return $paths | Select-Object -Unique
}

function Get-LibrarySteamAppsFromVdf([string]$steamRoot) {
    $candidates = @(
        (Join-Path $steamRoot "config\libraryfolders.vdf"),
        (Join-Path $steamRoot "steamapps\libraryfolders.vdf")
    )
    $out = [System.Collections.Generic.List[string]]::new()
    foreach ($vdf in $candidates) {
        if (-not (Test-Path -LiteralPath $vdf)) { continue }
        $text = Get-Content -LiteralPath $vdf -Raw -ErrorAction SilentlyContinue
        if (-not $text) { continue }
        foreach ($m in [regex]::Matches($text, '"path"\s+"([^"]+)"')) {
            $p = $m.Groups[1].Value -replace '\\\\', '\'
            if ($p) {
                $apps = Join-Path $p "steamapps"
                if (Test-Path -LiteralPath $apps) { [void]$out.Add($apps) }
            }
        }
    }
    return $out | Select-Object -Unique
}

$steamRoots = @()
foreach ($apps in (Get-SteamInstallPaths)) {
    [void]$steamRoots.Add((Split-Path $apps -Parent))
}
$steamRoots = $steamRoots | Select-Object -Unique

$allSteamApps = [System.Collections.Generic.List[string]]::new()
foreach ($apps in (Get-SteamInstallPaths)) { [void]$allSteamApps.Add($apps) }
foreach ($root in $steamRoots) {
    foreach ($extra in (Get-LibrarySteamAppsFromVdf $root)) {
        [void]$allSteamApps.Add($extra)
    }
}
$allSteamApps = $allSteamApps | Select-Object -Unique

$found = $null
foreach ($apps in $allSteamApps) {
    $found = Test-GwyfManaged $apps
    if ($found) { break }
}

if (-not $found) {
    Write-Error @"
Could not find Mirror.dll under any known Steam library.

Fix:
1) Steam → Library → Gamble With Your Friends → Manage → Browse local files
2) Open the folder that contains the game .exe, then go into:
   Gamble With Your Friends_Data\Managed
3) Confirm Mirror.dll exists there, then build with:
   dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged=\"FULL_PATH_TO_Managed\"
"@
}

Write-Output $found
