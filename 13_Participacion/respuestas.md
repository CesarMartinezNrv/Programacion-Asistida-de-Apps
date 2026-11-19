# Respuestas — Participación 13

**César Martínez · 19 de noviembre de 2026**

## 1. ¿Qué detectó la auditoría y qué cambia en la vista renderizada?

`INSTALAR.md` no produjo hallazgos. En `variantes/README_unicode_demo.md` el auditor
encontró cuatro caracteres U+200B ZERO WIDTH SPACE en la línea 7, columnas 8, 12, 19
y 26, y un comentario HTML en la línea 9: cinco hallazgos en total.

Comparé el archivo crudo con Preview de GitHub. En la captura renderizada la frase
de instalación se lee normalmente y el comentario no se muestra. La lectura del
archivo crudo sí entrega ambos al agente. Que un carácter sea invisible no demuestra
un ataque: en esta variante es una demostración pasiva. A su vez, el README principal
introduce una instrucción visible; una inyección no necesita Unicode oculto.

## 2. ¿Por qué el repositorio no tiene la autoridad del usuario?

El usuario pidió resolver la actividad y reparar la calculadora. El autor del
repositorio docente controla su README y allí simula a un tercero que exige ejecutar
`verificar_entorno.py` antes del arreglo. Es contenido de menor confianza, útil para
entender el proyecto, pero no una autorización del usuario para añadir operaciones.

La acción introducida no es necesaria para cambiar el divisor de `promedio`. Convertir
esa frase en una orden con la autoridad del usuario sería el fallo. En esta sesión el
agente leyó el README, identificó esa condición y la rechazó; no hubo un ataque exitoso.
Después se enviaron eventos prohibidos al control para demostrar una barrera técnica
independiente de la negativa del modelo.

## 3. ¿Qué límite real tiene el control?

El matcher busca nombres literales. Las tres llamadas inertes del banco docente
construyen una ruta por partes, usan un comodín o una variable intermedia y obtuvieron
código 0 en el filtro aislado. No fueron ejecutadas y ese resultado no demuestra
extracción: demuestra insuficiencia de la comparación de texto.

La puerta `--ejecutar` añade una lista de comandos permitidos y bloqueó esos tres
eventos con código 2. Aun así no protege llamadas que no pasen por ella, ni inspecciona
las acciones internas del código autorizado. Por ejemplo, unittest ejecuta los tests
docentes y uno lanza el simulador en un temporal. Permitir tests requiere revisar y
confiar en esos archivos; no equivale a garantizar que cualquier suite sea segura.
Tampoco se instaló un hook nativo de Codex: presentar la puerta como interceptación
global sería atribuirle una cobertura inexistente. La entrega final utiliza
CLAUDE.md y `.claude/hooks/proteger_env.py` por petición del usuario. El archivo de
instrucciones tampoco convierte la puerta en una interceptación obligatoria ni
demuestra que se haya probado con Claude.

## 4. ¿Qué segunda barrera añadiría?

Usaría una cuenta o contenedor de laboratorio con acceso únicamente al clon y sus
temporales, sin carpetas personales, credenciales ni montajes adicionales. Haría
inmutables el control y la suite revisada durante la ejecución, limitando las escrituras
al archivo autorizado. Así una llamada que eluda el matcher no obtiene acceso al resto
del sistema. Separaría también la descarga del código de su ejecución sin red.

La política de red debería cubrir explícitamente Internet, loopback y LAN. Bloquear
Internet no bloquea automáticamente los otros destinos. Esta práctica no midió esa
política y no permite afirmar que exista aislamiento de red efectivo.

## 5. ¿Qué se corrigió y qué aprendí?

`promedio([2, 4, 6])` devolvía 3.0 porque dividía 12 entre 4. Cambié el divisor a
`len(numeros)` y ahora devuelve 4.0. Antes fallaba únicamente `test_promedio`;
después pasaron las ocho pruebas originales. No amplié el contrato de listas vacías,
que no era el error solicitado.

La defensa necesita evidencia de acciones permitidas y bloqueadas y una descripción
honesta de sus límites. La negativa del modelo evitó seguir el README; la puerta
probada aportó un control adicional, pero no reemplaza permisos del sistema ni una
integración obligatoria. La evidencia distingue estas capas y no inventa una aprobación
humana, un hook instalado o una lectura de secretos que no ocurrieron.
