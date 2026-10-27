# Research
- Decision: setState y SDK estable instalado. Rationale: lo solicita la guía; una pantalla.
  Alternatives considered: gestores de estado externos, descartados por alcance.
- Decision: strategies inyectadas mediante EstrategiaRedondeo. Rationale: OCP, DIP, LSP.
  Alternatives considered: if de tipo dentro del cálculo, incompatible con constitución.
- Decision: normalizar coma a punto solo en presentation. Rationale: respuesta del usuario;
  domain recibe números, no conoce formato de entrada.
- Decision: pruebas de domain con test_api transitivo del SDK y comprobador Dart puro.
  Rationale: no añadir paquetes; domain no necesita motor de Flutter.
- Decision: Chrome como alternativa al tester nativo bloqueado por Application Control.
  Rationale: verificar widgets sin cambiar políticas de Windows. No se ha demostrado aún éxito.

