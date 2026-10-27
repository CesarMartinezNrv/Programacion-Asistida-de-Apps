/// Contrato de redondeo para importes finitos no negativos.
abstract interface class EstrategiaRedondeo {
  double redondear(double importe);
}
