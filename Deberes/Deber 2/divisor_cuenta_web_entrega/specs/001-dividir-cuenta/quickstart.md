# Guía rápida

Requisito: Node >= 22.12 y npm. Desde esta carpeta:

```powershell
npm ci
$env:SPECIFY_FEATURE_DIRECTORY = 'specs/001-dividir-cuenta'
npm run dev
# En otra terminal:
npx vitest run test/division.test.js
npm test
npm run build
```

Esperados: seis casos + LSP en dominio; tres casos obligatorios de pantalla y pruebas de aclaraciones. Build genera dist/.
Comprobar manualmente 100, 4, 10 → 27.50; 10, 3, 0 → 3.33 o 4.00; monto abc → Monto inválido.
Para las precondiciones y estados ver [data-model.md](data-model.md) y [contracts/ui.md](contracts/ui.md).

En este entorno npm se instaló localmente: `node ../herramientas/node_modules/npm/bin/npm-cli.js test`. El script `../ejecutar.ps1` resuelve esa ruta automáticamente. No es un requisito de la app en otra máquina.
