Herramientas descubiertas: `listar_casos`, `consultar_eventos` y `registrar_alerta`.

Evidencia exacta (`hora | usuario | ip | evento`):

```text
INC-001 | portal_acceso | 2 eventos
08:41 | ana | 198.51.100.10 | LOGIN_FAILED
08:42 | ana | 198.51.100.10 | LOGIN_SUCCESS

INC-002 | portal_acceso | 6 eventos
02:10 | admin | 203.0.113.25 | LOGIN_FAILED
02:11 | admin | 203.0.113.25 | LOGIN_FAILED
02:12 | admin | 203.0.113.25 | LOGIN_FAILED
02:13 | admin | 203.0.113.25 | LOGIN_FAILED
02:14 | admin | 203.0.113.25 | LOGIN_FAILED
02:15 | admin | 203.0.113.25 | LOGIN_FAILED

INC-003 | panel_administracion | 5 eventos
03:00 | admin | 192.0.2.50 | LOGIN_FAILED
03:01 | admin | 192.0.2.50 | LOGIN_FAILED
03:02 | admin | 192.0.2.50 | LOGIN_FAILED
03:03 | admin | 192.0.2.50 | LOGIN_FAILED
03:04 | admin | 192.0.2.50 | LOGIN_SUCCESS
```

Alerta INC-003 **registrada**, nivel **alto**: cuatro fallos seguidos de un acceso exitoso para `admin` desde la misma IP justifican revisión prioritaria por posible acceso no autorizado; no confirman una intrusión.

La consulta INC-999 devolvió este error exacto, sin eventos:

```text
Error executing tool consultar_eventos: El caso 'INC-999' no existe.
```