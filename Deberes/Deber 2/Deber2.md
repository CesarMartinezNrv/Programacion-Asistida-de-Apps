# Deber 2 — SDD: cambiar la tecnología sin cambiar la especificación

**Programación Asistida de Aplicaciones · USFQ**
Prof. Jose David Vega Sánchez

---

## De qué se trata

En el laboratorio construiste el divisor de cuenta con SDD, en Flutter. Ahora el cliente
cambia de opinión:

> *"Ya no la quiero como app móvil. La quiero como página web, en React."*

En un flujo de **vibe coding donde las decisiones quedaron principalmente en los prompts y
en el código**, el agente tendrá que reconstruir muchas de ellas al cambiar de tecnología.
Con SDD, la hipótesis es que buena parte del **QUÉ** ya está externalizada en artefactos
reutilizables. No des por hecho el resultado: compruébalo con el repositorio.

## Pregunta central

> **Cuando cambia la tecnología, ¿qué parte del conocimiento del sistema sobrevive y qué
> parte debe reconstruirse?**

Como medida cuantitativa, estima **qué porcentaje de los enunciados de la especificación
pudo reutilizarse sin cambios**.

---

### ¿Qué significa "viajar"?

En este deber diremos que un artefacto **viaja** cuando puede reutilizarse después de
cambiar la tecnología de implementación.

| Resultado | Significado |
|---|---|
| **Viaja intacto** | Puede reutilizarse sin modificarlo. |
| **Viaja con adaptación** | Conserva la misma idea, pero necesita cambiar su redacción tecnológica. |
| **No viaja** | Depende de la implementación anterior y debe rehacerse. |

Ejemplos:

```
"El usuario puede cancelar una reserva"
Flutter → React
✅ Viaja intacto: el requisito no cambia. No depende de ninguna tecnología.

"El núcleo de negocio no depende del framework"
Flutter → React
⚠️ La idea viaja; la redacción puede adaptarse (por ejemplo, cambiar `package:flutter` por `react`).

"Usar Riverpod para administrar el estado"
Flutter → React
❌ No viaja: depende de una librería concreta de Flutter.
```

---

### Hipótesis que vamos a comprobar

```text
la especificación           →  debería cambiar poco       (es el QUÉ)
los criterios de aceptación →  deberían conservarse       (es el QUÉ)
los casos de prueba         →  deberían conservar su significado
la constitución             →  debería conservar principios, con redacción adaptada
el plan                     →  debería cambiar bastante  (es el CÓMO)
las tareas                  →  deberían cambiar bastante (es el CÓMO)
el código                   →  debería rehacerse          (es el CÓMO)
```

**Pero no lo des por hecho: vas a medirlo.** Si la spec no viaja, investiga si contiene
decisiones de implementación mezcladas con el **QUÉ**. Ese hallazgo también cuenta.

---

## Antes de empezar

### Lo que vamos a reutilizar

**Este deber no empieza de cero.** Vas a partir de la **rama `sdd` del laboratorio
anterior**, la que construiste con Spec Kit: su especificación, su constitución y sus
pruebas. Esa rama es el punto de partida, así que lo primero es comprobar que quedó bien
terminada.

```bash
cd divisor_cuenta
git checkout sdd
flutter test
```

Al final de esa salida debe decir **`All tests passed!`** y ninguna prueba marcada como
fallida. Eso significa que los seis escenarios de la spec, la prueba de LSP y las tres
pruebas de pantalla se ejecutaron y **todas dieron el resultado esperado**.

Si alguna falla, arréglala **antes** de empezar este deber. No tiene sentido migrar a otra
tecnología una app que todavía no cumple su propia especificación.

### Lo que necesitas instalar

| Herramienta | Para qué | ¿Ya la tienes? |
|---|---|---|
| **Node.js 22.12 o superior** | ejecutar React y sus herramientas | probablemente no |
| **npm** | instalar librerías de JavaScript | viene incluido con Node |
| **uv** | instalar Spec Kit | sí, lo hiciste en el laboratorio |
| Tu agente de código | **el mismo** que usaste en el laboratorio | sí |
| Un cronómetro | registrar el tiempo como dato descriptivo secundario | — |

### ¿Qué son Node.js y npm?

Como nunca los hemos usado en clase, va la explicación corta.

**Node.js** es un programa que permite **ejecutar JavaScript fuera del navegador**.
JavaScript nació para correr dentro de una página web; Node lo saca de ahí y lo deja
correr en tu computadora como cualquier otro lenguaje. Eso es lo que hace posible que
existan las herramientas de desarrollo de React: el servidor que levanta tu app mientras
programas, el empaquetador que la convierte en archivos listos para publicar, y el
ejecutor de pruebas.

**npm** (*Node Package Manager*) es su gestor de paquetes: descarga e instala las
librerías que tu proyecto necesita y las anota en un archivo. Es exactamente el mismo
papel que cumple `pub` en Flutter:

| En Flutter | En React / Node |
|---|---|
| `pubspec.yaml` (lista de dependencias) | `package.json` |
| `flutter pub get` (descargar) | `npm install` |
| `flutter run` (levantar la app) | `npm run dev` |
| `flutter test` (correr pruebas) | `npm test` |

> **Ojo con una confusión común:** Node **puede** usarse para escribir el backend de un
> sistema, y de hecho es muy usado para eso. Pero aquí **no lo vamos a usar como
> backend**: nuestra app no tiene servidor ni base de datos. Node está solamente porque
> las herramientas de React están escritas en JavaScript y necesitan algo que las ejecute.

### Instalar Node.js

> Usa **Node.js 22.12 o superior**. Se recomienda instalar una versión LTS vigente.
> Vite requiere Node.js 20.19+ o 22.12+; algunas plantillas pueden requerir una versión
> superior. Consulta los [requisitos actuales de Vite](https://vite.dev/guide/) y las
> [versiones LTS de Node.js](https://nodejs.org/en/about/previous-releases).

**Windows:**

```powershell
winget install OpenJS.NodeJS.LTS
```

Si ese comando instala una versión menor a 22.12, descarga una versión LTS vigente o
superior directamente desde <https://nodejs.org> y dale siguiente hasta el final.

**macOS:**

```bash
brew install node
```

O instala una versión LTS vigente desde <https://nodejs.org>.

**Linux (Ubuntu / Debian):**

Sigue las instrucciones de instalación para tu distribución desde <https://nodejs.org> y
verifica que la versión instalada cumpla el requisito de Vite.

**Verifica** (cierra y vuelve a abrir la terminal después de instalar):

```bash
node --version      # debe decir v22.x.x o superior
npm --version       # debe responder con un número
```

Si `node` no se reconoce, cierra VS Code por completo y ábrelo otra vez: la terminal
todavía tenía el PATH viejo.

### La bitácora

Antes de empezar la Parte 1, abre un archivo `bitacora.md` en la rama `sdd` del
laboratorio (no en el nuevo proyecto) y deja esta tabla vacía.

**¿Qué cuenta como iteración?** Una iteración es cada vez que le vuelves a dar una
instrucción al agente porque el resultado anterior no fue suficiente: un mensaje de
corrección, una aclaración, un "hazlo distinto". El primer prompt no cuenta.

### Cómo medir

- **Inicio:** cuando envías el primer prompt de planificación/implementación de React
  (`/speckit-plan`, Parte 5).
- **Primera compilación:** registra el tiempo transcurrido cuando `npm run build` termina
  correctamente por primera vez; no detengas el cronómetro.
- **Fin:** cuando los seis casos de aceptación pasan en React.
- **Iteración:** cada nuevo mensaje que envías al agente después del prompt inicial para
  pedir una corrección o un cambio. Los comandos o herramientas que el agente ejecute por su
  cuenta no cuentan.
- **Línea escrita a mano:** línea de código que modificas directamente tú, no una línea
  generada por el agente.

Registra el tiempo con el mismo criterio en cada versión. El tiempo es una métrica
descriptiva secundaria, no una medida de calidad ni una conclusión por sí sola. Interprétalo
junto con las demás métricas. Si no registraste el tiempo de Flutter, déjalo como
`no registrado`; no inventes una comparación.

| Métrica | Flutter (laboratorio) | React (este deber) |
|---|---:|---:|
| Minutos hasta la primera versión que compila | anota del laboratorio | registra el tiempo transcurrido; el cronómetro sigue corriendo |
| **Minutos hasta que pasan los 6 casos** | anota si lo registraste | mide desde el inicio definido arriba |
| Iteraciones con el agente | anota del laboratorio | cuenta con la misma regla |
| Líneas de código escritas a mano | anota si lo registraste | cuenta según la definición anterior |
| Enunciados modificados en la spec | — | completa en la Parte 8 |
| Enunciados modificados en la Constitution | — | completa en la Parte 8 |
| Líneas modificadas en el plan | — | completa en la Parte 8 |
| Casos de aceptación que pasan (0–6) | anota del laboratorio | completa en la Parte 7 |

Si no registraste alguna métrica durante el laboratorio, escribe `no registrado`; no la
estimes como si fuera un dato observado.

---

## Parte 1 — Ubica los artefactos de Spec Kit

Ya comprobaste arriba que `flutter test` termina con **`All tests passed!`**. Ahora
localiza los artefactos de Spec Kit del laboratorio y **léelos otra vez**:

```bash
# macOS / Linux / Git Bash en Windows
find specs \( -name "spec.md" -o -name "plan.md" -o -name "tasks.md" \)

# Windows PowerShell nativo
Get-ChildItem specs -Recurse -Include spec.md,plan.md,tasks.md | Select-Object FullName
```

La estructura habitual de Spec Kit separa la memoria del proyecto y los artefactos de cada
feature:

```text
proyecto/
├── .specify/
│   └── memory/
│       └── constitution.md
└── specs/
    └── <feature>/
        ├── spec.md
        ├── plan.md
        ├── tasks.md
        └── otros artefactos opcionales
```

Por tanto, busca la constitución en `.specify/memory/constitution.md` y la spec, plan y
tareas dentro de `specs/<feature>/`. **Anota la ruta exacta del feature correcto.** La ruta
puede variar según el proyecto y la versión; confirma lo que existe en tu repositorio.

---

## Parte 2 — Separa el QUÉ del CÓMO (a mano, tú)

Este es el ejercicio central del deber y va **antes** de tocar código.

### ¿Qué es un "enunciado"?

No contamos líneas físicas del archivo Markdown: contamos **enunciados atómicos**, es
decir, ideas que no se pueden partir sin perder sentido. Una viñeta larga con dos ideas
independientes son **dos** enunciados. Una regla de tres palabras es **uno**.

### La pregunta clave

Abre tu especificación y tu constitución, y ve enunciado por enunciado haciéndote **una
sola pregunta**:

> ### ¿Este enunciado seguiría siendo válido si la app estuviera hecha en React?

Esa pregunta separa sola las dos categorías:

| Si la respuesta es… | Entonces el enunciado es… | Significa |
|---|---|---|
| **Sí, sigue valiendo igual** | **QUÉ** | comportamiento, regla de negocio o criterio verificable |
| **No, deja de tener sentido** | **CÓMO** | decisión de implementación: tecnología, librería, carpeta o clase concreta |
| **La idea vale, pero la redacción debe cambiar** | **MIXTO** | principio reusable expresado con términos específicos de Flutter |

Fíjate en que la pregunta no es "¿esto suena técnico?". Hay reglas que suenan muy
técnicas y viajan perfecto; hay frases que suenan inocentes y no viajan.

### El ejemplo

| Enunciado | Tipo | ¿Viaja a React? | Por qué |
|---|---|:---:|---|
| "El usuario ingresa monto, número de personas y propina" | **QUÉ** | ✅ | Comportamiento del sistema |
| "El total se divide entre las personas incluyendo la propina" | **QUÉ** | ✅ | Regla de negocio |
| "Con 100 USD, 4 personas y 10% → 27.50 por persona" | **QUÉ** | ✅ | Criterio verificable |
| "La app debe validar que el monto sea mayor que cero" | **QUÉ** | ✅ | Regla funcional |
| "Toda funcionalidad crítica debe tener pruebas" | **QUÉ** | ✅ | Válida independientemente del framework |
| "Nunca guardar secretos en el repositorio" | **QUÉ** | ✅ | Restricción de seguridad |
| "Usar `lib/domain/`" | **CÓMO** | ❌ | Carpeta específica de Flutter |
| "Usar Riverpod" | **CÓMO** | ❌ | Librería concreta de Flutter |
| "Crear `HomePage extends ConsumerWidget`" | **CÓMO** | ❌ | Implementación Flutter |
| "Importar `package:flutter/material.dart`" | **CÓMO** | ❌ | Totalmente dependiente de Flutter |

> **Un caso intermedio:** la regla *"lib/domain no importa `package:flutter`"* contiene
> las dos cosas: la **idea** (el núcleo no debe depender del framework) se conserva; la
> **redacción** se adapta en React a *"src/domain no importa react"*. Clasifícala como
> **MIXTO** y explica que la idea viaja con adaptación.

> **La constitución no es la spec.** Analízalas por separado: la spec describe
> comportamiento externo; la constitución describe reglas de arquitectura y calidad. En
> la spec casi todo debería ser QUÉ; en la constitución vas a encontrar más reglas a
> adaptar (nombres de carpetas, tecnologías concretas).

### Tu tarea

Crea `analisis_spec.md` con una tabla de cuatro columnas para tus propios enunciados.
Mantén una sección para la spec y otra para la Constitution. Para la Constitution, clasifica
cada regla como **idéntica**, **adaptada en redacción** o **reemplazada**, y justifica la
decisión.

Usa esta tabla para analizar la spec (una fila por enunciado):

```markdown
| Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
|---|---|---|---|
| El total se divide entre las personas | QUÉ | Intacto | Regla de negocio independiente del framework |
| El núcleo no importa `package:flutter` | MIXTO | Adaptado | En React se expresa como no importar `react` |
| Usar Riverpod | CÓMO | No viaja | Librería específica de Flutter |
```

Para contar, usa cada **requisito, regla o criterio independiente** como un enunciado,
aunque ocupe varias líneas físicas en Markdown. Si separas una viñeta en dos ideas
independientes, cuenta dos enunciados.

Calcula el porcentaje de decisiones CÓMO de la spec así:

```text
% CÓMO = cantidad de enunciados clasificados como CÓMO
         ───────────────────────────────────────────── × 100
         total de enunciados analizados
```

Los enunciados MIXTOS se reportan aparte y no se cuentan como CÓMO en esta fórmula.

**¿Qué hago si descubro que necesito modificar la spec para React?**
No la modifiques todavía. Anota en `analisis_spec.md` exactamente qué enunciado
habría que cambiar y por qué. En la Parte 5, `/speckit-analyze` podría señalar la misma
contradicción. Documéntalo y explícalo en la pregunta 3.

**Cuenta el porcentaje.** En este deber, más del 30 % de enunciados CÓMO se considera una
spec contaminada de decisiones técnicas. El **30 % es un umbral pedagógico de este deber,
no una regla universal de SDD**. Si se supera, documenta el hallazgo en la pregunta 3.

---

## Parte 3 — El proyecto React

### 3.1 Crear el proyecto

Desde tu carpeta de proyectos (**un nivel arriba**, no dentro de `divisor_cuenta`):

```bash
npm create vite@latest divisor_cuenta_web -- --template react
cd divisor_cuenta_web
npm install
```

Abre **la carpeta del proyecto** en VS Code: **File → Open Folder… →
`divisor_cuenta_web`**.

Comprueba que arranca:

```bash
npm run dev          # Ctrl+C para cortarlo
```

### 3.2 Git

Igual que en el laboratorio, primero mira dónde estás parado:

```bash
git rev-parse --show-toplevel
```

Si da error: `git init`. Si devuelve una carpeta de más arriba, dale a este proyecto su
propio repositorio (`git init`) y agrega `divisor_cuenta_web/` al `.gitignore` de arriba.

```bash
git add .
git commit -m "proyecto react base, sin tocar"
```

### 3.3 Spec Kit en el proyecto nuevo

```bash
specify init .
```

Selecciona **el mismo agente** que usaste en el laboratorio.

> **Nota sobre comandos:** la sintaxis depende del agente y de la integración instalada.
> Puedes encontrar variantes como `/speckit.plan`, `/speckit-plan` o `$speckit-plan`.
> Usa la forma que tu agente haya instalado; los ejemplos de este documento muestran los
> nombres conceptuales de los pasos.

### 3.4 Importa la especificación — sin cambiarla

No vuelvas a ejecutar `specify`: reutiliza la spec existente. Primero localiza el feature
correcto en tu proyecto Flutter y anota la ruta exacta:

```bash
# macOS / Linux / Git Bash en Windows
find ../divisor_cuenta/specs -name spec.md
```

```powershell
# Windows PowerShell
Get-ChildItem ..\divisor_cuenta\specs -Recurse -Filter spec.md | Select-Object FullName
```

Elige el `spec.md` del feature del divisor de cuenta, no copies todos los archivos que
encuentres. Crea en el proyecto React un directorio para ese feature. En este ejemplo se
usa `specs/001-divisor-cuenta`; ajusta el nombre al feature que encontraste si corresponde.

**Git Bash:**

```bash
export SPECIFY_FEATURE_DIRECTORY="specs/001-divisor-cuenta"
mkdir -p "$SPECIFY_FEATURE_DIRECTORY"
cp "../divisor_cuenta/specs/001-divisor-cuenta/spec.md" \
  "$SPECIFY_FEATURE_DIRECTORY/spec.md"
```

**Windows PowerShell:**

```powershell
$env:SPECIFY_FEATURE_DIRECTORY = "specs/001-divisor-cuenta"
New-Item -ItemType Directory -Force -Path $env:SPECIFY_FEATURE_DIRECTORY
Copy-Item "..\divisor_cuenta\specs\001-divisor-cuenta\spec.md" `
  "$env:SPECIFY_FEATURE_DIRECTORY\spec.md"
```

Reemplaza la ruta de ejemplo de Flutter por la ruta real que localizaste. Mantén
`SPECIFY_FEATURE_DIRECTORY` configurada en la terminal **antes de abrir el agente**, para
que los comandos de Spec Kit usen el feature copiado. Spec Kit admite esta variable de
entorno para seleccionar el directorio activo; si tu integración ya lo resolvió de otra
manera, confirma que apunta al feature correcto. En ningún caso vuelvas a ejecutar
`/speckit-specify` en este deber.

**Verifica que el contenido es idéntico** antes de planificar (reemplaza ambas rutas por
las reales):

```text
Git Bash:
git diff --no-index -- "../divisor_cuenta/specs/001-divisor-cuenta/spec.md" \
  "$SPECIFY_FEATURE_DIRECTORY/spec.md"

PowerShell:
git diff --no-index -- "..\divisor_cuenta\specs\001-divisor-cuenta\spec.md" `
  "$env:SPECIFY_FEATURE_DIRECTORY\spec.md"
```

Debe salir **vacío**. Si sale algo, o copiaste el archivo equivocado, o ya empezaste a
modificar el QUÉ — ninguna de las dos opciones es correcta en este punto.

```bash
git add . && git commit -m "spec kit + la misma spec del proyecto flutter"
```

Si más adelante descubres que la spec contiene una decisión Flutter que impide planificar
React, **no alteres esta copia inicial sin dejar rastro**. Sigue el protocolo de la Parte 2:
documenta el enunciado, explica por qué es CÓMO, guarda la evidencia del diff inicial vacío y
haz cualquier corrección en un commit separado. Conserva el antes y el después.

---

## Parte 4 — La constitución también viaja

No clasifiques la Constitution exactamente como la spec. Para la spec usamos **QUÉ / CÓMO
/ MIXTO**. Para la Constitution, clasifica cada regla como **idéntica**, **adaptada en
redacción** o **reemplazada**.

| Regla de ejemplo | Clasificación al pasar de Flutter a React |
|---|---|
| Nunca guardar secretos en Git | Idéntica |
| `domain` no depende del framework (`package:flutter` → `react`) | Adaptada en redacción; la idea se conserva |
| Usar Riverpod | No debería estar en una Constitution general; si existe como restricción permanente, documenta si debe reemplazarse |

Adapta únicamente la redacción tecnológica y conserva los principios originales. No
introduzcas reglas nuevas sin una razón que puedas justificar.

### ▶ Pídeselo al agente

```text
/speckit-constitution Crea la constitución de este proyecto con estos principios,
sin inventar otros:

CALIDAD DE CÓDIGO
- El código respeta SOLID:
  * SRP: una función o módulo, una razón de cambio. El cálculo no valida ni formatea.
  * OCP: agregar una nueva regla de redondeo no obliga a editar los módulos
    que ya existen.
  * LSP: cualquier implementación de la interfaz de redondeo puede sustituir
    a otra sin que quien la usa pregunte de qué tipo es.
  * ISP: interfaces pequeñas; nadie depende de funciones que no usa.
  * DIP: presentation depende de abstracciones del domain, nunca de
    implementaciones concretas de data.

ARQUITECTURA
- Capas: src/presentation / src/domain / src/data.
- Regla de dependencia: presentation -> domain <- data.
- src/domain/ NO importa react ni nada del DOM: es JavaScript puro.
- src/main.jsx es el ÚNICO lugar donde se instancian implementaciones concretas.

SEGURIDAD
- Nunca guardar secretos ni API keys en el repositorio.

CALIDAD Y PRUEBAS
- Toda funcionalidad crítica tiene pruebas.
- Los criterios de aceptación de la spec se convierten en pruebas ejecutables.

REGLA DE LA MATERIA
- Toda función generada por el agente debe poder explicarla el estudiante:
  qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.
```

**Verifica:** usando tu `analisis_spec.md`, compara regla por regla esta Constitution con
la de Flutter. Marca cada regla como idéntica, adaptada en redacción o reemplazada. Si una
regla fue reemplazada, explica por qué la regla original no se puede conservar; si aparece
una regla nueva sin equivalente, determina si es necesaria o si el agente la inventó.

---

## Parte 5 — El plan: esto sí se rehace entero

**No corras `/speckit-specify`.** La spec ya está y no se toca. Empiezas directo en el
plan, que es donde vive el CÓMO.

### ▶ Pídeselo al agente

```text
/speckit-plan Lee la spec del feature activo en `SPECIFY_FEATURE_DIRECTORY`. NO la modifiques.

Implementación en React con Vite, JavaScript, sin librerías de estado externas.
Estado local con useState (es una sola pantalla).

Capas, respetando la constitución:
- src/domain/      : cuenta.js, resultado.js, calcularDivision.js,
                     validarEntrada.js y estrategiaRedondeo.js
                     (el contrato: una función aplicar(valor))
- src/data/        : redondeoExacto.js y redondeoHaciaArriba.js
- src/presentation/: useDivisor.js (hook que RECIBE sus dependencias),
                     formateadorMoneda.js y PantallaDivisor.jsx
- src/main.jsx     : único punto de composición

Pruebas con Vitest.
```

Luego:

```text
/speckit-tasks
```

```text
/speckit-analyze
```

**Verifica:** `/speckit-analyze` no debería encontrar contradicciones entre la spec (que
no tocaste) y el plan nuevo. Si las encuentra, léelas: te está diciendo que la spec tenía
supuestos de Flutter escondidos. Eso es material para la pregunta 3.

```bash
git add . && git commit -m "plan y tareas para react (la spec no se toco)"
```

---

## Parte 6 — Implementar y converger

### ▶ Pídeselo al agente

```text
/speckit-implement
```

Déjalo trabajar tarea por tarea. Cuando termine, revisa si tu versión de Spec Kit tiene el
comando `/speckit-converge`:

```text
/speckit-converge
```

Si está disponible, ejecútalo y revisa las brechas frente a la spec. Si quedan brechas,
corrige la implementación y vuelve a converger; repite hasta resolverlas. El flujo es:

```text
implementar → converger → ¿quedan brechas? → sí: corregir y converger otra vez
                                      └───── no: validar con pruebas
```

Si tu versión no ofrece el comando, anótalo en la bitácora y verifica los criterios con las
pruebas.

**Verifica a ojo** la estructura que debería haber quedado:

```text
src/
├── domain/
│   ├── cuenta.js
│   ├── resultado.js
│   ├── estrategiaRedondeo.js      el contrato (ISP: una función)
│   ├── calcularDivision.js        SRP: solo calcula
│   └── validarEntrada.js          SRP: solo valida
├── data/
│   ├── redondeoExacto.js          OCP/LSP
│   └── redondeoHaciaArriba.js     OCP/LSP
├── presentation/
│   ├── useDivisor.js              DIP: recibe sus dependencias
│   ├── formateadorMoneda.js       SRP: solo formatea
│   └── PantallaDivisor.jsx        solo dibuja
└── main.jsx                       único punto de composición
```

---

## Parte 7 — Los mismos seis casos, otro runner

Los casos de prueba **son los mismos**: salen de la spec, y la spec no cambió. Lo único
que cambia es la herramienta que los ejecuta.

### 7.1 Configura Vitest

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom jsdom
```

Instalar jsdom **no lo activa**: hay que decirle a Vite que lo use. Abre `vite.config.js`
y agrégale la sección `test`:

```javascript
// vite.config.js
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./test/setup.js'],
  },
})
```

Crea el archivo de setup:

```javascript
// test/setup.js
import '@testing-library/jest-dom/vitest'
```

Agrega el script en `package.json`:

```json
"scripts": {
  "dev": "vite",
  "build": "vite build",
  "test": "vitest run"
}
```

### 7.2 Traduce el archivo de casos — solo la sintaxis

Este archivo es la copia conceptual del de Flutter. Los números y los mensajes deben ser
**exactamente iguales**. Escríbelo **tú**, a mano: es corto y es la prueba de que el QUÉ
no cambió.

```javascript
// test/casosDePrueba.js
// Los casos salen de la spec. Son EXACTAMENTE los mismos que en la versión Flutter.

export const casos = [
  { nombre: '1. reparto normal',
    monto: 100.00, personas: 4, propina: 10, modo: 'exacto', esperado: 27.50 },

  { nombre: '2. sin propina',
    monto: 90.00, personas: 3, propina: 0, modo: 'exacto', esperado: 30.00 },

  { nombre: '3. cero personas',
    monto: 50.00, personas: 0, propina: 0, modo: 'exacto',
    errorEsperado: 'Debe haber al menos una persona' },

  { nombre: '4. monto no numerico',
    monto: NaN, personas: 4, propina: 0, modo: 'exacto',
    errorEsperado: 'Monto inválido' },

  { nombre: '5. redondeo exacto',
    monto: 10.00, personas: 3, propina: 0, modo: 'exacto', esperado: 3.33 },

  { nombre: '6. redondeo hacia arriba',
    monto: 10.00, personas: 3, propina: 0, modo: 'arriba', esperado: 4.00 },
]
```

### 7.3 El archivo que corre y verifica

### ▶ Pídeselo al agente

```text
Lee test/casosDePrueba.js. Crea test/division.test.js con Vitest que:

1. Recorra el arreglo `casos` con un bucle y genere un it() por cada uno,
   usando caso.nombre como nombre de la prueba.
2. Para cada caso: valide la entrada con validarEntrada, y
   - si el caso tiene errorEsperado, verifique que la validación devuelve
     exactamente ese mensaje y que NO se calcula nada;
   - si el caso tiene esperado, ejecute calcularDivision con la estrategia
     de redondeo que corresponda al campo modo y compare con
     toBeCloseTo(esperado, 2).
3. Agregue una prueba aparte que demuestre LSP: el mismo calcularDivision
   recibe redondeoExacto y luego redondeoHaciaArriba sin ningún if ni
   comprobación de tipo, y funciona con los dos.

NO importes react aquí: estas pruebas son del domain puro.
El entorno de pruebas ya está configurado con jsdom en vite.config.js.
Corre npm test y arregla lo que falle en src/, nunca en test/.
```

### 7.4 Una prueba de la pantalla

### ▶ Pídeselo al agente

```text
Crea test/pantalla.test.jsx con Testing Library y tres pruebas:

1. Ingreso 100, 4 y 10, hago clic en "Calcular" y aparece "27.50" en pantalla.
2. Ingreso 50 y 0 personas, hago clic en "Calcular" y aparece
   "Debe haber al menos una persona", y NO aparece ningún resultado numérico.
3. Ingreso "abc" en el monto, hago clic en "Calcular" y aparece "Monto inválido".

El entorno jsdom ya está configurado en vite.config.js y test/setup.js.
```

### 7.5 Corre todo

Primero corre la suite de dominio. **Detén el cronómetro cuando los seis casos de aceptación
estén en verde**; luego continúa con todas las verificaciones restantes.

```bash
npx vitest run test/division.test.js
```

Después ejecuta toda la suite:

```bash
npm test
```

Los seis casos tienen que dar los mismos resultados que en Flutter. Si alguno da distinto,
no es "porque React es diferente": es que la implementación no cumple la spec.

### 7.6 Verifica SOLID

Los comandos `grep` y `diff` se comportan distinto en Windows y macOS. Usa `git grep`,
que funciona igual en todas las plataformas dentro de un repositorio:

```bash
# DIP + capas: el domain no puede saber que existe React
git grep -n "from 'react'" -- src/domain/        # NO debe salir nada

# DIP: solo main.jsx instancia implementaciones concretas
git grep -n "redondeoExacto\|redondeoHaciaArriba" -- src/
# fuera de src/data/, debe aparecer SOLO en src/main.jsx

# OCP/LSP: calcularDivision no pregunta de qué tipo es la estrategia
git grep -n "instanceof\|=== 'exacto'\|=== 'arriba'" -- src/domain/calcularDivision.js
# NO debe salir nada

# SRP: el cálculo no formatea ni valida
git grep -n "toFixed\|inválido\|al menos una persona" -- src/domain/calcularDivision.js
# NO debe salir nada
```

### 7.7 Compila la app

Antes de entregar, verifica que el resultado final también se puede empaquetar:

```bash
npm run build
```

Debe terminar sin errores. Si hay errores de TypeScript o de imports rotos, arréglalo
antes de hacer el último commit.

```bash
git add . && git commit -m "divisor de cuenta en react, los 6 casos pasan"
```

---

## Parte 8 — Medir cuánto viajó

Esta es la entrega que realmente importa.

### 8.1 La spec

Compara la spec Flutter original con la copia React usando la ruta real del feature activo.
En Git Bash:

```bash
git diff --no-index \
  ../divisor_cuenta/specs/001-divisor-cuenta/spec.md \
  "$SPECIFY_FEATURE_DIRECTORY/spec.md"
```

En PowerShell puedes hacer la misma comparación con las rutas reales:

```powershell
git diff --no-index -- "..\divisor_cuenta\specs\001-divisor-cuenta\spec.md" `
  "$env:SPECIFY_FEATURE_DIRECTORY\spec.md"
```

Reemplaza la ruta de ejemplo por las rutas reales. Para comprobar la copia inicial, el diff
debe estar **vacío**. Guarda esa evidencia y pégala en tus respuestas. Estima qué porcentaje
de los enunciados de la spec pudo reutilizarse sin cambios.

Si el plan React revela que un enunciado dependía de Flutter y bloquea la migración, sigue el
protocolo:

1. Conserva la copia inicial y la evidencia del diff vacío.
2. Documenta en `analisis_spec.md` el enunciado y por qué era CÓMO.
3. Intenta planificar React con la copia original y registra la contradicción.
4. Corrige el enunciado solo después de documentarlo, en un commit separado.
5. Muestra el antes y el después y explica la adaptación.

### 8.2 Los casos de prueba

Los escenarios de aceptación **se conservan**. La sintaxis y el archivo del runner pueden
cambiar porque Flutter usa Dart y `flutter_test`, mientras React usa JavaScript y Vitest.
Los escenarios viajan; el archivo físico de pruebas no tiene que viajar byte por byte.

Compara `test/casos_de_prueba.dart` (Flutter) con `test/casosDePrueba.js` (React). Comprueba
si cambiaron las entradas, los valores esperados, los mensajes de error, los escenarios o las
reglas de negocio. No compares si los archivos tienen sintaxis idéntica.

### 8.3 El plan

Busca el plan de Flutter en tu proyecto anterior y compáralo con el de React:

```bash
git diff --no-index \
  ../divisor_cuenta/specs/001-divisor-cuenta/plan.md \
  "$SPECIFY_FEATURE_DIRECTORY/plan.md"
```

En PowerShell, sustituye las rutas de ejemplo por las reales:

```powershell
git diff --no-index -- "..\divisor_cuenta\specs\001-divisor-cuenta\plan.md" `
  "$env:SPECIFY_FEATURE_DIRECTORY\plan.md"
```

Aquí deberían cambiar las decisiones tecnológicas. Pega la salida y explica qué partes
dejaron de tener sentido al migrar a React. Para la bitácora, cuenta los enunciados del plan
que modificaste, no las líneas físicas que ocupan.

### 8.4 El tiempo

Termina de llenar la bitácora, incluidos los cambios de enunciados en spec y Constitution y
las líneas del plan. Reporta el tiempo con el criterio fijado al inicio; no lo uses por sí
solo para concluir qué enfoque es mejor.

---

## Preguntas

Responde en `respuestas.md`, dentro del repositorio del proyecto React.

1. ¿Qué porcentaje de la spec viajó intacto, qué porcentaje necesitó adaptación y qué
   porcentaje no pudo reutilizarse? Justifica la clasificación con `analisis_spec.md` y el
   diff. Si registraste tiempo, inclúyelo como contexto, no como criterio único de calidad.

2. En la Constitution, clasifica cada regla como **idéntica**, **adaptada en redacción** o
   **reemplazada**. Explica por qué y cita evidencia de ambas constituciones.

3. ¿Tuviste que modificar algún enunciado de la spec para implementar React? Si sí:
   transcribe la versión original, explica qué decisión técnica se había mezclado con el QUÉ,
   muestra la versión corregida y enlaza la evidencia del cambio separado. Si no, explica qué
   permitió reutilizar la spec sin cambios.

4. Compara los seis casos de aceptación de Flutter y React. ¿Cambió algún valor esperado,
   mensaje o escenario? Si cambió, explica si fue necesario por la tecnología o si fue un
   error de diseño/implementación.

5. ¿Qué partes del plan Flutter dejaron de tener sentido en React? Da al menos tres ejemplos
   concretos y explica cómo se adaptaron.

6. ¿Qué artefacto fue el más reusable y cuál el menos reusable? Justifica ambas respuestas
   con evidencia del repositorio (diffs, archivos, pruebas o historial de Git).

---

## Antes de entregar

- [ ] Los dos proyectos subidos a GitHub: `divisor_cuenta` (Flutter) y
      `divisor_cuenta_web` (React).
- [ ] Node.js es 22.12 o superior y se recomienda una versión LTS vigente.
- [ ] La Constitution de Flutter está en `.specify/memory/constitution.md`.
- [ ] La spec, el plan y las tareas están dentro de `specs/<feature>/`.
- [ ] `SPECIFY_FEATURE_DIRECTORY` apunta al feature React que reutiliza la spec.
- [ ] No se volvió a ejecutar `/speckit-specify`.
- [ ] La spec React comenzó como copia idéntica de la spec Flutter y hay evidencia del diff inicial vacío.
- [ ] Si la spec se tuvo que adaptar, se documentaron el motivo, el antes y el después, y el cambio quedó en un commit separado.
- [ ] `analisis_spec.md` clasifica enunciados (no líneas físicas) de la spec y evalúa la Constitution por separado.
- [ ] El 30 % se presenta como umbral pedagógico de este deber, no como regla universal.
- [ ] El plan React y las tareas se generaron sin volver a ejecutar `specify`.
- [ ] `/speckit-analyze` se ejecutó.
- [ ] `/speckit-converge` se ejecutó si está disponible en la versión instalada.
- [ ] `npm test` termina con todas las pruebas pasando: los 6 casos + la de LSP + las 3
      de pantalla.
- [ ] `npm run build` termina sin errores.
- [ ] El tiempo se detuvo cuando los seis casos de aceptación estuvieron en verde.
- [ ] `analisis_spec.md` cuenta enunciados y explica el porcentaje QUÉ/CÓMO/MIXTO.
- [ ] La constitución del proyecto React tiene los cinco principios SOLID.
- [ ] `git grep "from 'react'" -- src/domain/` no devuelve nada.
- [ ] Las implementaciones concretas de redondeo solo aparecen en `src/main.jsx`.
- [ ] Se compararon los escenarios y el significado de las pruebas, no la identidad byte por byte de sus archivos.
- [ ] `respuestas.md` con las seis respuestas, la bitácora llena y todas las salidas
      pegadas.

---

## Nota final

SDD intenta separar el conocimiento estable del sistema —el **QUÉ**— de las decisiones de
implementación —el **CÓMO**. Cuando cambia la tecnología, esa separación debería permitir
reutilizar requisitos, criterios y reglas de negocio, mientras se rehacen principalmente el
plan, las tareas y el código. Compruébalo con diffs, métricas, pruebas, historial de Git y
comparación de artefactos; no aceptes esa afirmación sin evidencia.
