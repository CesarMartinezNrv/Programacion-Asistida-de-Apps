**Programación Asistida de Aplicaciones — USFQ**

## Objetivo

Generar con una herramienta de IA una pantalla Flutter **deliberadamente sin separación de
responsabilidades**, con el propósito de auditar posteriormente su diseño utilizando los criterios
estudiados durante la semana: **responsabilidad única, inversión de dependencias, cohesión y
acoplamiento**.

A partir de esa primera implementación, se realizará una refactorización progresiva hacia una
arquitectura de tres capas: `domain`, `data` y `presentation`.

Todo el código será generado con asistencia de IA. El trabajo del estudiante consiste en formular
adecuadamente las instrucciones, comprender el código generado, identificar problemas estructurales
y decidir de manera fundamzentada qué propuestas de la IA deben aceptarse, modificarse o
rechazarse.

## Preliminares

- Crear un proyecto Flutter nuevo para esta actividad y abrirlo en VS Code.
- Crear una rama de trabajo:

```bash
git switch -c refactor/capas
```

- Tener disponible un asistente de IA en el editor.

---

## Parte 1 — Generación deliberada de una implementación sin separación de responsabilidades

La estructura deficiente es intencional: se necesita un caso concreto para poder auditarlo.
Solicitar a la IA:

> "Escribe una pantalla Flutter que liste usuarios obtenidos desde
> `https://jsonplaceholder.typicode.com/users`. Mantén en la misma pantalla y en el mismo archivo la
> llamada HTTP, el `jsonDecode`, el filtrado de usuarios cuyo nombre empieza con vocal y la
> construcción de la interfaz. No crees repositorios, servicios, casos de uso ni capas adicionales.
> El código debe funcionar, aunque deliberadamente tenga varias responsabilidades mezcladas."

Ejecutar la aplicación y verificar que funciona. Conservar el archivo tal como fue generado: es el
archivo con el que se trabajará.

Conceptualmente, la implementación inicial se ve así:

```text
Pantalla
├── llamada HTTP
├── parseo JSON
├── regla de negocio
└── interfaz
```

**Responder:**

1. ¿Qué responsabilidades distintas conviven dentro de la pantalla? Nombrarlas.
2. Si cambia la URL de la API, ¿por qué una modificación relacionada con acceso a datos obliga
   también a modificar el archivo que contiene la interfaz? ¿Qué problema de diseño evidencia esto?
3. ¿Puede probarse la regla "el nombre empieza con vocal" sin ejecutar la interfaz Flutter? Explicar
   por qué.

---

## Parte 2 — Auditoría del diseño

Solicitar a la IA una lectura crítica, **sin que modifique nada todavía**:

> "No modifiques el código. Solo revísalo e indica en qué puntos concretos rompe el principio de
> responsabilidad única y el de inversión de dependencias. Cita la línea correspondiente."

Contrastar la respuesta de la IA con la auditoría propia.

> No aceptar la auditoría de la IA sin verificarla. Es frecuente que señale problemas de estilo y
> pase por alto los estructurales, o al revés.

**Responder:**

4. En términos de **cohesión**: ¿qué responsabilidades están agrupadas en el mismo archivo aunque no
   pertenecen al mismo propósito?
5. En términos de **acoplamiento**: si los usuarios dejaran de obtenerse por HTTP y pasaran a
   obtenerse desde una base de datos local, ¿qué partes de la pantalla tendrían que modificarse?
   ¿Qué indica esto sobre el nivel de acoplamiento?

Las dependencias que deberían identificarse son de este tipo:

```text
UI ──> http
UI ──> jsonDecode
UI ──> API concreta
```

---

## Parte 3 — Refactorización progresiva

Solicitar **un paso por vez** y revisar el resultado antes de continuar. Pedir la refactorización
completa en una sola instrucción produce una reescritura que no puede auditarse.

### Paso 1 · Capa `domain`

> "Crea tres archivos y no implementes todavía ningún acceso a datos:
> `lib/domain/entities/usuario.dart` con una clase `Usuario` (id, nombre, email);
> `lib/domain/repositories/usuario_repository.dart` con una clase abstracta `UsuarioRepository` que
> declare `Future<List<Usuario>> obtener()`; y
> `lib/domain/usecases/obtener_usuarios_con_vocal.dart` con una clase `ObtenerUsuariosConVocal` que
> reciba un `UsuarioRepository`, solicite los usuarios y devuelva únicamente aquellos cuyo nombre
> empieza con A, E, I, O o U, ignorando mayúsculas y minúsculas. La capa domain no debe importar
> Flutter, http ni dart:convert."

La regla de negocio se ubica aquí porque no pertenece ni a la interfaz ni al acceso a datos.

### Paso 2 · Capa `data`

> "Crea `lib/data/repositories/usuario_api.dart` con una clase `UsuarioApi` que implemente
> `UsuarioRepository`. Debe encargarse únicamente de la llamada HTTP, la URL de la API, el
> `jsonDecode` y la conversión del JSON a objetos `Usuario`. No debe aplicar el filtro por vocal."

`data` resuelve **cómo se obtienen los datos**; `domain` decide **qué regla de negocio se aplica**.

### Paso 3 · Capa `presentation`

> "Modifica la pantalla para que reciba `ObtenerUsuariosConVocal` por constructor, solicite los
> datos a ese caso de uso, maneje los estados de carga y error, y muestre la lista. La pantalla no
> debe importar http ni dart:convert, no debe conocer la URL, no debe crear `UsuarioApi` ni aplicar
> el filtro por vocal."

```text
PRESENTATION
      ↓
   USE CASE
      ↓
UsuarioRepository
      ↑
      │ implementa
      │
   UsuarioApi
```

### Paso 4 · Composición de dependencias en `main.dart`

> "Modifica `main.dart` para que sea el punto donde se construyen las dependencias: crea
> `UsuarioApi`, constrúyelo dentro de `ObtenerUsuariosConVocal` e inyecta ese caso de uso en la
> pantalla."

> `main.dart` actúa como punto de composición: conoce las implementaciones concretas y las conecta.
> La presentación recibe sus dependencias ya construidas y no decide cómo obtener los datos.

**Responder:**

6. ¿En qué capa quedó la regla "mostrar únicamente usuarios cuyo nombre empieza con vocal"?
   Justificar por qué pertenece allí y no a `data` ni a `presentation`.
7. Antes del refactor, ¿de qué detalles concretos dependía la pantalla? ¿Qué dependencias concretas
   desaparecieron de la presentación después del refactor?

---

## Parte 4 — Sustitución de la implementación concreta

Una refactorización solo se justifica si algo se vuelve efectivamente más fácil. Comprobarlo:

> "Crea `lib/data/repositories/usuario_memoria.dart` con una clase `UsuarioMemoria` que también
> implemente `UsuarioRepository` y devuelva una lista fija de tres usuarios, sin usar red."

```text
             UsuarioRepository
               ↑          ↑
               │          │
        UsuarioApi   UsuarioMemoria
```

A continuación:

> "Sustituye `UsuarioApi` por `UsuarioMemoria` únicamente en el punto donde se construyen e inyectan
> las dependencias (`main.dart`). No modifiques la pantalla ni el caso de uso."

```text
ANTES                          DESPUÉS

main.dart                      main.dart
   ↓                              ↓
UsuarioApi                     UsuarioMemoria
   ↓                              ↓
ObtenerUsuariosConVocal        ObtenerUsuariosConVocal
   ↓                              ↓
Pantalla                       Pantalla   (intacta)
```

Ejecutar la aplicación y verificar que sigue funcionando.


---

## Parte 5 — Cierre

Registrar el trabajo en la rama:

```bash
git add .
git commit -m "refactor: separa la pantalla de usuarios en tres capas"
```

**Responder:**

8. Indicar al menos una propuesta generada por la IA durante la actividad que se decidió **no
    aceptar tal como fue entregada**. Explicar qué se modificó o rechazó y por qué.

---

## Resultado arquitectónico esperado

```text
                    main.dart
               composición/inyección
                        │
                        ↓
                  presentation
                 PantallaUsuarios
                        │
                        ↓
                     domain
             ObtenerUsuariosConVocal
                        │
                        ↓
                UsuarioRepository
                   ↑         ↑
                   │         │
              UsuarioApi  UsuarioMemoria
                   \         /
                      data
```

La dependencia conceptual apunta siempre hacia `domain`.

Estructura de archivos resultante:

```text
lib/
├── domain/
│   ├── entities/
│   │   └── usuario.dart
│   ├── repositories/
│   │   └── usuario_repository.dart
│   └── usecases/
│       └── obtener_usuarios_con_vocal.dart
├── data/
│   └── repositories/
│       ├── usuario_api.dart
│       └── usuario_memoria.dart
├── presentation/
│   └── ...
└── main.dart
```

---

