#Requires -Version 5.0
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root
if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    Write-Error ".NET SDK not found. Install from https://dotnet.microsoft.com/download"
}
$managed = $env:GWYF_MANAGED
if (-not $managed) {
    Write-Error @"
GWYF_MANAGED is not set. Set it to the game's Managed folder, for example:
  `$env:GWYF_MANAGED = 'C:\Program Files (x86)\Steam\steamapps\common\Gamble With Your Friends\Gamble With Your Friends_Data\Managed'
Or run .\scripts\Find-GwyfManaged.ps1 and copy the path it prints.
You can also use: dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged=`"FULL_PATH`"
"@
}
dotnet restore .\GwyfUnlimitedPlayers.sln
dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged="$managed"
Write-Host "Output: $root\build\GwyfUnlimitedPlayers.dll"
