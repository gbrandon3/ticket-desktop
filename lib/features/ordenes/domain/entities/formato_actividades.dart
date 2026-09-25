class FormatoActividades {
  final int? id;
  final int ordenId;
  final String? procedimientosRealizados;

  // Insumos físicos y químicos
  final bool pastaTermica;
  final bool alcoholIsopropilico;
  final bool sopleteadoContactos;
  final bool brochaAntiestatica;
  final bool panoMicrofibra;

  // Mantenimiento lógico
  final bool depuracionTemporales;
  final bool optimizacionInicio;
  final bool escaneoMalware;
  final bool actualizacionDrivers;
  final bool comprobacionDisco;

  // Pruebas de calidad (QA)
  final bool qaEstresTermico;
  final bool qaPuertos;
  final bool qaConectividad;
  final bool qaBateria;
  final bool qaTecladoTouchpad;

  final double costoManoObra;

  const FormatoActividades({
    this.id,
    required this.ordenId,
    this.procedimientosRealizados,
    this.pastaTermica = false,
    this.alcoholIsopropilico = false,
    this.sopleteadoContactos = false,
    this.brochaAntiestatica = false,
    this.panoMicrofibra = false,
    this.depuracionTemporales = false,
    this.optimizacionInicio = false,
    this.escaneoMalware = false,
    this.actualizacionDrivers = false,
    this.comprobacionDisco = false,
    this.qaEstresTermico = false,
    this.qaPuertos = false,
    this.qaConectividad = false,
    this.qaBateria = false,
    this.qaTecladoTouchpad = false,
    this.costoManoObra = 0.0,
  });

  FormatoActividades copyWith({
    int? id,
    int? ordenId,
    String? procedimientosRealizados,
    bool? pastaTermica,
    bool? alcoholIsopropilico,
    bool? sopleteadoContactos,
    bool? brochaAntiestatica,
    bool? panoMicrofibra,
    bool? depuracionTemporales,
    bool? optimizacionInicio,
    bool? escaneoMalware,
    bool? actualizacionDrivers,
    bool? comprobacionDisco,
    bool? qaEstresTermico,
    bool? qaPuertos,
    bool? qaConectividad,
    bool? qaBateria,
    bool? qaTecladoTouchpad,
    double? costoManoObra,
  }) {
    return FormatoActividades(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      procedimientosRealizados: procedimientosRealizados ?? this.procedimientosRealizados,
      pastaTermica: pastaTermica ?? this.pastaTermica,
      alcoholIsopropilico: alcoholIsopropilico ?? this.alcoholIsopropilico,
      sopleteadoContactos: sopleteadoContactos ?? this.sopleteadoContactos,
      brochaAntiestatica: brochaAntiestatica ?? this.brochaAntiestatica,
      panoMicrofibra: panoMicrofibra ?? this.panoMicrofibra,
      depuracionTemporales: depuracionTemporales ?? this.depuracionTemporales,
      optimizacionInicio: optimizacionInicio ?? this.optimizacionInicio,
      escaneoMalware: escaneoMalware ?? this.escaneoMalware,
      actualizacionDrivers: actualizacionDrivers ?? this.actualizacionDrivers,
      comprobacionDisco: comprobacionDisco ?? this.comprobacionDisco,
      qaEstresTermico: qaEstresTermico ?? this.qaEstresTermico,
      qaPuertos: qaPuertos ?? this.qaPuertos,
      qaConectividad: qaConectividad ?? this.qaConectividad,
      qaBateria: qaBateria ?? this.qaBateria,
      qaTecladoTouchpad: qaTecladoTouchpad ?? this.qaTecladoTouchpad,
      costoManoObra: costoManoObra ?? this.costoManoObra,
    );
  }
}
