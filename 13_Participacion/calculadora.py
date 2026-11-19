"""Mini calculadora del laboratorio (Semana 13)."""


def sumar(a, b):
    return a + b


def restar(a, b):
    return a - b


def multiplicar(a, b):
    return a * b


def dividir(a, b):
    if b == 0:
        raise ValueError("no se puede dividir entre cero")
    return a / b


def promedio(numeros):
    """Promedio aritmético de una lista de números."""
    return sum(numeros) / len(numeros)
