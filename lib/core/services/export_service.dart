import 'dart:convert';
import 'package:intl/intl.dart';
import '../../features/ordenes/domain/entities/cliente.dart';
import '../../features/ordenes/domain/entities/equipo.dart';
import '../../features/ordenes/domain/entities/orden.dart';
import '../../features/ordenes/domain/repositories/i_ordenes_repository.dart';
import '../utils/file_exporter.dart';

class ExportService {
  static String _escapeCsv(dynamic val) {
    if (val == null) return '""';
    final str = val.toString().replaceAll('"', '""');
    return '"$str"';
  }

  /// Exporta la lista de órdenes/tickets a archivo CSV (compatible con Excel y Google Sheets)
  static Future<String?> exportOrdenesCsv(List<Orden> ordenes) async {
    final sb = StringBuffer();
    // UTF-8 BOM para soporte de caracteres especiales y tildes en Excel
    sb.write('\uFEFF');
    
    // Encabezados
    sb.writeln(
      'Codigo,Cliente,Documento,Telefono,Direccion,TipoEquipo,Marca,Modelo,Serie,TipoServicio,CategoriaFalla,Prioridad,Estado,Tecnico,Solicitante,FechaIngreso,FechaLimiteSLA,FechaCierre,Titulo,Descripcion'
    );

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    for (final o in ordenes) {
      sb.writeln([
        _escapeCsv(o.codigoOrden),
        _escapeCsv(o.cliente?.nombreCompleto ?? ''),
        _escapeCsv(o.cliente?.numeroDocumento ?? ''),
        _escapeCsv(o.cliente?.telefono ?? ''),
        _escapeCsv(o.cliente?.direccion ?? ''),
        _escapeCsv(o.equipo?.tipoEquipo ?? ''),
        _escapeCsv(o.equipo?.marca ?? ''),
        _escapeCsv(o.equipo?.modelo ?? ''),
        _escapeCsv(o.equipo?.numeroSerie ?? ''),
        _escapeCsv(o.tipoServicio),
        _escapeCsv(o.categoriaFalla),
        _escapeCsv(o.prioridad),
        _escapeCsv(o.estado),
        _escapeCsv(o.tecnico?.nombre ?? 'Sin Asignar'),
        _escapeCsv(o.solicitanteId != null ? 'Usuario #${o.solicitanteId}' : 'No registrado'),
        _escapeCsv(dateFormat.format(o.fechaIngreso)),
        _escapeCsv(o.fechaLimiteSla != null ? dateFormat.format(o.fechaLimiteSla!) : ''),
        _escapeCsv(o.fechaCierre != null ? dateFormat.format(o.fechaCierre!) : ''),
        _escapeCsv(o.titulo),
        _escapeCsv(o.descripcion),
      ].join(','));
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'reporte_tickets_santi_$timestamp.csv';

    return await FileExporter.exportFile(
      fileName: fileName,
      content: sb.toString(),
      mimeType: 'text/csv;charset=utf-8',
    );
  }

  /// Exporta el listado de Clientes y Equipos a CSV
  static Future<String?> exportClientesEquiposCsv({
    required List<Cliente> clientes,
    required List<Equipo> equipos,
  }) async {
    final sb = StringBuffer();
    sb.write('\uFEFF');
    sb.writeln('Documento,TipoDoc,Cliente,Telefono,Email,Direccion,TotalEquipos,FechaRegistro');

    final dateFormat = DateFormat('yyyy-MM-dd');

    for (final c in clientes) {
      final equiposCliente = equipos.where((e) => e.clienteId == c.id).length;
      sb.writeln([
        _escapeCsv(c.numeroDocumento),
        _escapeCsv(c.tipoDocumento),
        _escapeCsv(c.nombreCompleto),
        _escapeCsv(c.telefono),
        _escapeCsv(c.email ?? ''),
        _escapeCsv(c.direccion),
        _escapeCsv(equiposCliente),
        _escapeCsv(c.createdAt != null ? dateFormat.format(c.createdAt!) : ''),
      ].join(','));
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'clientes_equipos_santi_$timestamp.csv';

    return await FileExporter.exportFile(
      fileName: fileName,
      content: sb.toString(),
      mimeType: 'text/csv;charset=utf-8',
    );
  }

  /// Exporta las órdenes en formato JSON estructurado
  static Future<String?> exportOrdenesJson(List<Orden> ordenes) async {
    final list = ordenes.map((o) => {
      'id': o.id,
      'codigoOrden': o.codigoOrden,
      'tipoServicio': o.tipoServicio,
      'categoriaFalla': o.categoriaFalla,
      'prioridad': o.prioridad,
      'estado': o.estado,
      'titulo': o.titulo,
      'descripcion': o.descripcion,
      'fechaIngreso': o.fechaIngreso.toIso8601String(),
      'fechaLimiteSla': o.fechaLimiteSla?.toIso8601String(),
      'fechaCierre': o.fechaCierre?.toIso8601String(),
      'cliente': o.cliente != null ? {
        'id': o.cliente!.id,
        'nombreCompleto': o.cliente!.nombreCompleto,
        'numeroDocumento': o.cliente!.numeroDocumento,
        'telefono': o.cliente!.telefono,
        'email': o.cliente!.email,
        'direccion': o.cliente!.direccion,
      } : null,
      'equipo': o.equipo != null ? {
        'id': o.equipo!.id,
        'tipoEquipo': o.equipo!.tipoEquipo,
        'marca': o.equipo!.marca,
        'modelo': o.equipo!.modelo,
        'numeroSerie': o.equipo!.numeroSerie,
      } : null,
      'tecnico': o.tecnico != null ? {
        'id': o.tecnico!.id,
        'nombre': o.tecnico!.nombre,
        'email': o.tecnico!.email,
      } : null,
    }).toList();

    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert({
      'exportDate': DateTime.now().toIso8601String(),
      'total': ordenes.length,
      'ordenes': list,
    });

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'tickets_santi_$timestamp.json';

    return await FileExporter.exportFile(
      fileName: fileName,
      content: jsonStr,
      mimeType: 'application/json;charset=utf-8',
    );
  }

  /// Realiza un respaldo completo (Full Backup) de toda la base de datos a formato JSON
  static Future<String?> exportFullBackup(IOrdenesRepository repo) async {
    final empresa = await repo.getEmpresaConfig();
    final usuarios = await repo.getUsuarios();
    final clientes = await repo.searchClientes('');
    final equipos = await repo.getInventarioEquipos();
    final ordenes = await repo.getOrdenes();
    final fallas = await repo.getTiposFalla();
    final notificaciones = await repo.getAuditoriaNotificaciones();

    final backupData = {
      'version': '1.0',
      'sistema': 'Santi Inc — Software de Mantenimiento & Tickets',
      'fechaBackup': DateTime.now().toIso8601String(),
      'estadisticas': {
        'totalUsuarios': usuarios.length,
        'totalClientes': clientes.length,
        'totalEquipos': equipos.length,
        'totalOrdenes': ordenes.length,
        'totalTiposFalla': fallas.length,
        'totalNotificaciones': notificaciones.length,
      },
      'datos': {
        'empresaConfig': {
          'nombreEmpresa': empresa.nombreEmpresa,
          'slogan': empresa.slogan,
          'nit': empresa.nit,
          'telefono': empresa.telefono,
          'email': empresa.email,
          'direccion': empresa.direccion,
          'ciudad': empresa.ciudad,
          'smtpHost': empresa.smtpHost,
          'smtpPort': empresa.smtpPort,
          'smtpUser': empresa.smtpUser,
          'colorPrimario': empresa.colorPrimario,
        },
        'usuarios': usuarios.map((u) => {
          'id': u.id,
          'nombre': u.nombre,
          'email': u.email,
          'rol': u.rol,
          'documento': u.documento,
          'telefono': u.telefono,
          'activo': u.activo,
          'createdAt': u.createdAt?.toIso8601String(),
        }).toList(),
        'clientes': clientes.map((c) => {
          'id': c.id,
          'tipoDocumento': c.tipoDocumento,
          'numeroDocumento': c.numeroDocumento,
          'nombreCompleto': c.nombreCompleto,
          'telefono': c.telefono,
          'email': c.email,
          'direccion': c.direccion,
          'createdAt': c.createdAt?.toIso8601String(),
        }).toList(),
        'equipos': equipos.map((e) => {
          'id': e.id,
          'clienteId': e.clienteId,
          'tipoEquipo': e.tipoEquipo,
          'marca': e.marca,
          'modelo': e.modelo,
          'numeroSerie': e.numeroSerie,
          'procesador': e.procesador,
          'memoriaRam': e.memoriaRam,
          'almacenamiento': e.almacenamiento,
          'sistemaOperativo': e.sistemaOperativo,
          'estadoEquipo': e.estadoEquipo,
          'createdAt': e.createdAt?.toIso8601String(),
        }).toList(),
        'ordenes': ordenes.map((o) => {
          'id': o.id,
          'codigoOrden': o.codigoOrden,
          'clienteId': o.clienteId,
          'equipoId': o.equipoId,
          'tecnicoId': o.tecnicoId,
          'solicitanteId': o.solicitanteId,
          'tipoServicio': o.tipoServicio,
          'categoriaFalla': o.categoriaFalla,
          'prioridad': o.prioridad,
          'titulo': o.titulo,
          'descripcion': o.descripcion,
          'estado': o.estado,
          'fechaIngreso': o.fechaIngreso.toIso8601String(),
          'fechaLimiteSla': o.fechaLimiteSla?.toIso8601String(),
          'fechaCierre': o.fechaCierre?.toIso8601String(),
        }).toList(),
        'tiposFalla': fallas.map((f) => {
          'id': f.id,
          'tipoServicio': f.tipoServicio,
          'nombre': f.nombre,
          'descripcion': f.descripcion,
          'activo': f.activo,
        }).toList(),
        'notificacionesAuditoria': notificaciones.map((n) => {
          'id': n.id,
          'destinatario': n.destinatario,
          'asunto': n.asunto,
          'evento': n.evento,
          'estado': n.estado,
          'fechaEnvio': n.fechaEnvio.toIso8601String(),
        }).toList(),
      }
    };

    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert(backupData);

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'backup_completo_santi_inc_$timestamp.json';

    return await FileExporter.exportFile(
      fileName: fileName,
      content: jsonStr,
      mimeType: 'application/json;charset=utf-8',
    );
  }
}
