import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

class ApiOrdenesRepository implements IOrdenesRepository {
  final String baseUrl;
  final StreamController<void> _refreshStream = StreamController<void>.broadcast();

  ApiOrdenesRepository({String? baseUrl})
      : baseUrl = baseUrl ?? (kIsWeb ? '' : 'http://localhost:3000');

  String _buildUrl(String path, [Map<String, dynamic>? queryParams]) {
    String base = baseUrl;
    if (base.isEmpty && kIsWeb && Uri.base.hasAuthority) {
      base = Uri.base.origin;
    }
    if (base.isEmpty) {
      base = 'http://localhost:3000';
    }
    if (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    final uri = Uri.parse('$base$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      final cleanParams = <String, String>{};
      queryParams.forEach((k, v) {
        if (v != null) cleanParams[k] = v.toString();
      });
      return uri.replace(queryParameters: cleanParams).toString();
    }
    return uri.toString();
  }

  void _notifyChange() {
    _refreshStream.add(null);
  }

  // ===================== AUTENTICACIÓN Y USUARIOS =====================

  @override
  Future<Usuario?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(_buildUrl('/api/auth/login')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['usuario'] != null) {
        return _mapUsuario(data['usuario']);
      }
    }
    return null;
  }

  @override
  Future<List<Usuario>> getUsuarios({String? rol}) async {
    final res = await http.get(Uri.parse(_buildUrl('/api/usuarios', {'rol': rol})));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['data'] is List) {
        return (data['data'] as List).map((u) => _mapUsuario(u)).toList();
      }
    }
    return [];
  }

  @override
  Future<Usuario> createUsuario(Usuario usuario) async {
    final res = await http.post(
      Uri.parse(_buildUrl('/api/usuarios')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'documento': usuario.documento,
        'telefono': usuario.telefono,
        'rol': usuario.rol,
        'activo': usuario.activo,
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['data'] != null) {
        _notifyChange();
        return _mapUsuario(data['data']);
      }
    }
    return usuario;
  }

  @override
  Future<void> updateUsuario(Usuario usuario) async {
    if (usuario.id == null) return;
    await http.put(
      Uri.parse(_buildUrl('/api/usuarios/${usuario.id}')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password': usuario.password,
        'documento': usuario.documento,
        'telefono': usuario.telefono,
        'rol': usuario.rol,
        'activo': usuario.activo,
      }),
    );
    _notifyChange();
  }

  @override
  Future<void> toggleUsuarioActivo(int id, bool activo) async {
    await http.put(
      Uri.parse(_buildUrl('/api/usuarios/$id/toggle-activo')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'activo': activo}),
    );
    _notifyChange();
  }

  @override
  Future<void> deleteUsuario(int id) async {
    await http.delete(Uri.parse(_buildUrl('/api/usuarios/$id')));
    _notifyChange();
  }

  @override
  Future<void> seedTestUsers() async {}

  // ===================== SETUP WIZARD =====================

  @override
  Future<bool> isSetupCompleted() async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/setup/status'))).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['isSetupCompleted'] == true;
      }
    } catch (_) {}
    return false;
  }

  @override
  Future<void> completeSetup({
    required EmpresaConfig empresa,
    required Usuario admin,
    Usuario? operador,
    Usuario? tecnico,
  }) async {
    await http.post(
      Uri.parse(_buildUrl('/api/setup')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'empresa': {
          'nombreEmpresa': empresa.nombreEmpresa,
          'nit': empresa.nit,
          'telefono': empresa.telefono,
          'email': empresa.email,
          'direccion': empresa.direccion,
          'ciudad': empresa.ciudad,
        },
        'admin': {
          'nombre': admin.nombre,
          'email': admin.email,
          'password': admin.password,
          'documento': admin.documento,
          'telefono': admin.telefono,
        },
        if (operador != null)
          'operador': {
            'nombre': operador.nombre,
            'email': operador.email,
            'password': operador.password,
            'documento': operador.documento,
            'telefono': operador.telefono,
          },
        if (tecnico != null)
          'tecnico': {
            'nombre': tecnico.nombre,
            'email': tecnico.email,
            'password': tecnico.password,
            'documento': tecnico.documento,
            'telefono': tecnico.telefono,
          },
      }),
    );
    _notifyChange();
  }

  // ===================== MÉTRICAS Y DASHBOARD =====================

  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/metrics/dashboard')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          final m = data['data'];
          return DashboardMetrics(
            totalOrdenes: m['totalTickets'] ?? 0,
            enTaller: m['ticketsEnTaller'] ?? 0,
            resueltos: m['ticketsListos'] ?? 0,
            entregadosCerrados: m['ticketsEntregados'] ?? 0,
          );
        }
      }
    } catch (_) {}
    return const DashboardMetrics.empty();
  }

  @override
  Future<Map<String, dynamic>> getAdminMetrics() async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/metrics/admin')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
    } catch (_) {}
    return {
      'total': 0,
      'vencidos': 0,
      'sinAsignar': 0,
      'preventivos': 0,
      'correctivos': 0,
      'tiempoPromedioHoras': 0.0,
      'cargaTecnicos': <Map<String, dynamic>>[],
    };
  }

  @override
  Stream<List<Orden>> watchOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId}) async* {
    yield await getOrdenes(busqueda: busqueda, estado: estado, tipo: tipo, tecnicoId: tecnicoId, solicitanteId: solicitanteId);
    yield* _refreshStream.stream.asyncMap((_) => getOrdenes(busqueda: busqueda, estado: estado, tipo: tipo, tecnicoId: tecnicoId, solicitanteId: solicitanteId));
  }

  @override
  Future<List<Orden>> getOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId}) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes', {
        'busqueda': busqueda,
        'estado': estado,
        'tipo': tipo,
        'tecnicoId': tecnicoId,
        'solicitanteId': solicitanteId,
      })));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((o) => _mapOrden(o)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<Orden?> getOrdenById(int id) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes/$id')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          return _mapOrden(data['data']);
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> asignarTecnico(int ordenId, int tecnicoId) async {
    await http.put(
      Uri.parse(_buildUrl('/api/ordenes/$ordenId/tecnico')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tecnicoId': tecnicoId}),
    );
    _notifyChange();
  }

  // ===================== CLIENTES Y CONSULTA PÚBLICA =====================

  @override
  Future<Cliente?> findClienteByDocumento(String documento) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/clientes/documento/$documento')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          return _mapCliente(data['data']);
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<List<Cliente>> searchClientes(String query) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/clientes', {'q': query})));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((c) => _mapCliente(c)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<Cliente> saveCliente(Cliente cliente) async {
    final res = await http.post(
      Uri.parse(_buildUrl('/api/clientes')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tipoDocumento': cliente.tipoDocumento,
        'numeroDocumento': cliente.numeroDocumento,
        'nombreCompleto': cliente.nombreCompleto,
        'telefono': cliente.telefono,
        'email': cliente.email,
        'direccion': cliente.direccion,
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['data'] != null) {
        _notifyChange();
        return _mapCliente(data['data']);
      }
    }
    return cliente;
  }

  @override
  Future<Orden?> consultaPublica(String codigoOOT, String documento) async {
    final res = await consultarPublico(codigoOOT);
    if (res['tipo'] == 'orden') {
      return res['orden'] as Orden?;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> consultarPublico(String query) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/consulta-publica', {'q': query})));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          final d = data['data'];
          final tipo = d['tipo'] ?? 'no_encontrado';
          if (tipo == 'orden') {
            return {'tipo': 'orden', 'orden': _mapOrden(d['orden'])};
          } else if (tipo == 'cliente') {
            final c = _mapCliente(d['cliente']);
            final eqs = (d['equipos'] as List? ?? []).map((e) => _mapEquipo(e)).toList();
            final ords = (d['ordenes'] as List? ?? []).map((o) => _mapOrden(o)).toList();
            return {'tipo': 'cliente', 'cliente': c, 'equipos': eqs, 'ordenes': ords};
          } else if (tipo == 'equipo') {
            final eq = _mapEquipo(d['equipo']);
            final c = d['cliente'] != null ? _mapCliente(d['cliente']) : null;
            final hist = (d['historial'] as List? ?? []).map((o) => _mapOrden(o)).toList();
            return {'tipo': 'equipo', 'equipo': eq, 'cliente': c, 'historial': hist};
          }
        }
      }
    } catch (_) {}
    return {'tipo': 'no_encontrado'};
  }

  @override
  Future<List<Equipo>> getEquiposByClienteId(int clienteId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/clientes/$clienteId/equipos')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((e) => _mapEquipo(e)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<List<Equipo>> searchEquipos({int? clienteId, String? tipo, String? query}) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/equipos', {
        'clienteId': clienteId,
        'tipo': tipo,
        'busqueda': query,
      })));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((e) => _mapEquipo(e)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<List<Orden>> getOrdenesByClienteId(int clienteId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/clientes/$clienteId/ordenes')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((o) => _mapOrden(o)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  // ===================== REGISTRO DE ÓRDENES =====================

  @override
  Future<String> registrarOrdenCompleta({
    required Cliente cliente,
    required Equipo equipo,
    required Orden orden,
    String? fotoIngresoBase64,
  }) async {
    final res = await http.post(
      Uri.parse(_buildUrl('/api/ordenes')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cliente': {
          'tipoDocumento': cliente.tipoDocumento,
          'numeroDocumento': cliente.numeroDocumento,
          'nombreCompleto': cliente.nombreCompleto,
          'telefono': cliente.telefono,
          'email': cliente.email,
          'direccion': cliente.direccion,
        },
        'equipo': {
          'tipoEquipo': equipo.tipoEquipo,
          'marca': equipo.marca,
          'modelo': equipo.modelo,
          'numeroSerie': equipo.numeroSerie,
          'sistemaOperativo': equipo.sistemaOperativo,
          'procesador': equipo.procesador,
          'memoriaRam': equipo.memoriaRam,
          'almacenamiento': equipo.almacenamiento,
          'tarjetaGrafica': equipo.tarjetaGrafica,
        },
        'orden': {
          'codigoOrden': orden.codigoOrden,
          'tecnicoId': orden.tecnicoId,
          'solicitanteId': orden.solicitanteId,
          'tipoServicio': orden.tipoServicio,
          'categoriaFalla': orden.categoriaFalla,
          'prioridad': orden.prioridad,
          'titulo': orden.titulo,
          'descripcion': orden.descripcion,
          'estado': orden.estado,
          'fechaIngreso': orden.fechaIngreso.toIso8601String(),
          'fechaLimiteSla': orden.fechaLimiteSla?.toIso8601String(),
        },
        'fotoIngresoBase64': fotoIngresoBase64,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['codigoOrden'] != null) {
        _notifyChange();
        return data['codigoOrden'];
      }
    }
    _notifyChange();
    return orden.codigoOrden;
  }

  // ===================== FORMATOS SENA =====================

  @override
  Future<FormatoOt?> getFormatoOt(int ordenId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes/$ordenId/ot')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          final o = data['data'];
          return FormatoOt(
            id: o['id'],
            ordenId: o['ordenId'],
            diagnosticoPreliminar: o['diagnosticoPreliminar'],
            herramientasChips: (o['herramientasChips'] as List? ?? []).map((e) => e.toString()).toList(),
            tiempoEstimadoEntrega: o['tiempoEstimadoEntrega'] != null ? DateTime.tryParse(o['tiempoEstimadoEntrega']) : null,
            accesorioCargador: o['accesorioCargador'] == true,
            accesorioCablePoder: o['accesorioCablePoder'] == true,
            accesorioMouse: o['accesorioMouse'] == true,
            accesorioMaletin: o['accesorioMaletin'] == true,
            encendidoInicial: o['encendidoInicial'] == true,
            estadoCarcasa: o['estadoCarcasa'],
            pinContrasena: o['pinContrasena'],
          );
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> saveFormatoOt(FormatoOt ot) async {
    await http.post(
      Uri.parse(_buildUrl('/api/ordenes/${ot.ordenId}/ot')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'diagnosticoPreliminar': ot.diagnosticoPreliminar,
        'herramientasChips': ot.herramientasChips,
        'tiempoEstimadoEntrega': ot.tiempoEstimadoEntrega?.toIso8601String(),
        'accesorioCargador': ot.accesorioCargador,
        'accesorioCablePoder': ot.accesorioCablePoder,
        'accesorioMouse': ot.accesorioMouse,
        'accesorioMaletin': ot.accesorioMaletin,
        'encendidoInicial': ot.encendidoInicial,
        'estadoCarcasa': ot.estadoCarcasa,
        'pinContrasena': ot.pinContrasena,
      }),
    );
    _notifyChange();
  }

  @override
  Future<FormatoActividades?> getFormatoActividades(int ordenId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes/$ordenId/actividades')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          final a = data['data'];
          return FormatoActividades(
            id: a['id'],
            ordenId: a['ordenId'],
            procedimientosRealizados: a['procedimientosRealizados'],
            pastaTermica: a['pastaTermica'] == true,
            alcoholIsopropilico: a['alcoholIsopropilico'] == true,
            sopleteadoContactos: a['sopleteadoContactos'] == true,
            brochaAntiestatica: a['brochaAntiestatica'] == true,
            panoMicrofibra: a['panoMicrofibra'] == true,
            depuracionTemporales: a['depuracionTemporales'] == true,
            optimizacionInicio: a['optimizacionInicio'] == true,
            escaneoMalware: a['escaneoMalware'] == true,
            actualizacionDrivers: a['actualizacionDrivers'] == true,
            comprobacionDisco: a['comprobacionDisco'] == true,
            qaEstresTermico: a['qaEstresTermico'] == true,
            qaPuertos: a['qaPuertos'] == true,
            qaConectividad: a['qaConectividad'] == true,
            qaBateria: a['qaBateria'] == true,
            qaTecladoTouchpad: a['qaTecladoTouchpad'] == true,
            costoManoObra: (a['costoManoObra'] as num?)?.toDouble() ?? 0.0,
          );
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> saveFormatoActividades(FormatoActividades act) async {
    await http.post(
      Uri.parse(_buildUrl('/api/ordenes/${act.ordenId}/actividades')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'procedimientosRealizados': act.procedimientosRealizados,
        'pastaTermica': act.pastaTermica,
        'alcoholIsopropilico': act.alcoholIsopropilico,
        'sopleteadoContactos': act.sopleteadoContactos,
        'brochaAntiestatica': act.brochaAntiestatica,
        'panoMicrofibra': act.panoMicrofibra,
        'depuracionTemporales': act.depuracionTemporales,
        'optimizacionInicio': act.optimizacionInicio,
        'escaneoMalware': act.escaneoMalware,
        'actualizacionDrivers': act.actualizacionDrivers,
        'comprobacionDisco': act.comprobacionDisco,
        'qaEstresTermico': act.qaEstresTermico,
        'qaPuertos': act.qaPuertos,
        'qaConectividad': act.qaConectividad,
        'qaBateria': act.qaBateria,
        'qaTecladoTouchpad': act.qaTecladoTouchpad,
        'costoManoObra': act.costoManoObra,
      }),
    );
    _notifyChange();
  }

  @override
  Future<List<Repuesto>> getRepuestos(int ordenId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes/$ordenId/repuestos')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((r) => Repuesto(
            id: r['id'],
            ordenId: r['ordenId'],
            referencia: r['referencia'],
            cantidad: r['cantidad'],
            precioUnitario: (r['precioUnitario'] as num).toDouble(),
            subtotal: (r['subtotal'] as num).toDouble(),
          )).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> addRepuesto(Repuesto repuesto) async {
    await http.post(
      Uri.parse(_buildUrl('/api/ordenes/${repuesto.ordenId}/repuestos')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'referencia': repuesto.referencia,
        'cantidad': repuesto.cantidad,
        'precioUnitario': repuesto.precioUnitario,
      }),
    );
    _notifyChange();
  }

  @override
  Future<void> deleteRepuesto(int repuestoId) async {
    await http.delete(Uri.parse(_buildUrl('/api/repuestos/$repuestoId')));
    _notifyChange();
  }

  @override
  Future<List<FotoEvidencia>> getFotosEvidencia(int ordenId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes/$ordenId/fotos')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((f) => FotoEvidencia(
            id: f['id'],
            ordenId: f['ordenId'],
            etapa: f['etapa'],
            rutaOBytesBase64: f['rutaOBytesBase64'],
            notaTecnica: f['notaTecnica'],
            fechaCaptura: DateTime.tryParse(f['fechaCaptura'] ?? '') ?? DateTime.now(),
          )).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> addFotoEvidencia(FotoEvidencia foto) async {
    await http.post(
      Uri.parse(_buildUrl('/api/ordenes/${foto.ordenId}/fotos')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'etapa': foto.etapa,
        'rutaOBytesBase64': foto.rutaOBytesBase64,
        'notaTecnica': foto.notaTecnica,
        'fechaCaptura': foto.fechaCaptura.toIso8601String(),
      }),
    );
    _notifyChange();
  }

  @override
  Future<void> deleteFotoEvidencia(int fotoId) async {
    await http.delete(Uri.parse(_buildUrl('/api/fotos/$fotoId')));
    _notifyChange();
  }

  @override
  Future<FormatoActaEntrega?> getActaEntrega(int ordenId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/ordenes/$ordenId/acta')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          final a = data['data'];
          return FormatoActaEntrega(
            id: a['id'],
            ordenId: a['ordenId'],
            estadoOperatividad: a['estadoOperatividad'],
            observaciones: a['observaciones'],
            recomendacionesCuidado: a['recomendacionesCuidado'],
            garantiaDias: a['garantiaDias']?.toString() ?? '30_DIAS',
            personaRecibeNombre: a['personaRecibeNombre'],
            personaRecibeDocumento: a['personaRecibeDocumento'],
            checkConformidad: a['checkConformidad'] == true,
            fechaEntrega: DateTime.tryParse(a['fechaEntrega'] ?? '') ?? DateTime.now(),
          );
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> cerrarOrdenConActa(FormatoActaEntrega acta) async {
    await http.post(
      Uri.parse(_buildUrl('/api/ordenes/${acta.ordenId}/acta')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'estadoOperatividad': acta.estadoOperatividad,
        'observaciones': acta.observaciones,
        'recomendacionesCuidado': acta.recomendacionesCuidado,
        'garantiaDias': acta.garantiaDias,
        'personaRecibeNombre': acta.personaRecibeNombre,
        'personaRecibeDocumento': acta.personaRecibeDocumento,
        'checkConformidad': acta.checkConformidad,
      }),
    );
    _notifyChange();
  }

  @override
  Future<void> updateEstadoOrden(int ordenId, String nuevoEstado) async {
    await http.put(
      Uri.parse(_buildUrl('/api/ordenes/$ordenId/estado')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nuevoEstado': nuevoEstado}),
    );
    _notifyChange();
  }

  // ===================== INVENTARIO DE EQUIPOS =====================

  @override
  Future<List<Equipo>> getInventarioEquipos({String? tipo, String? estado, String? busqueda}) async {
    return searchEquipos(tipo: tipo, query: busqueda);
  }

  @override
  Future<List<Orden>> getHistorialEquipo(int equipoId) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/equipos/$equipoId/historial')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((o) => _mapOrden(o)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> updateEstadoEquipo(int equipoId, String nuevoEstado) async {
    await http.put(
      Uri.parse(_buildUrl('/api/equipos/$equipoId/estado')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nuevoEstado': nuevoEstado}),
    );
    _notifyChange();
  }

  // ===================== CONFIGURACIÓN DE EMPRESA =====================

  @override
  Future<EmpresaConfig> getEmpresaConfig() async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/config'))).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          return _mapEmpresa(data['data']);
        }
      }
    } catch (_) {}
    return const EmpresaConfig.defaultConfig();
  }

  @override
  Future<void> saveEmpresaConfig(EmpresaConfig config) async {
    await http.post(
      Uri.parse(_buildUrl('/api/config')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombreEmpresa': config.nombreEmpresa,
        'slogan': config.slogan,
        'nit': config.nit,
        'telefono': config.telefono,
        'email': config.email,
        'direccion': config.direccion,
        'ciudad': config.ciudad,
        'logoBase64': config.logoBase64,
        'smtpHost': config.smtpHost,
        'smtpPort': config.smtpPort,
        'smtpUser': config.smtpUser,
        'smtpPass': config.smtpPass,
        'smtpApiUrl': config.smtpApiUrl,
        'portalHostUrl': config.portalHostUrl,
        'colorPrimario': config.colorPrimario,
        'colorSecundario': config.colorSecundario,
      }),
    );
    _notifyChange();
  }

  @override
  Stream<EmpresaConfig> watchEmpresaConfig() async* {
    yield await getEmpresaConfig();
    yield* _refreshStream.stream.asyncMap((_) => getEmpresaConfig());
  }

  // ===================== AUDITORÍA DE NOTIFICACIONES =====================

  @override
  Future<List<NotificacionAuditoria>> getAuditoriaNotificaciones() async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/auditoria')));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((n) => NotificacionAuditoria(
            id: n['id'],
            destinatario: n['destinatario'],
            asunto: n['asunto'],
            evento: n['evento'],
            estado: n['estado'],
            fechaEnvio: DateTime.tryParse(n['fechaEnvio'] ?? '') ?? DateTime.now(),
          )).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> registrarNotificacion(NotificacionAuditoria notif) async {
    await http.post(
      Uri.parse(_buildUrl('/api/auditoria')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'destinatario': notif.destinatario,
        'asunto': notif.asunto,
        'evento': notif.evento,
        'estado': notif.estado,
        'fechaEnvio': notif.fechaEnvio.toIso8601String(),
      }),
    );
    _notifyChange();
  }

  // ===================== TIPOS DE FALLA =====================

  @override
  Future<List<TipoFalla>> getTiposFalla({String? tipoServicio}) async {
    try {
      final res = await http.get(Uri.parse(_buildUrl('/api/tipos-falla', {'tipoServicio': tipoServicio})));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List).map((t) => TipoFalla(
            id: t['id'],
            tipoServicio: t['tipoServicio'],
            nombre: t['nombre'],
            descripcion: t['descripcion'],
            activo: t['activo'] == true,
          )).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<TipoFalla> addTipoFalla(TipoFalla tipoFalla) async {
    final res = await http.post(
      Uri.parse(_buildUrl('/api/tipos-falla')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tipoServicio': tipoFalla.tipoServicio,
        'nombre': tipoFalla.nombre,
        'descripcion': tipoFalla.descripcion,
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true && data['data'] != null) {
        final d = data['data'];
        _notifyChange();
        return TipoFalla(id: d['id'], tipoServicio: d['tipoServicio'], nombre: d['nombre'], descripcion: d['descripcion'], activo: true);
      }
    }
    return tipoFalla;
  }

  @override
  Future<void> deleteTipoFalla(int id) async {
    await http.delete(Uri.parse(_buildUrl('/api/tipos-falla/$id')));
    _notifyChange();
  }

  @override
  Future<int> countTiposFalla() async {
    final list = await getTiposFalla();
    return list.length;
  }

  // ===================== HELPERS MAPPER =====================

  Usuario _mapUsuario(dynamic u) {
    return Usuario(
      id: u['id'],
      nombre: u['nombre'] ?? '',
      email: u['email'] ?? '',
      password: u['password'] ?? '',
      documento: u['documento'] ?? '',
      telefono: u['telefono'] ?? '',
      rol: u['rol'] ?? 'admin',
      activo: u['activo'] == true,
      createdAt: u['createdAt'] != null ? DateTime.tryParse(u['createdAt']) : null,
    );
  }

  Cliente _mapCliente(dynamic c) {
    return Cliente(
      id: c['id'],
      tipoDocumento: c['tipoDocumento'] ?? 'CC',
      numeroDocumento: c['numeroDocumento'] ?? '',
      nombreCompleto: c['nombreCompleto'] ?? '',
      telefono: c['telefono'] ?? '',
      email: c['email'],
      direccion: c['direccion'] ?? '',
      createdAt: c['createdAt'] != null ? DateTime.tryParse(c['createdAt']) : null,
    );
  }

  Equipo _mapEquipo(dynamic e) {
    return Equipo(
      id: e['id'],
      clienteId: e['clienteId'] ?? 0,
      tipoEquipo: e['tipoEquipo'] ?? '',
      marca: e['marca'] ?? '',
      modelo: e['modelo'] ?? '',
      numeroSerie: e['numeroSerie'] ?? '',
      sistemaOperativo: e['sistemaOperativo'],
      procesador: e['procesador'],
      memoriaRam: e['memoriaRam'],
      almacenamiento: e['almacenamiento'],
      tarjetaGrafica: e['tarjetaGrafica'],
      estadoEquipo: e['estadoEquipo'] ?? 'OPERATIVO',
      createdAt: e['createdAt'] != null ? DateTime.tryParse(e['createdAt']) : null,
    );
  }

  Orden _mapOrden(dynamic o) {
    return Orden(
      id: o['id'],
      codigoOrden: o['codigoOrden'] ?? '',
      clienteId: o['clienteId'] ?? 0,
      equipoId: o['equipoId'] ?? 0,
      tecnicoId: o['tecnicoId'],
      solicitanteId: o['solicitanteId'],
      tipoServicio: o['tipoServicio'] ?? 'PREVENTIVO',
      categoriaFalla: o['categoriaFalla'] ?? 'HARDWARE',
      prioridad: o['prioridad'] ?? 'MEDIA',
      titulo: o['titulo'] ?? '',
      descripcion: o['descripcion'] ?? '',
      estado: o['estado'] ?? 'RECIBIDO',
      fechaIngreso: DateTime.tryParse(o['fechaIngreso'] ?? '') ?? DateTime.now(),
      fechaLimiteSla: o['fechaLimiteSla'] != null ? DateTime.tryParse(o['fechaLimiteSla']) : null,
      fechaCierre: o['fechaCierre'] != null ? DateTime.tryParse(o['fechaCierre']) : null,
      cliente: o['cliente'] != null ? _mapCliente(o['cliente']) : null,
      equipo: o['equipo'] != null ? _mapEquipo(o['equipo']) : null,
      tecnico: o['tecnico'] != null ? _mapUsuario(o['tecnico']) : null,
    );
  }

  EmpresaConfig _mapEmpresa(dynamic e) {
    return EmpresaConfig(
      id: e['id'],
      nombreEmpresa: e['nombreEmpresa'] ?? 'Santi Inc',
      slogan: e['slogan'],
      nit: e['nit'],
      telefono: e['telefono'],
      email: e['email'],
      direccion: e['direccion'],
      ciudad: e['ciudad'],
      logoBase64: e['logoBase64'],
      smtpHost: e['smtpHost'],
      smtpPort: e['smtpPort'],
      smtpUser: e['smtpUser'],
      smtpPass: e['smtpPass'],
      smtpApiUrl: e['smtpApiUrl'],
      portalHostUrl: e['portalHostUrl'],
      colorPrimario: e['colorPrimario'] ?? '#0F172A',
      colorSecundario: e['colorSecundario'] ?? '#0284C7',
      isSetupCompleted: e['isSetupCompleted'] == true,
    );
  }
}
