# Research

Investigación del stack realizada por subagente, como solicita speckit-plan; decisiones fijadas por Deber2.md.

| Decisión | Razón | Alternativa considerada |
|---|---|---|
| React useState | Una pantalla; datos editables como texto, error/resultado exclusivos | useReducer: innecesario para este alcance |
| Servicios ordinarios inyectados | useDivisor se importa estáticamente; no se pasa el hook por props | Context: innecesario con una pantalla |
| Vite 8 y Node 24.19.0 | Versión instalada cumple Node >= 22.12; lockfile reproducible | Vite anterior: sin necesidad |
| Vitest + jsdom | Entorno DOM para las pruebas React; globals y setupFiles explícitos | happy-dom: menor cobertura de APIs |
| Testing Library | Consultas por etiquetas/roles y eventos del usuario | Probar estado interno: no comprueba experiencia |
| Parseo de texto completo | Number sin filtro acepta vacío/hex; parseFloat acepta prefijos como 12abc | parseFloat solo: no satisface entradas inválidas |

Fuentes primarias: [useState](https://react.dev/reference/react/useState), [reglas de hooks](https://react.dev/reference/rules/react-calls-components-and-hooks), [Vite](https://vite.dev/guide/), [Vitest environments](https://vitest.dev/guide/environment.html), [jest-dom Vitest](https://github.com/testing-library/jest-dom#with-vitest), [Testing Library setup](https://testing-library.com/docs/react-testing-library/setup/), [ECMAScript parseFloat](https://tc39.es/ecma262/multipage/global-object.html#sec-parsefloat-string).
