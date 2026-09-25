import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/entities/empresa_config.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/formato_acta_entrega.dart';
import '../../domain/entities/formato_actividades.dart';
import '../../domain/entities/formato_ot.dart';
import '../../domain/entities/foto_evidencia.dart';
import '../../domain/entities/notificacion_auditoria.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/repuesto.dart';
import '../../domain/entities/tipo_falla.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/i_ordenes_repository.dart';
import '../mappers/mappers.dart';

class OrdenesRepositoryImpl implements IOrdenesRepository {
  final AppDatabase db;

  OrdenesRepositoryImpl(this.db);

  // ===================== AUTENTICACIÓN Y USUARIOS =====================

  @override
  Future<Usuario?> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();
    final query = db.select(db.usuariosTable)
      ..where((tbl) => tbl.email.equals(cleanEmail) & tbl.password.equals(cleanPass) & tbl.activo.equals(true));
    final data = await query.getSingleOrNull();
    if (data == null) return null;
    return Mappers.toDomainUsuario(data);
  }

  @override
  Future<List<Usuario>> getUsuarios({String? rol}) async {
    final query = db.select(db.usuariosTable);
    if (rol != null && rol.isNotEmpty && rol != 'TODOS') {
      query.where((tbl) => tbl.rol.equals(rol));
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]);
    final list = await query.get();
    return list.map(Mappers.toDomainUsuario).toList();
  }

  @override
  Future<Usuario> createUsuario(Usuario usuario) async {
    final id = await db.into(db.usuariosTable).insert(
          UsuariosTableCompanion(
            nombre: Value(usuario.nombre),
            email: Value(usuario.email.trim().toLowerCase()),
            password: Value(usuario.password),
            documento: Value(usuario.documento),
            telefono: Value(usuario.telefono),
            rol: Value(usuario.rol),
            activo: Value(usuario.activo),
          ),
        );
    return usuario.copyWith(id: id);
  }

  @override
  Future<void> updateUsuario(Usuario usuario) async {
    if (usuario.id == null) return;
    await (db.update(db.usuariosTable)..where((tbl) => tbl.id.equals(usuario.id!))).write(
      UsuariosTableCompanion(
        nombre: Value(usuario.nombre),
        email: Value(usuario.email.trim().toLowerCase()),
        password: Value(usuario.password),
        documento: Value(usuario.documento),
        telefono: Value(usuario.telefono),
        rol: Value(usuario.rol),
        activo: Value(usuario.activo),
      ),
    );
  }

  @override
  Future<void> toggleUsuarioActivo(int id, bool activo) async {
    await (db.update(db.usuariosTable)..where((tbl) => tbl.id.equals(id))).write(
      UsuariosTableCompanion(activo: Value(activo)),
    );
  }

  @override
  Future<void> seedTestUsers() async {
    // 1. Admin Principal
    final existingAdmin = await (db.select(db.usuariosTable)
          ..where((t) => t.email.equals('admin@taller.com')))
        .getSingleOrNull();
    if (existingAdmin == null) {
      await db.into(db.usuariosTable).insert(
            const UsuariosTableCompanion(
              nombre: Value('Administrador Principal'),
              email: Value('admin@taller.com'),
              password: Value('admin123'),
              documento: Value('1020304050'),
              telefono: Value('3101234567'),
              rol: Value('admin'),
              activo: Value(true),
            ),
          );
    }

    // 2. Operador (Solicitante / Recepción)
    final existingOperador = await (db.select(db.usuariosTable)
          ..where((t) => t.email.equals('operador@taller.com')))
        .getSingleOrNull();
    if (existingOperador == null) {
      await db.into(db.usuariosTable).insert(
            const UsuariosTableCompanion(
              nombre: Value('Laura Gómez (Operador Recepción)'),
              email: Value('operador@taller.com'),
              password: Value('operador123'),
              documento: Value('1098765432'),
              telefono: Value('3154567890'),
              rol: Value('operador'),
              activo: Value(true),
            ),
          );
    }

    // 3. Técnico (Especialista Taller)
    final existingTecnico = await (db.select(db.usuariosTable)
          ..where((t) => t.email.equals('tecnico@taller.com')))
        .getSingleOrNull();
    if (existingTecnico == null) {
      await db.into(db.usuariosTable).insert(
            const UsuariosTableCompanion(
              nombre: Value('Carlos Mendoza (Técnico Laboratorio)'),
              email: Value('tecnico@taller.com'),
              password: Value('tecnico123'),
              documento: Value('79854123'),
              telefono: Value('3209876543'),
              rol: Value('tecnico'),
              activo: Value(true),
            ),
          );
    }
  }

  // ===================== SETUP WIZARD =====================

  @override
  Future<bool> isSetupCompleted() async {
    final list = await db.select(db.configuracionEmpresaTable).get();
    if (list.isEmpty) return false;
    return list.first.isSetupCompleted;
  }

  @override
  Future<void> completeSetup({
    required EmpresaConfig empresa,
    required Usuario admin,
    Usuario? operador,
    Usuario? tecnico,
  }) async {
    await db.transaction(() async {
      // 1. Guardar Configuración de Empresa con isSetupCompleted = true
      final existingEmpresa = await db.select(db.configuracionEmpresaTable).get();
      if (existingEmpresa.isEmpty) {
        await db.into(db.configuracionEmpresaTable).insert(
              ConfiguracionEmpresaTableCompanion(
                nombreEmpresa: Value(empresa.nombreEmpresa),
                slogan: Value(empresa.slogan),
                nit: Value(empresa.nit),
                telefono: Value(empresa.telefono),
                email: Value(empresa.email),
                direccion: Value(empresa.direccion),
                ciudad: Value(empresa.ciudad),
                logoBase64: Value(empresa.logoBase64),
                isSetupCompleted: const Value(true),
              ),
            );
      } else {
        await (db.update(db.configuracionEmpresaTable)..where((tbl) => tbl.id.equals(existingEmpresa.first.id))).write(
          ConfiguracionEmpresaTableCompanion(
            nombreEmpresa: Value(empresa.nombreEmpresa),
            slogan: Value(empresa.slogan),
            nit: Value(empresa.nit),
            telefono: Value(empresa.telefono),
            email: Value(empresa.email),
            direccion: Value(empresa.direccion),
            ciudad: Value(empresa.ciudad),
            logoBase64: Value(empresa.logoBase64),
            isSetupCompleted: const Value(true),
          ),
        );
      }

      // 2. Crear Administrador Principal
      await db.into(db.usuariosTable).insert(
            UsuariosTableCompanion(
              nombre: Value(admin.nombre),
              email: Value(admin.email.trim().toLowerCase()),
              password: Value(admin.password),
              documento: Value(admin.documento),
              telefono: Value(admin.telefono),
              rol: const Value('admin'),
              activo: const Value(true),
            ),
          );

      // 3. Crear Operador Inicial (si se especificó)
      if (operador != null && operador.nombre.trim().isNotEmpty) {
        await db.into(db.usuariosTable).insert(
              UsuariosTableCompanion(
                nombre: Value(operador.nombre),
                email: Value(operador.email.trim().toLowerCase()),
                password: Value(operador.password),
                documento: Value(operador.documento),
                telefono: Value(operador.telefono),
                rol: const Value('operador'),
                activo: const Value(true),
              ),
            );
      }

      // 4. Crear Técnico Inicial (si se especificó)
      if (tecnico != null && tecnico.nombre.trim().isNotEmpty) {
        await db.into(db.usuariosTable).insert(
              UsuariosTableCompanion(
                nombre: Value(tecnico.nombre),
                email: Value(tecnico.email.trim().toLowerCase()),
                password: Value(tecnico.password),
                documento: Value(tecnico.documento),
                telefono: Value(tecnico.telefono),
                rol: const Value('tecnico'),
                activo: const Value(true),
              ),
            );
      }
    });
  }

  // ===================== DASHBOARDS Y MÉTRICAS =====================

  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    final all = await db.select(db.ordenesTable).get();
    final total = all.length;
    final enTaller = all.where((o) => o.estado == 'EN_DIAGNOSTICO' || o.estado == 'EN_TALLER' || o.estado == 'RECIBIDO').length;
    final resueltos = all.where((o) => o.estado == 'LISTO_ENTREGA').length;
    final entregados = all.where((o) => o.estado == 'ENTREGADO_CERRADO').length;

    return DashboardMetrics(
      totalOrdenes: total,
      enTaller: enTaller,
      resueltos: resueltos,
      entregadosCerrados: entregados,
    );
  }

  @override
  Future<Map<String, dynamic>> getAdminMetrics() async {
    final ordenes = await db.select(db.ordenesTable).get();
    final tecnicos = await (db.select(db.usuariosTable)..where((tbl) => tbl.rol.equals('tecnico'))).get();

    final total = ordenes.length;
    final preventivos = ordenes.where((o) => o.tipoServicio == 'PREVENTIVO').length;
    final correctivos = ordenes.where((o) => o.tipoServicio == 'CORRECTIVO').length;

    final cerrados = ordenes.where((o) => o.estado == 'ENTREGADO_CERRADO').toList();
    int cumplidosSla = 0;
    double horasTotalesResolucion = 0;

    for (final c in cerrados) {
      if (c.fechaCierre != null) {
        final diffHoras = c.fechaCierre!.difference(c.fechaIngreso).inHours;
        horasTotalesResolucion += diffHoras;
        if (c.fechaLimiteSla != null && c.fechaCierre!.isBefore(c.fechaLimiteSla!)) {
          cumplidosSla++;
        } else if (c.fechaLimiteSla == null) {
          cumplidosSla++;
        }
      }
    }

    final double porcentajeSla = cerrados.isEmpty ? 100.0 : ((cumplidosSla / cerrados.length) * 100);
    final double tiempoPromedioHoras = cerrados.isEmpty ? 0.0 : (horasTotalesResolucion / cerrados.length);

    final ahora = DateTime.now();
    final vencidos = ordenes.where((o) => o.fechaLimiteSla != null && o.estado != 'ENTREGADO_CERRADO' && ahora.isAfter(o.fechaLimiteSla!)).length;
    final sinAsignar = ordenes.where((o) => o.tecnicoId == null && o.estado != 'ENTREGADO_CERRADO').length;

    // Carga por técnico
    final cargaTecnicos = <Map<String, dynamic>>[];
    for (final t in tecnicos) {
      final activas = ordenes.where((o) => o.tecnicoId == t.id && o.estado != 'ENTREGADO_CERRADO').length;
      final terminadas = ordenes.where((o) => o.tecnicoId == t.id && o.estado == 'ENTREGADO_CERRADO').length;
      cargaTecnicos.add({
        'id': t.id,
        'nombre': t.nombre,
        'activas': activas,
        'terminadas': terminadas,
      });
    }

    return {
      'total': total,
      'preventivos': preventivos,
      'correctivos': correctivos,
      'porcentajeSla': porcentajeSla,
      'tiempoPromedioHoras': tiempoPromedioHoras,
      'vencidos': vencidos,
      'sinAsignar': sinAsignar,
      'cargaTecnicos': cargaTecnicos,
    };
  }

  @override
  Stream<List<Orden>> watchOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId}) {
    final query = db.select(db.ordenesTable).join([
      innerJoin(db.clientesTable, db.clientesTable.id.equalsExp(db.ordenesTable.clienteId)),
      innerJoin(db.equiposTable, db.equiposTable.id.equalsExp(db.ordenesTable.equipoId)),
      leftOuterJoin(db.usuariosTable, db.usuariosTable.id.equalsExp(db.ordenesTable.tecnicoId)),
    ]);

    if (estado != null && estado.isNotEmpty && estado != 'TODOS') {
      query.where(db.ordenesTable.estado.equals(estado));
    }

    if (tipo != null && tipo.isNotEmpty && tipo != 'TODOS') {
      query.where(db.ordenesTable.tipoServicio.equals(tipo));
    }

    if (tecnicoId != null) {
      query.where(db.ordenesTable.tecnicoId.equals(tecnicoId));
    }

    if (solicitanteId != null) {
      query.where(db.ordenesTable.solicitanteId.equals(solicitanteId));
    }

    query.orderBy([OrderingTerm.desc(db.ordenesTable.id)]);

    return query.watch().map((rows) {
      final list = <Orden>[];
      for (final row in rows) {
        final ordenData = row.readTable(db.ordenesTable);
        final clienteData = row.readTable(db.clientesTable);
        final equipoData = row.readTable(db.equiposTable);
        final tecnicoData = row.readTableOrNull(db.usuariosTable);

        final cliente = Mappers.toDomainCliente(clienteData);
        final equipo = Mappers.toDomainEquipo(equipoData);
        final tecnico = tecnicoData != null ? Mappers.toDomainUsuario(tecnicoData) : null;
        final orden = Mappers.toDomainOrden(ordenData, cliente: cliente, equipo: equipo, tecnico: tecnico);

        if (busqueda != null && busqueda.trim().isNotEmpty) {
          final queryStr = busqueda.trim().toLowerCase();
          final matchesCode = orden.codigoOrden.toLowerCase().contains(queryStr);
          final matchesCliente = cliente.nombreCompleto.toLowerCase().contains(queryStr) ||
              cliente.numeroDocumento.toLowerCase().contains(queryStr);
          final matchesEquipo = equipo.numeroSerie.toLowerCase().contains(queryStr) ||
              equipo.marca.toLowerCase().contains(queryStr) ||
              equipo.modelo.toLowerCase().contains(queryStr);

          if (matchesCode || matchesCliente || matchesEquipo) {
            list.add(orden);
          }
        } else {
          list.add(orden);
        }
      }
      return list;
    });
  }

  @override
  Future<List<Orden>> getOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId}) async {
    final stream = watchOrdenes(busqueda: busqueda, estado: estado, tipo: tipo, tecnicoId: tecnicoId, solicitanteId: solicitanteId);
    return await stream.first;
  }

  @override
  Future<Orden?> getOrdenById(int id) async {
    final query = db.select(db.ordenesTable).join([
      innerJoin(db.clientesTable, db.clientesTable.id.equalsExp(db.ordenesTable.clienteId)),
      innerJoin(db.equiposTable, db.equiposTable.id.equalsExp(db.ordenesTable.equipoId)),
      leftOuterJoin(db.usuariosTable, db.usuariosTable.id.equalsExp(db.ordenesTable.tecnicoId)),
    ])..where(db.ordenesTable.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final ordenData = row.readTable(db.ordenesTable);
    final clienteData = row.readTable(db.clientesTable);
    final equipoData = row.readTable(db.equiposTable);
    final tecnicoData = row.readTableOrNull(db.usuariosTable);

    return Mappers.toDomainOrden(
      ordenData,
      cliente: Mappers.toDomainCliente(clienteData),
      equipo: Mappers.toDomainEquipo(equipoData),
      tecnico: tecnicoData != null ? Mappers.toDomainUsuario(tecnicoData) : null,
    );
  }

  @override
  Future<void> asignarTecnico(int ordenId, int tecnicoId) async {
    await (db.update(db.ordenesTable)..where((tbl) => tbl.id.equals(ordenId))).write(
      OrdenesTableCompanion(
        tecnicoId: Value(tecnicoId),
      ),
    );
  }

  // ===================== CLIENTES Y CONSULTA PÚBLICA =====================

  @override
  Future<Cliente?> findClienteByDocumento(String documento) async {
    final q = db.select(db.clientesTable)..where((tbl) => tbl.numeroDocumento.equals(documento.trim()));
    final data = await q.getSingleOrNull();
    if (data == null) return null;
    return Mappers.toDomainCliente(data);
  }

  @override
  Future<List<Cliente>> searchClientes(String query) async {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) {
      final list = await (db.select(db.clientesTable)..limit(5)).get();
      return list.map(Mappers.toDomainCliente).toList();
    }
    final q = db.select(db.clientesTable)
      ..where((tbl) =>
          tbl.numeroDocumento.like('%$clean%') |
          tbl.nombreCompleto.lower().like('%$clean%') |
          tbl.telefono.like('%$clean%') |
          tbl.email.lower().like('%$clean%'))
      ..limit(5);
    final list = await q.get();
    return list.map(Mappers.toDomainCliente).toList();
  }

  @override
  Future<Orden?> consultaPublica(String codigoOOT, String documento) async {
    final cleanCode = codigoOOT.trim().toUpperCase().replaceAll('#', '');
    final cleanDoc = documento.trim();

    final query = db.select(db.ordenesTable).join([
      innerJoin(db.clientesTable, db.clientesTable.id.equalsExp(db.ordenesTable.clienteId)),
      innerJoin(db.equiposTable, db.equiposTable.id.equalsExp(db.ordenesTable.equipoId)),
      leftOuterJoin(db.usuariosTable, db.usuariosTable.id.equalsExp(db.ordenesTable.tecnicoId)),
    ])
      ..where(
        (db.ordenesTable.codigoOrden.equals(cleanCode) | db.ordenesTable.codigoOrden.equals('ORD-$cleanCode') | db.ordenesTable.codigoOrden.like('%$cleanCode%')) &
            db.clientesTable.numeroDocumento.equals(cleanDoc),
      );

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final ordenData = row.readTable(db.ordenesTable);
    final clienteData = row.readTable(db.clientesTable);
    final equipoData = row.readTable(db.equiposTable);
    final tecnicoData = row.readTableOrNull(db.usuariosTable);

    return Mappers.toDomainOrden(
      ordenData,
      cliente: Mappers.toDomainCliente(clienteData),
      equipo: Mappers.toDomainEquipo(equipoData),
      tecnico: tecnicoData != null ? Mappers.toDomainUsuario(tecnicoData) : null,
    );
  }

  @override
  Future<Map<String, dynamic>> consultarPublico(String query) async {
    final clean = query.trim().toUpperCase().replaceAll('#', '');
    if (clean.isEmpty) return {'tipo': 'ninguno'};

    // 1. Buscar por Código de Ticket / Orden (ej: ORD-2026-0001, TCK-2026-7311, 0001)
    final ordenQuery = db.select(db.ordenesTable).join([
      innerJoin(db.clientesTable, db.clientesTable.id.equalsExp(db.ordenesTable.clienteId)),
      innerJoin(db.equiposTable, db.equiposTable.id.equalsExp(db.ordenesTable.equipoId)),
      leftOuterJoin(db.usuariosTable, db.usuariosTable.id.equalsExp(db.ordenesTable.tecnicoId)),
    ])..where(
        db.ordenesTable.codigoOrden.equals(clean) |
        db.ordenesTable.codigoOrden.equals('ORD-$clean') |
        db.ordenesTable.codigoOrden.equals('TCK-$clean') |
        db.ordenesTable.codigoOrden.like('%$clean%'),
      );

    final ordenRow = await ordenQuery.getSingleOrNull();
    if (ordenRow != null) {
      final ordenData = ordenRow.readTable(db.ordenesTable);
      final clienteData = ordenRow.readTable(db.clientesTable);
      final equipoData = ordenRow.readTable(db.equiposTable);
      final tecnicoData = ordenRow.readTableOrNull(db.usuariosTable);

      final domainOrden = Mappers.toDomainOrden(
        ordenData,
        cliente: Mappers.toDomainCliente(clienteData),
        equipo: Mappers.toDomainEquipo(equipoData),
        tecnico: tecnicoData != null ? Mappers.toDomainUsuario(tecnicoData) : null,
      );

      final ot = await getFormatoOt(domainOrden.id!);
      final fotos = await getFotosEvidencia(domainOrden.id!);

      return {
        'tipo': 'ticket',
        'orden': domainOrden,
        'formatoOt': ot,
        'fotos': fotos,
      };
    }

    // 2. Buscar por Número de Serie de Equipo (ej: MESA-MUFMU3JX, PF2K890X)
    final equipoData = await (db.select(db.equiposTable)
          ..where((tbl) => tbl.numeroSerie.equals(clean) | tbl.numeroSerie.like('%$clean%')))
        .getSingleOrNull();
    if (equipoData != null) {
      final domainEquipo = Mappers.toDomainEquipo(equipoData);
      final historial = await getHistorialEquipo(domainEquipo.id!);
      return {
        'tipo': 'equipo',
        'equipo': domainEquipo,
        'historial': historial,
      };
    }

    // 3. Buscar por Cédula / NIT de Cliente (ej: 1020304050, 901.442.112-3)
    final clienteData = await (db.select(db.clientesTable)
          ..where((tbl) => tbl.numeroDocumento.equals(clean) | tbl.numeroDocumento.like('%$clean%')))
        .getSingleOrNull();
    if (clienteData != null) {
      final domainCliente = Mappers.toDomainCliente(clienteData);
      final ordenesCliente = await getOrdenesByClienteId(domainCliente.id!);
      return {
        'tipo': 'cliente',
        'cliente': domainCliente,
        'ordenes': ordenesCliente,
      };
    }

    return {'tipo': 'no_encontrado'};
  }

  @override
  Future<Cliente> saveCliente(Cliente cliente) async {
    final existing = await (db.select(db.clientesTable)..where((t) => t.numeroDocumento.equals(cliente.numeroDocumento.trim()))).getSingleOrNull();
    if (existing != null) {
      await (db.update(db.clientesTable)..where((t) => t.id.equals(existing.id))).write(
        ClientesTableCompanion(
          tipoDocumento: Value(cliente.tipoDocumento),
          nombreCompleto: Value(cliente.nombreCompleto),
          telefono: Value(cliente.telefono),
          email: Value(cliente.email),
          direccion: Value(cliente.direccion),
        ),
      );
      return cliente.copyWith(id: existing.id);
    } else {
      final id = await db.into(db.clientesTable).insert(
        ClientesTableCompanion(
          tipoDocumento: Value(cliente.tipoDocumento),
          numeroDocumento: Value(cliente.numeroDocumento.trim()),
          nombreCompleto: Value(cliente.nombreCompleto),
          telefono: Value(cliente.telefono),
          email: Value(cliente.email),
          direccion: Value(cliente.direccion),
        ),
      );
      return cliente.copyWith(id: id);
    }
  }

  @override
  Future<List<Equipo>> getEquiposByClienteId(int clienteId) async {
    final list = await (db.select(db.equiposTable)..where((tbl) => tbl.clienteId.equals(clienteId))).get();
    return list.map(Mappers.toDomainEquipo).toList();
  }

  @override
  Future<List<Equipo>> searchEquipos({int? clienteId, String? tipo, String? query}) async {
    final clean = (query ?? '').trim().toLowerCase();
    final q = db.select(db.equiposTable);
    if (clienteId != null) {
      q.where((tbl) => tbl.clienteId.equals(clienteId));
    }
    if (tipo != null && tipo.isNotEmpty) {
      q.where((tbl) => tbl.tipoEquipo.lower().like('%${tipo.toLowerCase()}%'));
    }
    if (clean.isNotEmpty) {
      q.where((tbl) =>
          tbl.numeroSerie.lower().like('%$clean%') |
          tbl.marca.lower().like('%$clean%') |
          tbl.modelo.lower().like('%$clean%'));
    }
    q.limit(10);
    final rows = await q.get();
    return rows.map(Mappers.toDomainEquipo).toList();
  }

  @override
  Future<List<Orden>> getOrdenesByClienteId(int clienteId) async {
    final query = db.select(db.ordenesTable).join([
      innerJoin(db.clientesTable, db.clientesTable.id.equalsExp(db.ordenesTable.clienteId)),
      innerJoin(db.equiposTable, db.equiposTable.id.equalsExp(db.ordenesTable.equipoId)),
    ])..where(db.ordenesTable.clienteId.equals(clienteId));

    final rows = await query.get();
    return rows.map((r) {
      return Mappers.toDomainOrden(
        r.readTable(db.ordenesTable),
        cliente: Mappers.toDomainCliente(r.readTable(db.clientesTable)),
        equipo: Mappers.toDomainEquipo(r.readTable(db.equiposTable)),
      );
    }).toList();
  }

  // ===================== REGISTRO DE ÓRDENES =====================

  @override
  Future<String> registrarOrdenCompleta({
    required Cliente cliente,
    required Equipo equipo,
    required Orden orden,
    String? fotoIngresoBase64,
  }) async {
    return await db.transaction(() async {
      // 1. Cliente
      int clienteId;
      final existingCliente = await (db.select(db.clientesTable)
            ..where((tbl) => tbl.numeroDocumento.equals(cliente.numeroDocumento)))
          .getSingleOrNull();

      if (existingCliente != null) {
        clienteId = existingCliente.id;
        await (db.update(db.clientesTable)..where((tbl) => tbl.id.equals(clienteId))).write(
          ClientesTableCompanion(
            tipoDocumento: Value(cliente.tipoDocumento),
            nombreCompleto: Value(cliente.nombreCompleto),
            telefono: Value(cliente.telefono),
            email: Value(cliente.email),
            direccion: Value(cliente.direccion),
          ),
        );
      } else {
        clienteId = await db.into(db.clientesTable).insert(
              ClientesTableCompanion(
                tipoDocumento: Value(cliente.tipoDocumento),
                numeroDocumento: Value(cliente.numeroDocumento),
                nombreCompleto: Value(cliente.nombreCompleto),
                telefono: Value(cliente.telefono),
                email: Value(cliente.email),
                direccion: Value(cliente.direccion),
              ),
            );
      }

      // 2. Equipo
      final equipoId = await db.into(db.equiposTable).insert(
            EquiposTableCompanion(
              clienteId: Value(clienteId),
              tipoEquipo: Value(equipo.tipoEquipo),
              marca: Value(equipo.marca),
              modelo: Value(equipo.modelo),
              numeroSerie: Value(equipo.numeroSerie),
              sistemaOperativo: Value(equipo.sistemaOperativo),
              procesador: Value(equipo.procesador),
              memoriaRam: Value(equipo.memoriaRam),
              almacenamiento: Value(equipo.almacenamiento),
              tarjetaGrafica: Value(equipo.tarjetaGrafica),
              estadoEquipo: const Value('EN_TALLER'),
            ),
          );

      // 3. Código Único de Orden
      final count = await db.ordenesTable.count().getSingle();
      final year = DateTime.now().year;
      final sequential = (count + 1).toString().padLeft(4, '0');
      final codigoGenerado = 'ORD-$year-$sequential';

      // 4. Cálculo de SLA: 48h para Correctivo, 72h para Preventivo
      final horasSla = orden.tipoServicio == 'CORRECTIVO' ? 48 : 72;
      final fechaLimiteSla = DateTime.now().add(Duration(hours: horasSla));

      // 5. Orden
      final ordenId = await db.into(db.ordenesTable).insert(
            OrdenesTableCompanion(
              codigoOrden: Value(codigoGenerado),
              clienteId: Value(clienteId),
              equipoId: Value(equipoId),
              tecnicoId: Value(orden.tecnicoId),
              solicitanteId: Value(orden.solicitanteId),
              tipoServicio: Value(orden.tipoServicio),
              categoriaFalla: Value(orden.categoriaFalla),
              prioridad: Value(orden.prioridad),
              titulo: Value(orden.titulo),
              descripcion: Value(orden.descripcion),
              estado: const Value('RECIBIDO'),
              fechaIngreso: Value(DateTime.now()),
              fechaLimiteSla: Value(fechaLimiteSla),
            ),
          );

      // 6. Formatos iniciales
      await db.into(db.formatoOtTable).insert(
            FormatoOtTableCompanion(
              ordenId: Value(ordenId),
              diagnosticoPreliminar: const Value('Pendiente de revisión técnica en mesón de trabajo'),
              herramientasChips: const Value('[]'),
              encendidoInicial: const Value(true),
            ),
          );

      await db.into(db.formatoActividadesTable).insert(
            FormatoActividadesTableCompanion(
              ordenId: Value(ordenId),
              costoManoObra: const Value(0.0),
            ),
          );

      // 7. Evidencia inicial
      if (fotoIngresoBase64 != null && fotoIngresoBase64.isNotEmpty) {
        await db.into(db.fotosEvidenciaTable).insert(
              FotosEvidenciaTableCompanion(
                ordenId: Value(ordenId),
                etapa: const Value('RECEPCION'),
                rutaOBytesBase64: Value(fotoIngresoBase64),
                notaTecnica: const Value('Foto de ingreso y estado estético en recepción'),
                fechaCaptura: Value(DateTime.now()),
              ),
            );
      }

      return codigoGenerado;
    });
  }

  // ===================== FORMATOS SENA =====================

  @override
  Future<FormatoOt?> getFormatoOt(int ordenId) async {
    final data = await (db.select(db.formatoOtTable)..where((tbl) => tbl.ordenId.equals(ordenId))).getSingleOrNull();
    if (data == null) return null;
    return Mappers.toDomainFormatoOt(data);
  }

  @override
  Future<void> saveFormatoOt(FormatoOt formatoOt) async {
    final existing = await (db.select(db.formatoOtTable)..where((tbl) => tbl.ordenId.equals(formatoOt.ordenId))).getSingleOrNull();
    final jsonChips = jsonEncode(formatoOt.herramientasChips);

    if (existing != null) {
      await (db.update(db.formatoOtTable)..where((tbl) => tbl.ordenId.equals(formatoOt.ordenId))).write(
        FormatoOtTableCompanion(
          diagnosticoPreliminar: Value(formatoOt.diagnosticoPreliminar),
          herramientasChips: Value(jsonChips),
          tiempoEstimadoEntrega: Value(formatoOt.tiempoEstimadoEntrega),
          accesorioCargador: Value(formatoOt.accesorioCargador),
          accesorioCablePoder: Value(formatoOt.accesorioCablePoder),
          accesorioMouse: Value(formatoOt.accesorioMouse),
          accesorioMaletin: Value(formatoOt.accesorioMaletin),
          encendidoInicial: Value(formatoOt.encendidoInicial),
          estadoCarcasa: Value(formatoOt.estadoCarcasa),
          pinContrasena: Value(formatoOt.pinContrasena),
        ),
      );
    } else {
      await db.into(db.formatoOtTable).insert(
            FormatoOtTableCompanion(
              ordenId: Value(formatoOt.ordenId),
              diagnosticoPreliminar: Value(formatoOt.diagnosticoPreliminar),
              herramientasChips: Value(jsonChips),
              tiempoEstimadoEntrega: Value(formatoOt.tiempoEstimadoEntrega),
              accesorioCargador: Value(formatoOt.accesorioCargador),
              accesorioCablePoder: Value(formatoOt.accesorioCablePoder),
              accesorioMouse: Value(formatoOt.accesorioMouse),
              accesorioMaletin: Value(formatoOt.accesorioMaletin),
              encendidoInicial: Value(formatoOt.encendidoInicial),
              estadoCarcasa: Value(formatoOt.estadoCarcasa),
              pinContrasena: Value(formatoOt.pinContrasena),
            ),
          );
    }
  }

  @override
  Future<FormatoActividades?> getFormatoActividades(int ordenId) async {
    final data = await (db.select(db.formatoActividadesTable)..where((tbl) => tbl.ordenId.equals(ordenId))).getSingleOrNull();
    if (data == null) return null;
    return Mappers.toDomainFormatoActividades(data);
  }

  @override
  Future<void> saveFormatoActividades(FormatoActividades act) async {
    final existing = await (db.select(db.formatoActividadesTable)..where((tbl) => tbl.ordenId.equals(act.ordenId))).getSingleOrNull();

    if (existing != null) {
      await (db.update(db.formatoActividadesTable)..where((tbl) => tbl.ordenId.equals(act.ordenId))).write(
        FormatoActividadesTableCompanion(
          procedimientosRealizados: Value(act.procedimientosRealizados),
          pastaTermica: Value(act.pastaTermica),
          alcoholIsopropilico: Value(act.alcoholIsopropilico),
          sopleteadoContactos: Value(act.sopleteadoContactos),
          brochaAntiestatica: Value(act.brochaAntiestatica),
          panoMicrofibra: Value(act.panoMicrofibra),
          depuracionTemporales: Value(act.depuracionTemporales),
          optimizacionInicio: Value(act.optimizacionInicio),
          escaneoMalware: Value(act.escaneoMalware),
          actualizacionDrivers: Value(act.actualizacionDrivers),
          comprobacionDisco: Value(act.comprobacionDisco),
          qaEstresTermico: Value(act.qaEstresTermico),
          qaPuertos: Value(act.qaPuertos),
          qaConectividad: Value(act.qaConectividad),
          qaBateria: Value(act.qaBateria),
          qaTecladoTouchpad: Value(act.qaTecladoTouchpad),
          costoManoObra: Value(act.costoManoObra),
        ),
      );
    } else {
      await db.into(db.formatoActividadesTable).insert(
            FormatoActividadesTableCompanion(
              ordenId: Value(act.ordenId),
              procedimientosRealizados: Value(act.procedimientosRealizados),
              pastaTermica: Value(act.pastaTermica),
              alcoholIsopropilico: Value(act.alcoholIsopropilico),
              sopleteadoContactos: Value(act.sopleteadoContactos),
              brochaAntiestatica: Value(act.brochaAntiestatica),
              panoMicrofibra: Value(act.panoMicrofibra),
              depuracionTemporales: Value(act.depuracionTemporales),
              optimizacionInicio: Value(act.optimizacionInicio),
              escaneoMalware: Value(act.escaneoMalware),
              actualizacionDrivers: Value(act.actualizacionDrivers),
              comprobacionDisco: Value(act.comprobacionDisco),
              qaEstresTermico: Value(act.qaEstresTermico),
              qaPuertos: Value(act.qaPuertos),
              qaConectividad: Value(act.qaConectividad),
              qaBateria: Value(act.qaBateria),
              qaTecladoTouchpad: Value(act.qaTecladoTouchpad),
              costoManoObra: Value(act.costoManoObra),
            ),
          );
    }
  }

  @override
  Future<List<Repuesto>> getRepuestos(int ordenId) async {
    final list = await (db.select(db.repuestosOrdenTable)..where((tbl) => tbl.ordenId.equals(ordenId))).get();
    return list.map(Mappers.toDomainRepuesto).toList();
  }

  @override
  Future<void> addRepuesto(Repuesto repuesto) async {
    await db.into(db.repuestosOrdenTable).insert(
          RepuestosOrdenTableCompanion(
            ordenId: Value(repuesto.ordenId),
            referencia: Value(repuesto.referencia),
            cantidad: Value(repuesto.cantidad),
            precioUnitario: Value(repuesto.precioUnitario),
            subtotal: Value(repuesto.subtotal),
          ),
        );
  }

  @override
  Future<void> deleteRepuesto(int repuestoId) async {
    await (db.delete(db.repuestosOrdenTable)..where((tbl) => tbl.id.equals(repuestoId))).go();
  }

  @override
  Future<List<FotoEvidencia>> getFotosEvidencia(int ordenId) async {
    final list = await (db.select(db.fotosEvidenciaTable)..where((tbl) => tbl.ordenId.equals(ordenId))).get();
    return list.map(Mappers.toDomainFoto).toList();
  }

  @override
  Future<void> addFotoEvidencia(FotoEvidencia foto) async {
    await db.into(db.fotosEvidenciaTable).insert(
          FotosEvidenciaTableCompanion(
            ordenId: Value(foto.ordenId),
            etapa: Value(foto.etapa),
            rutaOBytesBase64: Value(foto.rutaOBytesBase64),
            notaTecnica: Value(foto.notaTecnica),
            fechaCaptura: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> deleteFotoEvidencia(int fotoId) async {
    await (db.delete(db.fotosEvidenciaTable)..where((tbl) => tbl.id.equals(fotoId))).go();
  }

  @override
  Future<FormatoActaEntrega?> getActaEntrega(int ordenId) async {
    final data = await (db.select(db.formatoActaEntregaTable)..where((tbl) => tbl.ordenId.equals(ordenId))).getSingleOrNull();
    if (data == null) return null;
    return Mappers.toDomainActaEntrega(data);
  }

  @override
  Future<void> cerrarOrdenConActa(FormatoActaEntrega acta) async {
    await db.transaction(() async {
      final existing = await (db.select(db.formatoActaEntregaTable)..where((tbl) => tbl.ordenId.equals(acta.ordenId))).getSingleOrNull();

      if (existing != null) {
        await (db.update(db.formatoActaEntregaTable)..where((tbl) => tbl.ordenId.equals(acta.ordenId))).write(
          FormatoActaEntregaTableCompanion(
            estadoOperatividad: Value(acta.estadoOperatividad),
            observaciones: Value(acta.observaciones),
            recomendacionesCuidado: Value(acta.recomendacionesCuidado),
            garantiaDias: Value(acta.garantiaDias),
            personaRecibeNombre: Value(acta.personaRecibeNombre),
            personaRecibeDocumento: Value(acta.personaRecibeDocumento),
            checkConformidad: Value(acta.checkConformidad),
            fechaEntrega: Value(DateTime.now()),
          ),
        );
      } else {
        await db.into(db.formatoActaEntregaTable).insert(
              FormatoActaEntregaTableCompanion(
                ordenId: Value(acta.ordenId),
                estadoOperatividad: Value(acta.estadoOperatividad),
                observaciones: Value(acta.observaciones),
                recomendacionesCuidado: Value(acta.recomendacionesCuidado),
                garantiaDias: Value(acta.garantiaDias),
                personaRecibeNombre: Value(acta.personaRecibeNombre),
                personaRecibeDocumento: Value(acta.personaRecibeDocumento),
                checkConformidad: Value(acta.checkConformidad),
                fechaEntrega: Value(DateTime.now()),
              ),
            );
      }

      // Marcar orden como cerrada
      await (db.update(db.ordenesTable)..where((tbl) => tbl.id.equals(acta.ordenId))).write(
        OrdenesTableCompanion(
          estado: const Value('ENTREGADO_CERRADO'),
          fechaCierre: Value(DateTime.now()),
        ),
      );

      // Actualizar estado del equipo a OPERATIVO
      final orden = await (db.select(db.ordenesTable)..where((tbl) => tbl.id.equals(acta.ordenId))).getSingle();
      await (db.update(db.equiposTable)..where((tbl) => tbl.id.equals(orden.equipoId))).write(
        EquiposTableCompanion(
          estadoEquipo: Value(acta.estadoOperatividad == 'OPERATIVO' ? 'OPERATIVO' : 'DE_BAJA'),
        ),
      );
    });
  }

  @override
  Future<void> updateEstadoOrden(int ordenId, String nuevoEstado) async {
    await (db.update(db.ordenesTable)..where((tbl) => tbl.id.equals(ordenId))).write(
      OrdenesTableCompanion(
        estado: Value(nuevoEstado),
      ),
    );
  }

  // ===================== INVENTARIO DE EQUIPOS Y HOJA DE VIDA =====================

  @override
  Future<List<Equipo>> getInventarioEquipos({String? tipo, String? estado, String? busqueda}) async {
    final query = db.select(db.equiposTable);

    if (tipo != null && tipo.isNotEmpty && tipo != 'TODOS') {
      query.where((tbl) => tbl.tipoEquipo.equals(tipo));
    }

    if (estado != null && estado.isNotEmpty && estado != 'TODOS') {
      query.where((tbl) => tbl.estadoEquipo.equals(estado));
    }

    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = '%${busqueda.trim().toLowerCase()}%';
      query.where((tbl) => tbl.numeroSerie.lower().like(q) | tbl.marca.lower().like(q) | tbl.modelo.lower().like(q));
    }

    query.orderBy([(tbl) => OrderingTerm.desc(tbl.id)]);
    final list = await query.get();
    return list.map(Mappers.toDomainEquipo).toList();
  }

  @override
  Future<List<Orden>> getHistorialEquipo(int equipoId) async {
    final query = db.select(db.ordenesTable).join([
      innerJoin(db.clientesTable, db.clientesTable.id.equalsExp(db.ordenesTable.clienteId)),
      innerJoin(db.equiposTable, db.equiposTable.id.equalsExp(db.ordenesTable.equipoId)),
      leftOuterJoin(db.usuariosTable, db.usuariosTable.id.equalsExp(db.ordenesTable.tecnicoId)),
    ])..where(db.ordenesTable.equipoId.equals(equipoId));

    query.orderBy([OrderingTerm.desc(db.ordenesTable.fechaIngreso)]);
    final rows = await query.get();
    return rows.map((r) {
      return Mappers.toDomainOrden(
        r.readTable(db.ordenesTable),
        cliente: Mappers.toDomainCliente(r.readTable(db.clientesTable)),
        equipo: Mappers.toDomainEquipo(r.readTable(db.equiposTable)),
        tecnico: r.readTableOrNull(db.usuariosTable) != null ? Mappers.toDomainUsuario(r.readTable(db.usuariosTable)) : null,
      );
    }).toList();
  }

  @override
  Future<void> updateEstadoEquipo(int equipoId, String nuevoEstado) async {
    await (db.update(db.equiposTable)..where((tbl) => tbl.id.equals(equipoId))).write(
      EquiposTableCompanion(estadoEquipo: Value(nuevoEstado)),
    );
  }

  // ===================== CONFIGURACIÓN DE EMPRESA Y SMTP =====================

  @override
  Future<EmpresaConfig> getEmpresaConfig() async {
    final list = await db.select(db.configuracionEmpresaTable).get();
    if (list.isEmpty) {
      return const EmpresaConfig.defaultConfig();
    }
    return Mappers.toDomainEmpresaConfig(list.first);
  }

  @override
  Future<void> saveEmpresaConfig(EmpresaConfig config) async {
    final list = await db.select(db.configuracionEmpresaTable).get();
    if (list.isEmpty) {
      await db.into(db.configuracionEmpresaTable).insert(
            ConfiguracionEmpresaTableCompanion(
              nombreEmpresa: Value(config.nombreEmpresa),
              slogan: Value(config.slogan),
              nit: Value(config.nit),
              telefono: Value(config.telefono),
              email: Value(config.email),
              direccion: Value(config.direccion),
              ciudad: Value(config.ciudad),
              logoBase64: Value(config.logoBase64),
              smtpHost: Value(config.smtpHost),
              smtpPort: Value(config.smtpPort),
              smtpUser: Value(config.smtpUser),
              smtpPass: Value(config.smtpPass),
              colorPrimario: Value(config.colorPrimario),
              colorSecundario: Value(config.colorSecundario),
              isSetupCompleted: Value(config.isSetupCompleted),
            ),
          );
    } else {
      final existingId = list.first.id;
      await (db.update(db.configuracionEmpresaTable)..where((tbl) => tbl.id.equals(existingId))).write(
        ConfiguracionEmpresaTableCompanion(
          nombreEmpresa: Value(config.nombreEmpresa),
          slogan: Value(config.slogan),
          nit: Value(config.nit),
          telefono: Value(config.telefono),
          email: Value(config.email),
          direccion: Value(config.direccion),
          ciudad: Value(config.ciudad),
          logoBase64: Value(config.logoBase64),
          smtpHost: Value(config.smtpHost),
          smtpPort: Value(config.smtpPort),
          smtpUser: Value(config.smtpUser),
          smtpPass: Value(config.smtpPass),
          colorPrimario: Value(config.colorPrimario),
          colorSecundario: Value(config.colorSecundario),
          isSetupCompleted: Value(config.isSetupCompleted),
        ),
      );
    }
  }

  @override
  Stream<EmpresaConfig> watchEmpresaConfig() {
    return db.select(db.configuracionEmpresaTable).watch().map((list) {
      if (list.isEmpty) {
        return const EmpresaConfig.defaultConfig();
      }
      return Mappers.toDomainEmpresaConfig(list.first);
    });
  }

  // ===================== AUDITORÍA DE NOTIFICACIONES =====================

  @override
  Future<List<NotificacionAuditoria>> getAuditoriaNotificaciones() async {
    final query = db.select(db.notificacionesAuditoriaTable)..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]);
    final list = await query.get();
    return list.map(Mappers.toDomainNotificacion).toList();
  }

  @override
  Future<void> registrarNotificacion(NotificacionAuditoria notif) async {
    await db.into(db.notificacionesAuditoriaTable).insert(
          NotificacionesAuditoriaTableCompanion(
            destinatario: Value(notif.destinatario),
            asunto: Value(notif.asunto),
            evento: Value(notif.evento),
            estado: Value(notif.estado),
            fechaEnvio: Value(DateTime.now()),
          ),
        );
  }

  // ===================== CATÁLOGO DE TIPOS DE FALLAS =====================

  @override
  Future<List<TipoFalla>> getTiposFalla({String? tipoServicio}) async {
    final query = db.select(db.tiposFallaTable);
    if (tipoServicio != null) {
      query.where((tbl) => tbl.tipoServicio.equals(tipoServicio));
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.nombre)]);
    final rows = await query.get();
    return rows.map((r) => TipoFalla(
      id: r.id,
      tipoServicio: r.tipoServicio,
      nombre: r.nombre,
      descripcion: r.descripcion,
      activo: r.activo,
      createdAt: r.createdAt,
    )).toList();
  }

  @override
  Future<TipoFalla> addTipoFalla(TipoFalla tipoFalla) async {
    final id = await db.into(db.tiposFallaTable).insert(
      TiposFallaTableCompanion(
        tipoServicio: Value(tipoFalla.tipoServicio),
        nombre: Value(tipoFalla.nombre.trim()),
        descripcion: Value(tipoFalla.descripcion),
        activo: Value(tipoFalla.activo),
      ),
      mode: InsertMode.insertOrReplace,
    );
    return tipoFalla.copyWith(id: id);
  }

  @override
  Future<void> deleteTipoFalla(int id) async {
    await (db.delete(db.tiposFallaTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<int> countTiposFalla() async {
    final countExp = db.tiposFallaTable.id.count();
    final query = db.selectOnly(db.tiposFallaTable)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}
