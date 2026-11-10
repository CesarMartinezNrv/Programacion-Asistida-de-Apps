# Hallazgos — Participación 12

Revisé `logs_sinteticos.csv` con asistencia de Codex y contrasté las filas con PowerShell. El archivo tiene 93 registros y las columnas `timestamp`, `ip`, `user`, `event`, `result` y `detail`. Las fechas van del 5 de noviembre de 2026 a las 01:01 hasta las 02:29, todas con zona `-05:00`. El encabezado es la fila 1. No modifiqué el CSV ni consulté las IP.

## Alertas encontradas

| Alerta | Severidad orientativa | Regla | Timestamp o intervalo | IP | Usuario | Filas/evidencia | Limitaciones |
|---|---|---|---|---|---|---|---|
| Fuerza bruta probable | Alta, por la cuenta administrativa y el éxito posterior | R1: al menos 6 fallos en 5 minutos | 01:14–01:18; éxito a las 01:19 | 198.51.100.77 | admin | 17, 19, 20, 22, 23, 25, 26 y 27: ocho `login/failed` en cuatro minutos. Fila 28: `login/success` un minuto después | Hay tres pares de registros idénticos. El umbral depende de contarlos como registros separados; el éxito no confirma una intrusión |
| Token potencialmente expuesto | Media, por aparecer en depuración | R3: `token=` en detail | 01:27 | 192.0.2.44 | api_service | 33: `debug/warning`, con `token=[REDACTED]` | No demuestra que el token sea válido, se haya utilizado o se haya filtrado fuera del sistema |
| Cambio de rol no aprobado según el registro | Alta, por el cambio a administrador | R4: `role_change/success` y `approved=false` | 01:50 | 203.0.113.42 | guest | 59: `role=user->admin; approved=false`. En la 57 hubo acceso denegado a `/admin` a las 01:49 | No permite saber quién hizo el cambio ni si después accedió a recursos administrativos |
| Password spraying probable | Media, por afectar varias cuentas | R2: al menos 5 usuarios distintos en 5 minutos | 02:01–02:03 | 203.0.113.89 | ana, carlos, luisa, diego, maria y sofia | 67, 68, 70, 71, 73 y 74: seis `login/failed` contra seis usuarios distintos en dos minutos | No hay un éxito de esa IP en el archivo. Tampoco se ven las contraseñas utilizadas |

Las severidades indican una prioridad de revisión para este ejercicio. No son una medida objetiva del impacto.

## Verificación contra las filas originales

Comprobé la secuencia de `admin` directamente en las líneas del CSV. La primera falla está en la fila 17, a las 01:14, y la última está en la 27, a las 01:18. Son ocho registros de la misma IP y el mismo usuario en cuatro minutos. La fila 28 muestra el éxito a las 01:19, un minuto después. Por eso cumple la regla sobre los registros tal como están entregados y el éxito se anota por separado.

También encontré algo que cambia la confianza en ese resultado: las filas 19/20, 22/23 y 25/26 son idénticas en las seis columnas. No las eliminé porque no hay un identificador que pruebe si son intentos distintos o duplicaciones del registro. Si cada par fuera una duplicación de captura, quedarían cinco fallos y ya no se alcanzaría el umbral de seis. Por eso mantengo la alerta con esa limitación, sin afirmar que hubo ocho intentos independientes.

La comprobación y las líneas originales con el token oculto están en [verificacion.txt](evidencias/verificacion.txt). El script que la reproduce es [verificar.ps1](evidencias/verificar.ps1). Sus ventanas solapadas respaldan una sola secuencia de fuerza bruta y una de spraying; no las conté como incidentes adicionales.

## Casos que no clasifiqué como ataque

En las filas 38, 39 y 41, `maria` tiene tres fallos desde `192.0.2.25`, entre las 01:35 y las 01:37. La fila 42 muestra un éxito a las 01:38. Tres fallos no cumplen el umbral de seis y tampoco son cinco usuarios distintos. Los detalles indican errores al escribir la contraseña y un usuario legítimo; aun así, esa etiqueta no es una comprobación independiente de identidad.

Las filas 78 y 80–84 son seis `healthcheck/success` de `healthbot`. Su frecuencia no las convierte en intentos fallidos de acceso. Para contar fallos deben coincidir exactamente `event=login` y `result=failed`.

## Integridad y alcance

El SHA-256 inicial y final fue el mismo:

```text
7D8219E9F8C9DD995BE0C2DC038F4F7E67F0F12446B4FDC07FADF508BEFB5DA8
```

Los datos son inventados y las IP son de documentación. El archivo no tiene identificadores de evento, información de MFA ni auditoría posterior suficiente para confirmar compromiso o atribuir responsabilidades. Las alertas describen lo que respaldan estas filas; no prueban una intrusión ni que el resto del sistema sea seguro.
