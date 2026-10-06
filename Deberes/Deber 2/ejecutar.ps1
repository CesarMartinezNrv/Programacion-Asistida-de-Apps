param([ValidateSet('dev','build','test','install','check:architecture','preview')][string]$Accion='dev')
$ErrorActionPreference='Stop'
$proyecto=Join-Path $PSScriptRoot 'divisor_cuenta_web'
if (-not (Test-Path -LiteralPath $proyecto)) { $proyecto=Join-Path $PSScriptRoot 'divisor_cuenta_web_entrega' }
Set-Location -LiteralPath $proyecto
$env:SPECIFY_FEATURE_DIRECTORY='specs/001-dividir-cuenta'
$env:npm_config_cache=Join-Path $PSScriptRoot 'herramientas/npm-cache'
$npmLocal=Join-Path $PSScriptRoot 'herramientas/node_modules/npm/bin/npm-cli.js'
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if ($Accion -eq 'install') { npm ci } else { npm run $Accion }
} elseif (Test-Path -LiteralPath $npmLocal) {
    if ($Accion -eq 'install') { node $npmLocal ci } else { node $npmLocal run $Accion }
} else { throw 'Instala Node >= 22.12 con npm y ejecuta nuevamente.' }
exit $LASTEXITCODE
