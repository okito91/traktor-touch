# Traktor Touch FX - installer for Windows. Run via install-windows.cmd (asks for admin rights).
param([switch]$Uninstall)
$ErrorActionPreference = 'Stop'

$qml = Get-ChildItem 'C:\Program Files\Native Instruments' -Directory -Filter 'Traktor Pro 4*' -ErrorAction SilentlyContinue |
       ForEach-Object { Join-Path $_.FullName 'Resources64\qml' } | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $qml) { Write-Host 'Traktor Pro 4 qml folder not found under C:\Program Files\Native Instruments.' -ForegroundColor Red; exit 1 }
if (Get-Process -Name 'Traktor*' -ErrorAction SilentlyContinue) { Write-Host 'Please quit Traktor first.' -ForegroundColor Red; exit 1 }

$screen = Join-Path $qml 'Screens\S8\Views\Screen.qml'
$backup = "$screen.traktortouch-backup"
$dest   = Join-Path $qml 'Screens\TraktorTouch'
$src    = Join-Path $PSScriptRoot '..\qml\Screens\TraktorTouch'
$marker = '// TRAKTOR-TOUCH'
$hook   = "`r`n  $marker (second-screen FX window)`r`n  Loader { source: `"../../TraktorTouch/FxWindow.qml`" }`r`n"

if ($Uninstall) {
  if (Test-Path $backup) { Copy-Item $backup $screen -Force; Remove-Item $backup }
  if (Test-Path $dest)   { Remove-Item $dest -Recurse -Force }
  Write-Host 'Traktor Touch FX removed.' -ForegroundColor Green; exit 0
}

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Copy-Item $src $dest -Recurse

$text = [IO.File]::ReadAllText($screen)
if ($text.Contains($marker)) {
  Write-Host 'Screen.qml already patched - files updated.'
} else {
  if (-not (Test-Path $backup)) { Copy-Item $screen $backup }
  $i = $text.LastIndexOf('}')
  if ($i -lt 0) { Write-Host 'Unexpected Screen.qml - not patched.' -ForegroundColor Red; exit 1 }
  [IO.File]::WriteAllText($screen, $text.Substring(0, $i) + $hook + $text.Substring($i))
}
Write-Host "Installed into $qml" -ForegroundColor Green
Write-Host 'Now start Traktor and add: Preferences > Controller Manager > Add... > Traktor > Kontrol D2'
