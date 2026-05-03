#Requires -Version 5.0
# Syncs official BepInEx runtime (if missing), builds Release, refreshes dist/ (see README — dist is gitignored).
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root
$runtime = Join-Path $root "packaging\bepinex-runtime\winhttp.dll"
if (-not (Test-Path $runtime)) {
    Write-Host "packaging\bepinex-runtime\ not found — running Sync-BepInExRuntimePack.ps1"
    & (Join-Path $root "scripts\Sync-BepInExRuntimePack.ps1")
}
$managed = $env:GWYF_MANAGED
if (-not $managed) {
    Write-Error @"
GWYF_MANAGED is not set. Example:
  `$env:GWYF_MANAGED = (.\scripts\Find-GwyfManaged.ps1)
Or set it to your ...\Gamble With Your Friends_Data\Managed folder, then re-run this script.
"@
}
dotnet build .\GwyfUnlimitedPlayers.sln -c Release -p:GameManaged="$managed"
Write-Host "dist layout:"
Get-ChildItem -Path (Join-Path $root "dist") -Recurse | ForEach-Object { $_.FullName.Substring($root.Length + 1) }
