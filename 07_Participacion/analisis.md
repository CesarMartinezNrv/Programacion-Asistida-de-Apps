# Análisis de la participación 7
Fecha: 1 de octubre de 2026.

## Qué pide el ejercicio
Construir la misma app Flutter dos veces y comparar el proceso, el comportamiento y la
mantenibilidad. No se busca demostrar científicamente que una metodología sea superior.

La app divide una cuenta: monto × (1 + propina / 100) / personas.
Ejemplo: 100 con 10% entre cuatro da 27.50. La versión SDD ofrece exacto a centavos y
hacia arriba al entero: 10 entre tres da 3.33 o 4.00, según el modo.

## Entregables
- main: proyecto base, este análisis y respuestas.md con las seis preguntas.
- vibe: implementación conversacional sencilla.
- sdd: implementación guiada por Spec Kit, AGENTS.md, constitución, spec, plan, tareas,
  análisis previo y convergencia.
- Pruebas de seis casos, sustitución LSP y pantalla.
- Evidencias de análisis estático, pruebas, build APK, comparación y SOLID.
- Las tres ramas del repositorio existente, publicadas en GitHub.

## Organización acordada
Repositorio existente: C:\Programacion de apps.
Proyecto: 07_Participacion/divisor_cuenta.
Git caso C: el proyecto vive dentro de un repositorio padre. Por tu indicación se usa ese
repositorio, sin uno nuevo. Las dos ramas nacen de 3b38a52, el proyecto Flutter sin modificar.
Cambiar rama cambia la vista del repositorio entero, pero los commits de esta actividad
solo modifican 07_Participacion. Los archivos ajenos que ya estaban sin seguimiento se
conservaron fuera de los commits.

## Qué se ejecutó
1. Crear Flutter 3.47.1, Dart 3.13.1 y guardar la base común.
2. Crear vibe y sdd, implementar primero vibe en un archivo.
3. Instalar uv y specify-cli 1.0.13 localmente en .herramientas, sin cambiar herramientas
   globales ni crear otro repositorio.
4. Inicializar Spec Kit con integración Codex y scripts PowerShell.
5. Aplicar sus skills: constitution, specify, clarify, plan, tasks, analyze, implement, converge.
6. Incorporar tus respuestas: aceptar cero/rechazar negativos; aceptar coma y punto.
7. Implementar 11 archivos Dart en lib y escribir las pruebas solicitadas.
8. Verificar 18 pruebas, análisis sin issues, APK Android y seis escenarios en la interfaz.
9. Copiar las pruebas de sdd temporalmente a vibe, observar incompatibilidad de contratos
   y restaurar test/; comprobar los escenarios de vibe en el navegador.
10. Redactar respuestas y guardar las evidencias.

Las skills son instrucciones que ejecuta el agente: specify instala la estructura,
no genera ni programa por sí solo. Se usó su integración real; no se crearon plantillas
falsas para simular una instalación.

## Por qué se divide la versión SDD en capas
| Capa | Responsabilidad | Puede depender de |
|---|---|---|
| domain | Cuenta, Resultado, validación, cálculo e interfaz de redondeo | Dart |
| data | Estrategias exacta y hacia arriba | domain |
| presentation | Texto, controller y widgets | domain, Flutter en la pantalla |
| main.dart | Conectar servicios concretos | todas, como punto de composición |

SOLID se verifica con responsabilidades separadas, una interfaz pequeña, sustitución
sin casts y nuevas estrategias que no obligan a editar el cálculo.
La tabla que explica cada función está en el README de la rama sdd.

## Resultado observado
| Comprobación | vibe | sdd |
|---|---|---|
| Seis escenarios en interfaz | 5/6 | 6/6 |
| Pruebas propias | 1 pasa | 18 pasan |
| flutter analyze | sin issues | sin issues |
| APK debug | no se exigió para vibe | construído |
| Pruebas SDD reutilizadas en vibe | no compilan por clases ausentes | pasan |

Windows bloqueó el tester en la primera ejecución de vibe. Una ejecución posterior
nativa funcionó en ambas ramas. Los intentos Chrome/Edge de la suite quedaron en carga
y se detuvieron; no se cuentan como tests aprobados. La interfaz sí se comprobó con
servidores web locales. El bloqueo de entorno no se confundió con un fallo de la app.

## Limitaciones de la comparación
El mismo agente leyó toda la guía antes de generar vibe; no fue un experimento ciego.
No hubo dos conversaciones nuevas con solicitudes iniciales independientes.
Los mensajes sobre carpetas, repositorio y continuación se registran por transparencia,
pero no miden correcciones funcionales. Por eso el conteo no demuestra productividad.

El resultado 5/6 de vibe no significa que el enfoque no pueda alcanzar 6/6: significa
que esta implementación no incorporó el redondeo hacia arriba. Más contexto o una
iteración podría añadirlo.

## Cómo abrir cada versión
En PowerShell:
```powershell
cd 'C:\Programacion de apps'
git switch sdd
cd '.\07_Participacion\divisor_cuenta'
flutter run -d chrome
```
Para vibe, sustituir sdd por vibe. Para leer la entrega, volver a main.
Desde el proyecto sdd:
```powershell
flutter analyze
flutter test --reporter expanded
flutter build apk --debug
```
APK local conservado: 07_Participacion/.herramientas/app-sdd-debug.apk.
El archivo build/app/outputs/flutter-apk/app-debug.apk se puede regenerar con el comando.
Los binarios y herramientas locales no se suben a Git; sí las fuentes y evidencias.

