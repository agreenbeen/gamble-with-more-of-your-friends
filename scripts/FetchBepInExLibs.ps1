#Requires -Version 5.0
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$version = "5.4.23.5"
$zipName = "BepInEx_win_x64_$version.zip"
$url = "https://github.com/BepInEx/BepInEx/releases/download/v$version/$zipName"
$destDll = Join-Path $root "lib\BepInEx\BepInEx.dll"
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) $zipName

Write-Host "Downloading $url"
Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
Expand-Archive -Path $tmp -DestinationPath (Join-Path $root "lib\_bepinex_extract") -Force
$coreDll = Join-Path $root "lib\_bepinex_extract\BepInEx\core\BepInEx.dll"
if (-not (Test-Path $coreDll)) { throw "Expected $coreDll after extract" }
New-Item -ItemType Directory -Force -Path (Split-Path $destDll) | Out-Null
Copy-Item -Force $coreDll $destDll
Remove-Item -Recurse -Force (Join-Path $root "lib\_bepinex_extract")
Remove-Item -Force $tmp
Write-Host "Updated $destDll"
Write-Host "Tip: for a full BepInEx runtime under packaging\bepinex-runtime\ (complete dist\ bundle), run scripts\Sync-BepInExRuntimePack.ps1"
