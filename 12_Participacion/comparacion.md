# Comparación sin skill / con skill

Hice la comparación con dos ejecuciones nuevas e independientes de Codex CLI `0.167.0-alpha.3.2`. No usé `resume` ni `fork`. Cada condición tuvo su propia carpeta y una copia idéntica del CSV. Las dos usaron el mismo ejecutable, las mismas opciones y la configuración predeterminada al pasar `--ignore-user-config`; el identificador exacto del modelo no aparece en las trazas JSONL conservadas, así que no afirmo haberlo verificado.

La solicitud fue exactamente la misma:

> Investiga los logs sintéticos, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta.

## Cómo separé las condiciones

La política local de Windows bloqueó la lectura desde el agente en las pruebas iniciales. Para la comparación, el invocador leyó el CSV y entregó las mismas 94 líneas numeradas en ambas sesiones. Ninguna recibió los hallazgos de la otra ni el script de verificación. Ambas recibieron la misma instrucción de no usar herramientas, no consultar servicios externos y no mostrar tokens completos.

**Sin skill:** la carpeta no tenía `incident-investigator` instalado. Se desactivó la inclusión de instrucciones de skills y no se proporcionaron `SKILL.md`, las reglas ni un detector.

**Con skill:** se colocó una copia en `.agents/skills/incident-investigator/` dentro de su carpeta de prueba. Además, el invocador entregó el contenido real de `SKILL.md` y `references/detection-rules.md` como alternativa a la lectura bloqueada. La respuesta reconoce esa carga y no afirma haber abierto los archivos con herramientas. Esta condición evalúa el aporte de las instrucciones cargadas explícitamente; no demuestra selección automática ni lectura autónoma.

## Resultados observados

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| ¿Usó un procedimiento reproducible? | Organizó hallazgos y evidencias, pero no explicitó umbrales ni ventanas como reglas reutilizables | Revisó columnas, fechas, reglas, ventanas, duplicados y limitaciones | La salida con skill muestra R1–R4 y las convenciones de filas |
| ¿Citó filas concretas? | Sí | Sí | Ambas citan las filas 17–28, 33, 59 y 67–74 según el hallazgo |
| Alertas sustentadas | Cuatro grupos | Cuatro grupos | No hubo una mejora en cantidad de alertas |
| Falsos positivos detectados o evitados | Separó los tres fallos de maria y los healthchecks de los hallazgos | También los separó y explicó los umbrales exactos | El skill volvió explícito por qué esos eventos no cumplen las reglas |
| ¿Ocultó posibles tokens? | Sí | Sí | Ambas respuestas ocultaron el valor de la fila 33; las dos tenían además una instrucción común de ocultamiento |
| ¿Reconoció incertidumbre? | Sí: no confirmó compromiso, uso del token ni impacto posterior | Sí, y añadió el efecto de los registros idénticos sobre R1 | La salida sin skill no advierte los tres pares repetidos |
| ¿Qué hizo gracias al skill? | No analizó la dependencia del umbral respecto a las repeticiones | Señaló 19/20, 22/23 y 25/26, mantuvo los registros y explicó que podrían quedar solo cinco fallos | Es una diferencia de interpretación de evidencia, no solo de formato |

## Qué aportó en concreto

El aporte más claro fue obligar a revisar los duplicados sin eliminarlos por decisión propia. Sin skill, el agente encontró los ocho fallos y el éxito posterior, pero no explicó que tres pares son idénticos. Con skill, aclaró que si fueran duplicaciones de captura quedarían cinco fallos y no se cumpliría R1. Eso cambia la confianza que puedo darle a la alerta.

También ayudó a mantener un formato fijo, citar las reglas y separar lo que dice el registro de lo que se puede concluir. No puedo atribuirle el ocultamiento del token ni el descubrimiento de las cuatro alertas: la condición sin skill también lo hizo. La selección contextual se comprobó por separado y tuvo una limitación de lectura.

Mantendría el skill y probaría después otro CSV, especialmente ventanas de exactamente cinco minutos y registros desordenados, antes de concluir que funciona igual de bien con otros archivos. Esta fue una comparación didáctica de una corrida por condición, no una prueba estadística.

## Evidencia y mediciones

| Condición | ID de sesión | Tokens de entrada | Tokens de salida |
|---|---|---:|---:|
| Sin skill | `01a1c6d8-c4c2-7ec0-90cc-8975af8d300a` | 17099 | 795 |
| Con skill | `01a1c6d8-c54a-7853-b356-a7dc252368ab` | 18752 | 1062 |

Estos valores vienen del evento `turn.completed` de cada JSONL. Incluyen contexto del entorno y no permiten comparar eficiencia del skill de forma aislada. Tiempo: no disponible; no se midió con un cronómetro comparable.

Las respuestas sin editar están en [sin-skill.md](evidencias/sin-skill.md) y [con-skill.md](evidencias/con-skill.md). Las trazas originales de salida, con una sustitución defensiva de los valores de token antes de guardarlas, están en [sin-skill.jsonl](evidencias/sin-skill.jsonl) y [con-skill.jsonl](evidencias/con-skill.jsonl). El procedimiento reproducible está en [ejecutar-pruebas.ps1](evidencias/ejecutar-pruebas.ps1).
