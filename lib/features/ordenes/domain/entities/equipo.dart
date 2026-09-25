class Equipo {
  final int? id;
  final int clienteId;
  final String tipoEquipo;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final String? sistemaOperativo;
  final String? procesador;
  final String? memoriaRam;
  final String? almacenamiento;
  final String? tarjetaGrafica;
  final String estadoEquipo; // 'OPERATIVO', 'EN_TALLER', 'DE_BAJA'
  final DateTime? createdAt;

  const Equipo({
    this.id,
    required this.clienteId,
    required this.tipoEquipo,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.sistemaOperativo,
    this.procesador,
    this.memoriaRam,
    this.almacenamiento,
    this.tarjetaGrafica,
    this.estadoEquipo = 'OPERATIVO',
    this.createdAt,
  });

  Equipo copyWith({
    int? id,
    int? clienteId,
    String? tipoEquipo,
    String? marca,
    String? modelo,
    String? numeroSerie,
    String? sistemaOperativo,
    String? procesador,
    String? memoriaRam,
    String? almacenamiento,
    String? tarjetaGrafica,
    String? estadoEquipo,
    DateTime? createdAt,
  }) {
    return Equipo(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      tipoEquipo: tipoEquipo ?? this.tipoEquipo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      sistemaOperativo: sistemaOperativo ?? this.sistemaOperativo,
      procesador: procesador ?? this.procesador,
      memoriaRam: memoriaRam ?? this.memoriaRam,
      almacenamiento: almacenamiento ?? this.almacenamiento,
      tarjetaGrafica: tarjetaGrafica ?? this.tarjetaGrafica,
      estadoEquipo: estadoEquipo ?? this.estadoEquipo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
