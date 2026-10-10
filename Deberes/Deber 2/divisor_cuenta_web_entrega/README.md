# Divisor de cuenta web - Deber 2

React + Vite + JavaScript; estado local con useState. Una pantalla offline durante uso, sin almacenamiento ni backend.

```powershell
npm ci
npm run dev
npm test
npm run build
npm run check:architecture
```

Node >= 22.12. En el entorno de esta entrega también puede usarse ../ejecutar.ps1.
Arquitectura src/presentation → src/domain ← src/data; main.jsx compone las dependencias.

Entrega: [respuestas.md](respuestas.md), [analisis_spec.md](analisis_spec.md), [analisis_plan.md](analisis_plan.md), [bitacora.md](bitacora.md).
Feature activo: specs/001-dividir-cuenta. Spec idéntica al Flutter sdd original; no se volvió a ejecutar specify.
Resultados: 36 pruebas (seis aceptación, LSP, tres pantalla y bordes), build y navegador real verificados. Evidencias completas en evidencias/.
Git: main por instrucción del usuario. Exportación de fuentes para el repositorio conjunto en ../divisor_cuenta_web_entrega; historial independiente conservado con Git bundle.
