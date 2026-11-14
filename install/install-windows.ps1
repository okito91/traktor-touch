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
$d2       = Join-Path $qml 'CSI\D2\D2.qml'
$d2Backup = "$d2.traktortouch-backup"
$bridge   = Join-Path $qml 'CSI\D2\TraktorTouchBridge.qml'
$marker = '// TRAKTOR-TOUCH'
$hook   = "`r`n  $marker (second-screen FX window)`r`n  Loader { source: `"../../TraktorTouch/FxWindow.qml`" }`r`n"

if ($Uninstall) {
  if (Test-Path $backup) { Copy-Item $backup $screen -Force; Remove-Item $backup }
  if (Test-Path $dest)   { Remove-Item $dest -Recurse -Force }
  if (Test-Path $d2Backup) { Copy-Item $d2Backup $d2 -Force; Remove-Item $d2Backup }
  if (Test-Path $bridge)   { Remove-Item $bridge -Force }
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
# knob bridge for the D2 mapping
Copy-Item (Join-Path $PSScriptRoot '..\qml\CSI\D2\TraktorTouchBridge.qml') $bridge -Force
$d2Text = [IO.File]::ReadAllText($d2)
if (-not $d2Text.Contains($marker)) {
  if (-not (Test-Path $d2Backup)) { Copy-Item $d2 $d2Backup }
  $m = [regex]::Match($d2Text, 'Mapping\s*\{')
  if (-not $m.Success) { Write-Host 'Unexpected D2.qml - not patched.' -ForegroundColor Red; exit 1 }
  $at = $m.Index + $m.Length
  $d2Hook = "`r`n  TraktorTouchBridge { name: `"traktor_touch_bridge`" } $marker"
  [IO.File]::WriteAllText($d2, $d2Text.Substring(0, $at) + $d2Hook + $d2Text.Substring($at))
}
Write-Host "Installed into $qml" -ForegroundColor Green
Write-Host 'Now start Traktor and add: Preferences > Controller Manager > Add... > Traktor > Kontrol D2'
