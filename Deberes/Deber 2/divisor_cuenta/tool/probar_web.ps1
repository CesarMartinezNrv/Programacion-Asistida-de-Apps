param([string]$Navegador='C:\Program Files\Google\Chrome\Application\chrome.exe')
$ErrorActionPreference='Stop'
$proyecto=Split-Path -Parent $PSScriptRoot
$flutter=(Get-Command flutter -ErrorAction Stop).Source
$sdk=Split-Path -Parent (Split-Path -Parent $flutter)
$destino=Join-Path $proyecto 'test/canvaskit'
New-Item -ItemType Directory -Force $destino | Out-Null
# Workaround Flutter 3.47.1 Windows: servidor de test sirve recursos originales del SDK.
Copy-Item -LiteralPath (Join-Path $sdk 'bin/cache/flutter_web_sdk/canvaskit/chromium') -Destination $destino -Recurse -Force
$env:CHROME_EXECUTABLE=$Navegador
Set-Location -LiteralPath $proyecto
& (Join-Path $sdk 'bin/cache/dart-sdk/bin/dart.exe') (Join-Path $sdk 'bin/cache/flutter_tools.snapshot') pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& (Join-Path $sdk 'bin/cache/dart-sdk/bin/dart.exe') (Join-Path $sdk 'bin/cache/flutter_tools.snapshot') test --platform chrome --reporter expanded
exit $LASTEXITCODE
