class FormatoOt {
  final int? id;
  final int ordenId;
  final String? diagnosticoPreliminar;
  final List<String> herramientasChips;
  final DateTime? tiempoEstimadoEntrega;
  final bool accesorioCargador;
  final bool accesorioCablePoder;
  final bool accesorioMouse;
  final bool accesorioMaletin;
  final bool encendidoInicial;
  final String? estadoCarcasa;
  final String? pinContrasena;

  const FormatoOt({
    this.id,
    required this.ordenId,
    this.diagnosticoPreliminar,
    this.herramientasChips = const [],
    this.tiempoEstimadoEntrega,
    this.accesorioCargador = false,
    this.accesorioCablePoder = false,
    this.accesorioMouse = false,
    this.accesorioMaletin = false,
    this.encendidoInicial = true,
    this.estadoCarcasa,
    this.pinContrasena,
  });

  FormatoOt copyWith({
    int? id,
    int? ordenId,
    String? diagnosticoPreliminar,
    List<String>? herramientasChips,
    DateTime? tiempoEstimadoEntrega,
    bool? accesorioCargador,
    bool? accesorioCablePoder,
    bool? accesorioMouse,
    bool? accesorioMaletin,
    bool? encendidoInicial,
    String? estadoCarcasa,
    String? pinContrasena,
  }) {
    return FormatoOt(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      diagnosticoPreliminar: diagnosticoPreliminar ?? this.diagnosticoPreliminar,
      herramientasChips: herramientasChips ?? this.herramientasChips,
      tiempoEstimadoEntrega: tiempoEstimadoEntrega ?? this.tiempoEstimadoEntrega,
      accesorioCargador: accesorioCargador ?? this.accesorioCargador,
      accesorioCablePoder: accesorioCablePoder ?? this.accesorioCablePoder,
      accesorioMouse: accesorioMouse ?? this.accesorioMouse,
      accesorioMaletin: accesorioMaletin ?? this.accesorioMaletin,
      encendidoInicial: encendidoInicial ?? this.encendidoInicial,
      estadoCarcasa: estadoCarcasa ?? this.estadoCarcasa,
      pinContrasena: pinContrasena ?? this.pinContrasena,
    );
  }
}
