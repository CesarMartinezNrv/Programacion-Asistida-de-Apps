# Participación 12 — Cyber Detective

## 1. Skill frente a plugin

`incident-investigator` es un skill porque reúne instrucciones y una referencia para investigar logs. En `SKILL.md` expliqué cuándo usarlo, qué pasos seguir y cómo presentar la evidencia. Dejé los umbrales en `references/detection-rules.md` para que el agente los consulte antes de clasificar los registros. Así se puede usar con otro CSV que tenga las mismas columnas.

Para distribuirlo como plugin podría incluir el skill y un manifiesto con la información que pida la plataforma. También podría agregar un comando para iniciar la revisión, un hook que ejecute una comprobación ante un evento del entorno o un servidor MCP para acceder a una fuente autorizada de registros. Cada componente tendría una función distinta: el skill da el procedimiento, el hook automatiza una acción y MCP permite acceder a capacidades externas. El plugin los puede empaquetar. En este ejercicio no necesito MCP porque el archivo es local y la consigna pide trabajar sin servicios externos.

## 2. Ralph Loop

Repetiría la revisión con un máximo de tres iteraciones, contando la primera ejecución. En cada una comprobaría que las filas citadas existen, que los eventos coinciden con la regla, que las ventanas no pasan de cinco minutos y que no aparece ningún token completo en la salida. También revisaría que el CSV siga intacto.

Si encuentro un error, le devolvería al agente la comprobación que falló. Por ejemplo: «Esta alerta cita cinco fallos, pero la regla exige seis». El siguiente intento tendría que corregir el informe usando el mismo CSV, sin agregar eventos para justificar la respuesta.

Pararía cuando todas las comprobaciones pasen. Si al terminar la tercera iteración todavía hay errores, dejaría el resultado como incompleto y explicaría qué falta revisar. No seguiría repitiendo hasta que el agente diga que todo está bien. Este es el diseño del ciclo; no instalé ni ejecuté Ralph Loop.

## 3. Qué comprobé del skill

Preparé el trabajo con asistencia de Codex. La prueba explícita encontró el skill, pero el entorno bloqueó la lectura desde el agente. Después lo invoqué en otra sesión y el proceso invocador le entregó los archivos reales como contexto. Esa ejecución sí aplicó las reglas y produjo hallazgos con filas, aunque no fue una lectura autónoma del agente.

En la prueba contextual, sin nombrarlo en la solicitud, el agente seleccionó `incident-investigator` e intentó abrir su `SKILL.md`. El comando quedó registrado como bloqueado por la política local. Eso demuestra un intento de selección y lectura; no demuestra una investigación completa mediante carga automática.

En el control negativo solo devolvió los eventos por hora: 63 a la 01:00 y 30 a las 02:00. No investigó amenazas ni invocó herramientas. No cambié la description porque las señales de selección fueron las esperadas; el problema fue el permiso de lectura, no una selección equivocada.

## 4. Qué me dejó la comparación

Las dos sesiones encontraron las mismas cuatro alertas. La diferencia útil fue que la sesión con skill explicó los tres pares de registros idénticos y cómo afectan el umbral de fuerza bruta. Para mí, ese es el aporte principal: seguir un procedimiento que obligue a revisar la evidencia y sus límites, en vez de quedarse con una conclusión que suena convincente.

Los resultados están en [hallazgos.md](hallazgos.md), la comparación en [comparacion.md](comparacion.md) y las condiciones reales de las pruebas en [evidencias/estado.md](evidencias/estado.md). No instalé un plugin ni Ralph Loop; esas dos respuestas describen cómo los usaría.
