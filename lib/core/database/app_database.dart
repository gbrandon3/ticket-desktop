import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// 1. Usuarios del Sistema (Roles: admin, tecnico, solicitante, cliente)
class UsuariosTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get email => text().customConstraint('UNIQUE')();
  TextColumn get password => text()();
  TextColumn get documento => text()();
  TextColumn get telefono => text()();
  TextColumn get rol => text()(); // 'admin', 'tecnico', 'solicitante', 'cliente'
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 2. Clientes
class ClientesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipoDocumento => text()();
  TextColumn get numeroDocumento => text().customConstraint('UNIQUE')();
  TextColumn get nombreCompleto => text()();
  TextColumn get telefono => text()();
  TextColumn get email => text().nullable()();
  TextColumn get direccion => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 3. Equipos
class EquiposTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId => integer().references(ClientesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get tipoEquipo => text()();
  TextColumn get marca => text()();
  TextColumn get modelo => text()();
  TextColumn get numeroSerie => text()();
  TextColumn get sistemaOperativo => text().nullable()();
  TextColumn get procesador => text().nullable()();
  TextColumn get memoriaRam => text().nullable()();
  TextColumn get almacenamiento => text().nullable()();
  TextColumn get tarjetaGrafica => text().nullable()();
  TextColumn get estadoEquipo => text().withDefault(const Constant('OPERATIVO'))(); // OPERATIVO, EN_TALLER, DE_BAJA
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 4. Órdenes / Incidencias
class OrdenesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigoOrden => text().customConstraint('UNIQUE')();
  IntColumn get clienteId => integer().references(ClientesTable, #id)();
  IntColumn get equipoId => integer().references(EquiposTable, #id)();
  IntColumn get tecnicoId => integer().nullable().references(UsuariosTable, #id)();
  IntColumn get solicitanteId => integer().nullable().references(UsuariosTable, #id)();
  TextColumn get tipoServicio => text()(); // PREVENTIVO, CORRECTIVO
  TextColumn get categoriaFalla => text()(); // HARDWARE, SOFTWARE, RED, MIXTO
  TextColumn get prioridad => text()(); // BAJA, MEDIA, ALTA, CRITICA
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  TextColumn get estado => text().withDefault(const Constant('RECIBIDO'))();
  // Estados: RECIBIDO, EN_DIAGNOSTICO, EN_TALLER, LISTO_ENTREGA, ENTREGADO_CERRADO
  DateTimeColumn get fechaIngreso => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaLimiteSla => dateTime().nullable()();
  DateTimeColumn get fechaCierre => dateTime().nullable()();
}

// 5. Formato OT
class FormatoOtTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get diagnosticoPreliminar => text().nullable()();
  TextColumn get herramientasChips => text().withDefault(const Constant('[]'))();
  DateTimeColumn get tiempoEstimadoEntrega => dateTime().nullable()();
  BoolColumn get accesorioCargador => boolean().withDefault(const Constant(false))();
  BoolColumn get accesorioCablePoder => boolean().withDefault(const Constant(false))();
  BoolColumn get accesorioMouse => boolean().withDefault(const Constant(false))();
  BoolColumn get accesorioMaletin => boolean().withDefault(const Constant(false))();
  BoolColumn get encendidoInicial => boolean().withDefault(const Constant(true))();
  TextColumn get estadoCarcasa => text().nullable()();
  TextColumn get pinContrasena => text().nullable()();
}

// 6. Formato Actividades
class FormatoActividadesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get procedimientosRealizados => text().nullable()();
  
  // Insumos físicos y químicos
  BoolColumn get pastaTermica => boolean().withDefault(const Constant(false))();
  BoolColumn get alcoholIsopropilico => boolean().withDefault(const Constant(false))();
  BoolColumn get sopleteadoContactos => boolean().withDefault(const Constant(false))();
  BoolColumn get brochaAntiestatica => boolean().withDefault(const Constant(false))();
  BoolColumn get panoMicrofibra => boolean().withDefault(const Constant(false))();

  // Mantenimiento lógico
  BoolColumn get depuracionTemporales => boolean().withDefault(const Constant(false))();
  BoolColumn get optimizacionInicio => boolean().withDefault(const Constant(false))();
  BoolColumn get escaneoMalware => boolean().withDefault(const Constant(false))();
  BoolColumn get actualizacionDrivers => boolean().withDefault(const Constant(false))();
  BoolColumn get comprobacionDisco => boolean().withDefault(const Constant(false))();

  // Pruebas de calidad
  BoolColumn get qaEstresTermico => boolean().withDefault(const Constant(false))();
  BoolColumn get qaPuertos => boolean().withDefault(const Constant(false))();
  BoolColumn get qaConectividad => boolean().withDefault(const Constant(false))();
  BoolColumn get qaBateria => boolean().withDefault(const Constant(false))();
  BoolColumn get qaTecladoTouchpad => boolean().withDefault(const Constant(false))();

  RealColumn get costoManoObra => real().withDefault(const Constant(0.0))();
}

// 7. Repuestos
class RepuestosOrdenTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get referencia => text()();
  IntColumn get cantidad => integer().withDefault(const Constant(1))();
  RealColumn get precioUnitario => real()();
  RealColumn get subtotal => real()();
}

// 8. Acta de Entrega
class FormatoActaEntregaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get estadoOperatividad => text()();
  TextColumn get observaciones => text().nullable()();
  TextColumn get recomendacionesCuidado => text().nullable()();
  TextColumn get garantiaDias => text()();
  TextColumn get personaRecibeNombre => text()();
  TextColumn get personaRecibeDocumento => text()();
  BoolColumn get checkConformidad => boolean().withDefault(const Constant(false))();
  DateTimeColumn get fechaEntrega => dateTime().withDefault(currentDateAndTime)();
}

// 9. Fotos de Evidencia
class FotosEvidenciaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get etapa => text()(); // RECEPCION, PROCESO, ENTREGA
  TextColumn get rutaOBytesBase64 => text()();
  TextColumn get notaTecnica => text().nullable()();
  DateTimeColumn get fechaCaptura => dateTime().withDefault(currentDateAndTime)();
}

// 10. Configuración de Empresa / Taller y SMTP
class ConfiguracionEmpresaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreEmpresa => text().withDefault(const Constant('Centro de Soporte & Mantenimiento'))();
  TextColumn get slogan => text().withDefault(const Constant('Para un equipo saludable CONTACTANOS'))();
  TextColumn get nit => text().withDefault(const Constant('900.000.000-1'))();
  TextColumn get telefono => text().withDefault(const Constant('+57 310 000 0000'))();
  TextColumn get email => text().withDefault(const Constant('soporte@empresa.com'))();
  TextColumn get direccion => text().withDefault(const Constant('Avenida Principal # 12-34'))();
  TextColumn get ciudad => text().withDefault(const Constant('Colombia'))();
  TextColumn get logoBase64 => text().nullable()();
  
  // Parámetros SMTP
  TextColumn get smtpHost => text().nullable()();
  IntColumn get smtpPort => integer().nullable()();
  TextColumn get smtpUser => text().nullable()();
  TextColumn get smtpPass => text().nullable()();

  // Personalización visual
  TextColumn get colorPrimario => text().withDefault(const Constant('#1E3A8A'))();
  TextColumn get colorSecundario => text().withDefault(const Constant('#0284C7'))();
  
  // Flag de Setup Inicial
  BoolColumn get isSetupCompleted => boolean().withDefault(const Constant(false))();
}

// 11. Auditoría de Notificaciones por Correo
class NotificacionesAuditoriaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get destinatario => text()();
  TextColumn get asunto => text()();
  TextColumn get evento => text()();
  TextColumn get estado => text()(); // ENVIADO, FALLIDO
  DateTimeColumn get fechaEnvio => dateTime().withDefault(currentDateAndTime)();
}

// 12. Catálogo de Tipos de Fallas en Base de Datos
class TiposFallaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipoServicio => text()(); // 'CORRECTIVO' o 'PREVENTIVO'
  TextColumn get nombre => text().customConstraint('UNIQUE')();
  TextColumn get descripcion => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [
  UsuariosTable,
  ClientesTable,
  EquiposTable,
  OrdenesTable,
  FormatoOtTable,
  FormatoActividadesTable,
  RepuestosOrdenTable,
  FormatoActaEntregaTable,
  FotosEvidenciaTable,
  ConfiguracionEmpresaTable,
  NotificacionesAuditoriaTable,
  TiposFallaTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'taller_soporte_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
