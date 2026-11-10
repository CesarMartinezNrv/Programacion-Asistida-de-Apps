$ErrorActionPreference = 'Stop'
$csvPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'logs_sinteticos.csv'
$before = (Get-FileHash -LiteralPath $csvPath -Algorithm SHA256).Hash
$originalLines = @(Get-Content -LiteralPath $csvPath)
$rows = @(Import-Csv -LiteralPath $csvPath)
if ($originalLines.Count -ne $rows.Count + 1) { throw 'Revisar numeración: posible CSV multilínea' }

$lineNo = 1
$events = @($rows | ForEach-Object {
    $lineNo++
    [pscustomobject]@{
        Row = $lineNo
        Time = [datetimeoffset]::Parse($_.timestamp)
        Ip = $_.ip; User = $_.user; Event = $_.event; Result = $_.result
        Detail = $_.detail
    }
} | Sort-Object Time, Row)

'Archivo: logs_sinteticos.csv'
'SHA256 inicial: ' + $before
'Registros: ' + $rows.Count
'Columnas: ' + ($rows[0].PSObject.Properties.Name -join ', ')
'Rango: ' + $events[0].Time.ToString('o') + ' / ' + $events[-1].Time.ToString('o')
'Conteos por hora:'
$events | Group-Object { $_.Time.ToString('yyyy-MM-dd HH:00 zzz') } | ForEach-Object { '{0}: {1}' -f $_.Name, $_.Count }

$failed = @($events | Where-Object { $_.Event -ceq 'login' -and $_.Result -ceq 'failed' })
'Ventanas R1 que alcanzan umbral (sin eliminar duplicados):'
foreach ($group in ($failed | Group-Object Ip,User)) {
    $groupRows = @($group.Group | Sort-Object Time,Row)
    foreach ($start in $groupRows) {
        $window = @($groupRows | Where-Object { $_.Time -ge $start.Time -and $_.Time -le $start.Time.AddMinutes(5) })
        if ($window.Count -ge 6) {
            '{0}/{1}: {2} fallos; filas {3}' -f $start.Ip,$start.User,$window.Count,($window.Row -join ', ')
        }
    }
}
'Ventanas R2 que alcanzan umbral:'
foreach ($group in ($failed | Group-Object Ip)) {
    foreach ($start in ($group.Group | Sort-Object Time,Row)) {
        $window = @($group.Group | Where-Object { $_.Time -ge $start.Time -and $_.Time -le $start.Time.AddMinutes(5) })
        $users = @($window.User | Sort-Object -Unique)
        if ($users.Count -ge 5) {
            '{0}: {1} usuarios; filas {2}' -f $start.Ip,$users.Count,($window.Row -join ', ')
        }
    }
}
'Repeticiones exactas en las seis columnas, sin deduplicar:'
$events | Group-Object Time,Ip,User,Event,Result,Detail | Where-Object Count -gt 1 | ForEach-Object {
    'Filas ' + ($_.Group.Row -join ', ') + '; registros: ' + $_.Count
}
'Filas con token= (sin imprimir valores): ' + (($events | Where-Object { $_.Detail.Contains('token=') }).Row -join ', ')
'Cambios de rol no aprobados: ' + (($events | Where-Object {
    $_.Event -ceq 'role_change' -and $_.Result -ceq 'success' -and $_.Detail -cmatch '(^|;\s*)approved=false($|;)'
}).Row -join ', ')
'Verificación directa de líneas originales (campo detail completo oculto si contiene token=):'
foreach ($number in @(17,19,20,22,23,25,26,27,28,33,38,39,41,42,57,59,67,68,70,71,73,74,78,80,81,82,83,84)) {
    $line = $originalLines[$number - 1]
    if ($line.Contains('token=')) { $line = ($line -split ',',6)[0..4] -join ','; $line += ',token=[REDACTED]' }
    '{0}: {1}' -f $number,$line
}
$after = (Get-FileHash -LiteralPath $csvPath -Algorithm SHA256).Hash
if ($before -cne $after) { throw 'El CSV cambió' }
'SHA256 final: ' + $after
'Integridad: sin cambios'
