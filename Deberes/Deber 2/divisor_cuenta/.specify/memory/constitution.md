# Divisor de cuenta Constitution

## Core Principles

### I. SRP — responsabilidad única
Cada clase tiene una razón de cambio. CalcularDivision únicamente aplica la fórmula y delega
el redondeo: no valida ni formatea. ValidarEntrada valida y FormateadorMoneda formatea.

### II. OCP — abierto a extensión
Una nueva regla de redondeo se agrega implementando EstrategiaRedondeo en un archivo nuevo.
No se modifican CalcularDivision ni las estrategias existentes.

### III. LSP — sustitución
Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito
no negativo. El consumidor usa la interfaz sin if de tipo ni casts concretos.
Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso.

### IV. ISP — interfaz pequeña
EstrategiaRedondeo declara únicamente redondear(double importe). No incluye validación,
formateo, persistencia ni métodos ajenos al redondeo.

### V. DIP — inversión de dependencias
presentation depende de domain, nunca de data. domain no importa package:flutter ni data.
main.dart es el único punto que instancia implementaciones concretas y conecta dependencias.
Se permite instanciar objetos de valor Cuenta y Resultado donde corresponde y widgets
en la presentación; la regla de composición se aplica a servicios y estrategias inyectables.

## Arquitectura y seguridad
Capas obligatorias: presentation -> domain <- data. Dominio Dart puro.
No guardar secretos ni API keys. Una pantalla sin red ni base de datos.
El SDK y sus dependencias generadas son la base; no agregar paquetes externos al producto.
Excepción de desarrollo documentada: package:test permite ejecutar la suite en navegador
cuando Windows bloquea flutter_tester.exe; no cambia dependencias ni comportamiento de producción.

## Calidad, pruebas y regla de la materia
Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos.
Incluir la prueba LSP y las tres pruebas de widget solicitadas.
Toda función generada debe ser explicable: propósito, entrada, salida y errores.
Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior.

## Governance
La constitución rige spec, plan, tareas y código. Ante un incumplimiento se corrige primero
el artefacto que define la regla. Revisar el cumplimiento antes y después de implementar.
Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH.
Esta versión inicial concreta únicamente las reglas del enunciado.
**Version**: 1.0.1 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-06

Aclaración PATCH para el runner web: ver tool/probar_web.ps1 y evidencia flutter-web.txt
del proyecto React. El análisis del deber compara la constitución ORIGINAL 1.0.0 de sdd;
esa copia se conserva en evidencias/constitution-flutter-original.md del proyecto React.

