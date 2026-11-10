param(
    [ValidateSet('contextual', 'negativo', 'sin-skill', 'con-skill', 'explicita-carga')]
    [string]$Caso
)

$ErrorActionPreference = 'Stop'
$participacion = Split-Path -Parent $PSScriptRoot
$csvPath = Join-Path $participacion 'logs_sinteticos.csv'
$skillSource = Join-Path $participacion 'incident-investigator'
$casePath = Join-Path $participacion "Proceso\$Caso"
New-Item -ItemType Directory -Path $casePath -Force | Out-Null
Copy-Item -LiteralPath $csvPath -Destination (Join-Path $casePath 'logs_sinteticos.csv') -Force

if ($Caso -ne 'sin-skill') {
    $installedPath = Join-Path $casePath '.agents\skills\incident-investigator'
    New-Item -ItemType Directory -Path $installedPath -Force | Out-Null
    Copy-Item -Path (Join-Path $skillSource '*') -Destination $installedPath -Recurse -Force
}

$solicitud = switch ($Caso) {
    'contextual' { 'Revisa estos registros de autenticación. ¿Ves intentos sospechosos, cambios no aprobados o posibles secretos expuestos? Cita las filas que respaldan cada alerta.' }
    'negativo' { 'Muéstrame cuántos eventos hay por hora en este CSV; no investigues incidentes ni clasifiques amenazas.' }
    'explicita-carga' { 'Utiliza incident-investigator para investigar logs_sinteticos.csv y entrega hallazgos con filas de evidencia.' }
    default { 'Investiga los logs sintéticos, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta.' }
}

$common = @'
Esta es una prueba local con logs sintéticos. No uses red, apps ni MCP.
No escribas archivos. No muestres valores de tokens ni secretos completos.
No lances otros agentes. Responde en español.
'@

if ($Caso -in @('sin-skill', 'con-skill', 'explicita-carga', 'negativo')) {
    # La lectura del agente falla bajo la política local de Windows.
    # El invocador entrega las líneas reales; no se construye un CSV alternativo.
    $common += "`nNo ejecutes herramientas: el invocador proporciona abajo el archivo leído del disco. Los prefijos son líneas físicas del original; el encabezado es la fila 1.`n"
    $lineNo = 0
    $numberedCsv = (Get-Content -LiteralPath $csvPath | ForEach-Object {
        $lineNo++
        '{0}: {1}' -f $lineNo, $_
    }) -join "`n"
    $common += "`nARCHIVO logs_sinteticos.csv:`n$numberedCsv`nFIN DEL ARCHIVO.`n"
}

if ($Caso -in @('con-skill', 'explicita-carga')) {
    $skillBody = Get-Content -LiteralPath (Join-Path $skillSource 'SKILL.md') -Raw
    $rulesBody = Get-Content -LiteralPath (Join-Path $skillSource 'references\detection-rules.md') -Raw
    $common += "`nUsa el skill instalado. Como alternativa a la lectura bloqueada, el invocador proporciona sus archivos reales leídos del disco. No afirmes haberlos abierto tú con herramientas.`nSKILL.md:`n$skillBody`nreferences/detection-rules.md:`n$rulesBody`n"
}

$prompt = "$common`nSOLICITUD:`n$solicitud"
$tokenValues = @(Import-Csv -LiteralPath $csvPath | ForEach-Object {
    if ($_.detail -cmatch 'token=([^;\s]+)') {
        [regex]::Match($_.detail, 'token=([^;\s]+)').Groups[1].Value
    }
})
$tracePath = Join-Path $PSScriptRoot "$Caso.jsonl"
$errorPath = Join-Path $PSScriptRoot "$Caso-error.txt"
$configArgs = @(
    'exec', '--ignore-user-config', '--ephemeral', '--skip-git-repo-check',
    '-C', $casePath, '-s', 'read-only',
    '-c', 'features.apps=false', '-c', 'features.plugins=false',
    '-c', 'skills.bundled.enabled=false', '--json', '-'
)
if ($Caso -eq 'sin-skill') {
    $configArgs = $configArgs[0..($configArgs.Length - 3)] + @('-c', 'skills.include_instructions=false', '--json', '-')
}

$prompt | codex @configArgs 2> $errorPath | ForEach-Object {
    $safeLine = $_
    foreach ($tokenValue in $tokenValues) {
        $safeLine = $safeLine.Replace($tokenValue, '[REDACTED]')
    }
    $safeLine
} | Set-Content -LiteralPath $tracePath -Encoding utf8

if ($LASTEXITCODE -ne 0) { throw "Codex terminó con código $LASTEXITCODE; revisar $errorPath" }
