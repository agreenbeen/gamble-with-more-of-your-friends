#Requires -Version 5.0
# Downloads official BepInEx 5.4 Unity Mono (x64) and extracts to packaging/bepinex-runtime/
# so Release builds can copy a complete Doorstop + BepInEx tree into dist/.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$version = "5.4.23.5"
$zipName = "BepInEx_win_x64_$version.zip"
$url = "https://github.com/BepInEx/BepInEx/releases/download/v$version/$zipName"
$destDir = Join-Path $root "packaging\bepinex-runtime"
$tmpZip = Join-Path ([System.IO.Path]::GetTempPath()) $zipName

Write-Host "Downloading $url"
Invoke-WebRequest -Uri $url -OutFile $tmpZip -UseBasicParsing

if (Test-Path $destDir) {
    Remove-Item -LiteralPath $destDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

Write-Host "Extracting to $destDir"
Expand-Archive -LiteralPath $tmpZip -DestinationPath $destDir -Force

$probe = Join-Path $destDir "winhttp.dll"
if (-not (Test-Path $probe)) {
    throw "Expected $probe after extract. BepInEx zip layout may have changed."
}

Remove-Item -LiteralPath $tmpZip -Force -ErrorAction SilentlyContinue
Write-Host "OK: BepInEx $version runtime pack at $destDir (LGPL-2.1: https://github.com/BepInEx/BepInEx/blob/master/LICENSE)"
