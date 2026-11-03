"""Pruebas del contrato; cada prueba recibe almacenamiento independiente."""

import pytest

from server import Centinela


@pytest.fixture
def sistema():
    return Centinela()


def test_lista_exactamente_los_tres_casos(sistema):
    assert sistema.listar_casos() == [
        {"id": "INC-001", "sistema": "portal_acceso", "cantidad_eventos": 2},
        {"id": "INC-002", "sistema": "portal_acceso", "cantidad_eventos": 6},
        {"id": "INC-003", "sistema": "panel_administracion", "cantidad_eventos": 5},
    ]


def test_caso_desconocido_produce_error(sistema):
    with pytest.raises(ValueError, match="INC-999.*no existe"):
        sistema.consultar_eventos("INC-999")


def test_consulta_exacta_de_seis_fallos(sistema):
    assert sistema.consultar_eventos("INC-002") == [
        {"hora": f"02:{minuto}", "usuario": "admin", "ip": "203.0.113.25", "evento": "LOGIN_FAILED"}
        for minuto in range(10, 16)
    ]


def test_registro_valido(sistema):
    assert sistema.registrar_alerta("INC-003", "alto", "Requiere revisión") == {
        "caso_id": "INC-003", "nivel": "alto", "motivo": "Requiere revisión", "estado": "registrada"
    }


def test_duplicado_en_la_misma_instancia(sistema):
    sistema.registrar_alerta("INC-003", "alto", "Revisar")
    with pytest.raises(ValueError, match="duplicados"):
        sistema.registrar_alerta("INC-003", "medio", "Otro motivo")


@pytest.mark.parametrize("nivel", ["critico", "ALTO", "", None, []])
def test_rechaza_niveles_invalidos_sin_guardar_alerta(sistema, nivel):
    with pytest.raises(ValueError, match="bajo, medio o alto"):
        sistema.registrar_alerta("INC-002", nivel, "Revisar")
    assert sistema.registrar_alerta("INC-002", "medio", "Revisar")["estado"] == "registrada"


@pytest.mark.parametrize("motivo", ["", "   ", "\t\n", None, 42])
def test_rechaza_motivos_invalidos_sin_guardar_alerta(sistema, motivo):
    with pytest.raises(ValueError, match="motivo"):
        sistema.registrar_alerta("INC-002", "medio", motivo)
    assert sistema.registrar_alerta("INC-002", "medio", "Revisar")["estado"] == "registrada"


def test_no_registra_alerta_de_caso_inexistente(sistema):
    with pytest.raises(ValueError, match="no existe"):
        sistema.registrar_alerta("INC-999", "alto", "Revisar")


def test_otra_instancia_no_comparte_alertas(sistema):
    sistema.registrar_alerta("INC-003", "alto", "Revisar")
    assert Centinela().registrar_alerta("INC-003", "alto", "Revisar")["estado"] == "registrada"


def test_las_respuestas_no_permiten_modificar_el_estado(sistema):
    eventos = sistema.consultar_eventos("INC-001")
    eventos[0]["evento"] = "CAMBIADO"
    assert sistema.consultar_eventos("INC-001")[0]["evento"] == "LOGIN_FAILED"
    alerta = sistema.registrar_alerta("INC-001", "bajo", "Revisar")
    alerta.clear()
    with pytest.raises(ValueError, match="duplicados"):
        sistema.registrar_alerta("INC-001", "bajo", "Revisar")
