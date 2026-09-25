import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/formato_acta_entrega.dart';
import '../../domain/entities/formato_actividades.dart';
import '../../domain/entities/formato_ot.dart';
import '../../domain/entities/foto_evidencia.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/repuesto.dart';
import '../providers/ordenes_providers.dart';
import '../widgets/status_badge.dart';
import 'documento_oficial_screen.dart';

class DetalleTallerScreen extends ConsumerStatefulWidget {
  final int ordenId;

  const DetalleTallerScreen({super.key, required this.ordenId});

  @override
  ConsumerState<DetalleTallerScreen> createState() => _DetalleTallerScreenState();
}

class _DetalleTallerScreenState extends ConsumerState<DetalleTallerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;

  Orden? _orden;
  List<Repuesto> _repuestos = [];
  List<FotoEvidencia> _fotos = [];

  // Controllers Pestaña 1 (OT & Evidencias)
  final _diagController = TextEditingController();
  final _carcasaController = TextEditingController();
  final _pinController = TextEditingController();
  final _toolInputController = TextEditingController();
  List<String> _herramientas = [];
  DateTime? _fechaEstimada;
  bool _accCargador = false;
  bool _accCablePoder = false;
  bool _accMouse = false;
  bool _accMaletin = false;
  bool _encendido = true;

  // Controllers Pestaña 2 (Bitácora)
  final _laboresController = TextEditingController();
  final _manoObraController = TextEditingController(text: '0');
  bool _insumoPasta = false;
  bool _insumoAlcohol = false;
  bool _insumoSopleteado = false;
  bool _insumoBrocha = false;
  bool _insumoPano = false;
  bool _logicaTemporales = false;
  bool _logicaInicio = false;
  bool _logicaMalware = false;
  bool _logicaDrivers = false;

  // Protocolo y Certificación de Pruebas de Diagnóstico Pre-Entrega (CrystalDisk, HWMonitor, MemTest, etc.)
  bool _diagCrystalDisk = false;
  final _resCrystalDiskCtrl = TextEditingController(text: 'Salud 100% Bueno. 0 Sectores Reasignados SMART');
  bool _diagHwMonitor = false;
  final _resHwMonitorCtrl = TextEditingController(text: 'Reposo: 38°C / Carga máx: 65°C. Disipación térmica nominal');
  bool _diagMemTest = false;
  final _resMemTestCtrl = TextEditingController(text: '0 Errores detectados. Memoria RAM íntegra');
  bool _diagFurmark = false;
  final _resFurmarkCtrl = TextEditingController(text: 'Test 3D estable sin artefactos ni cuelgues');
  bool _diagBattery = false;
  final _resBatteryCtrl = TextEditingController(text: 'Batería en estado normal, retiene carga y desconexión');
  bool _diagPerifericos = false;
  final _resPerifericosCtrl = TextEditingController(text: '100% teclas, touchpad, audio y puertos USB operativos');

  // Controllers Pestaña 3 (Acta)
  String _estadoOperatividad = 'OPERATIVO';
  final _obsEntregaController = TextEditingController();
  final _recomController = TextEditingController(
    text: 'Mantener en superficie plana y ventilada. Usar regulador de voltaje. Realizar mantenimiento preventivo cada 6 meses.',
  );
  String _garantiaDias = '30_DIAS';
  final _nombreRecibeController = TextEditingController();
  final _docRecibeController = TextEditingController();
  bool _checkConformidad = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _diagController.dispose();
    _carcasaController.dispose();
    _pinController.dispose();
    _toolInputController.dispose();
    _laboresController.dispose();
    _manoObraController.dispose();
    _obsEntregaController.dispose();
    _recomController.dispose();
    _nombreRecibeController.dispose();
    _docRecibeController.dispose();
    _resCrystalDiskCtrl.dispose();
    _resHwMonitorCtrl.dispose();
    _resMemTestCtrl.dispose();
    _resFurmarkCtrl.dispose();
    _resBatteryCtrl.dispose();
    _resPerifericosCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() => _loading = true);
    final useCase = ref.read(manageTallerUseCaseProvider);

    final orden = await useCase.getOrden(widget.ordenId);
    final ot = await useCase.getFormatoOt(widget.ordenId);
    final act = await useCase.getFormatoActividades(widget.ordenId);
    final rep = await useCase.getRepuestos(widget.ordenId);
    final fotos = await useCase.getFotos(widget.ordenId);
    final acta = await useCase.getActa(widget.ordenId);

    if (orden != null) {
      _orden = orden;
      _repuestos = rep;
      _fotos = fotos;

      // Cargar Pestaña 1
      if (ot != null) {
        _diagController.text = ot.diagnosticoPreliminar ?? '';
        _herramientas = List.from(ot.herramientasChips);
        _fechaEstimada = ot.tiempoEstimadoEntrega;
        _accCargador = ot.accesorioCargador;
        _accCablePoder = ot.accesorioCablePoder;
        _accMouse = ot.accesorioMouse;
        _accMaletin = ot.accesorioMaletin;
        _encendido = ot.encendidoInicial;
        _carcasaController.text = ot.estadoCarcasa ?? '';
        _pinController.text = ot.pinContrasena ?? '';
      }

      // Cargar Pestaña 2
      if (act != null) {
        final rawLabores = act.procedimientosRealizados ?? '';
        if (rawLabores.contains('--- [PRUEBAS DE DIAGNÓSTICO PRE-ENTREGA] ---')) {
          final parts = rawLabores.split('--- [PRUEBAS DE DIAGNÓSTICO PRE-ENTREGA] ---');
          _laboresController.text = parts[0].trim();
          final diagText = parts.length > 1 ? parts[1] : '';

          final regCrystal = RegExp(r'CrystalDiskInfo:\s*(.+)$', multiLine: true).firstMatch(diagText);
          if (regCrystal != null) {
            _resCrystalDiskCtrl.text = regCrystal.group(1)?.trim() ?? '';
            _diagCrystalDisk = true;
          }

          final regHw = RegExp(r'HWMonitor:\s*(.+)$', multiLine: true).firstMatch(diagText);
          if (regHw != null) {
            _resHwMonitorCtrl.text = regHw.group(1)?.trim() ?? '';
            _diagHwMonitor = true;
          }

          final regMem = RegExp(r'MemTest86:\s*(.+)$', multiLine: true).firstMatch(diagText);
          if (regMem != null) {
            _resMemTestCtrl.text = regMem.group(1)?.trim() ?? '';
            _diagMemTest = true;
          }

          final regFur = RegExp(r'FurMark:\s*(.+)$', multiLine: true).firstMatch(diagText);
          if (regFur != null) {
            _resFurmarkCtrl.text = regFur.group(1)?.trim() ?? '';
            _diagFurmark = true;
          }

          final regBat = RegExp(r'BatteryBar:\s*(.+)$', multiLine: true).firstMatch(diagText);
          if (regBat != null) {
            _resBatteryCtrl.text = regBat.group(1)?.trim() ?? '';
            _diagBattery = true;
          }

          final regPer = RegExp(r'Periféricos:\s*(.+)$', multiLine: true).firstMatch(diagText);
          if (regPer != null) {
            _resPerifericosCtrl.text = regPer.group(1)?.trim() ?? '';
            _diagPerifericos = true;
          }
        } else {
          _laboresController.text = rawLabores;
          _diagCrystalDisk = act.comprobacionDisco;
          _diagHwMonitor = act.qaEstresTermico;
          _diagBattery = act.qaBateria;
          _diagPerifericos = act.qaTecladoTouchpad || act.qaPuertos;
        }

        _manoObraController.text = act.costoManoObra.toStringAsFixed(0);
        _insumoPasta = act.pastaTermica;
        _insumoAlcohol = act.alcoholIsopropilico;
        _insumoSopleteado = act.sopleteadoContactos;
        _insumoBrocha = act.brochaAntiestatica;
        _insumoPano = act.panoMicrofibra;
        _logicaTemporales = act.depuracionTemporales;
        _logicaInicio = act.optimizacionInicio;
        _logicaMalware = act.escaneoMalware;
        _logicaDrivers = act.actualizacionDrivers;

        if (act.comprobacionDisco) _diagCrystalDisk = true;
        if (act.qaEstresTermico) _diagHwMonitor = true;
        if (act.qaBateria) _diagBattery = true;
        if (act.qaTecladoTouchpad || act.qaPuertos) _diagPerifericos = true;
      }

      // Cargar Pestaña 3
      if (acta != null) {
        _estadoOperatividad = acta.estadoOperatividad;
        _obsEntregaController.text = acta.observaciones ?? '';
        if (acta.recomendacionesCuidado != null) {
          _recomController.text = acta.recomendacionesCuidado!;
        }
        _garantiaDias = acta.garantiaDias;
        _nombreRecibeController.text = acta.personaRecibeNombre;
        _docRecibeController.text = acta.personaRecibeDocumento;
        _checkConformidad = acta.checkConformidad;
      } else {
        _nombreRecibeController.text = orden.cliente?.nombreCompleto ?? '';
        _docRecibeController.text = orden.cliente?.numeroDocumento ?? '';
      }
    }

    setState(() => _loading = false);
  }

  Future<void> _guardarPestana1() async {
    final useCase = ref.read(manageTallerUseCaseProvider);
    final ot = FormatoOt(
      ordenId: widget.ordenId,
      diagnosticoPreliminar: _diagController.text.trim(),
      herramientasChips: _herramientas,
      tiempoEstimadoEntrega: _fechaEstimada,
      accesorioCargador: _accCargador,
      accesorioCablePoder: _accCablePoder,
      accesorioMouse: _accMouse,
      accesorioMaletin: _accMaletin,
      encendidoInicial: _encendido,
      estadoCarcasa: _carcasaController.text.trim(),
      pinContrasena: _pinController.text.trim(),
    );

    await useCase.saveFormatoOt(ot);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diagnóstico y Formato OT guardados correctamente. Pasando al siguiente paso...'),
          backgroundColor: SantiConstants.successGreen,
          duration: Duration(seconds: 2),
        ),
      );
      _tabController.animateTo(1);
    }
  }

  Future<void> _guardarPestana2() async {
    final useCase = ref.read(manageTallerUseCaseProvider);
    final manoObra = double.tryParse(_manoObraController.text.trim()) ?? 0.0;

    final sb = StringBuffer();
    sb.writeln(_laboresController.text.trim());
    sb.writeln();
    sb.writeln('--- [PRUEBAS DE DIAGNÓSTICO PRE-ENTREGA] ---');
    if (_diagCrystalDisk) sb.writeln('CrystalDiskInfo: ${_resCrystalDiskCtrl.text.trim()}');
    if (_diagHwMonitor) sb.writeln('HWMonitor: ${_resHwMonitorCtrl.text.trim()}');
    if (_diagMemTest) sb.writeln('MemTest86: ${_resMemTestCtrl.text.trim()}');
    if (_diagFurmark) sb.writeln('FurMark: ${_resFurmarkCtrl.text.trim()}');
    if (_diagBattery) sb.writeln('BatteryBar: ${_resBatteryCtrl.text.trim()}');
    if (_diagPerifericos) sb.writeln('Periféricos: ${_resPerifericosCtrl.text.trim()}');

    final act = FormatoActividades(
      ordenId: widget.ordenId,
      procedimientosRealizados: sb.toString().trim(),
      pastaTermica: _insumoPasta,
      alcoholIsopropilico: _insumoAlcohol,
      sopleteadoContactos: _insumoSopleteado,
      brochaAntiestatica: _insumoBrocha,
      panoMicrofibra: _insumoPano,
      depuracionTemporales: _logicaTemporales,
      optimizacionInicio: _logicaInicio,
      escaneoMalware: _logicaMalware,
      actualizacionDrivers: _logicaDrivers,
      comprobacionDisco: _diagCrystalDisk,
      qaEstresTermico: _diagHwMonitor,
      qaPuertos: _diagPerifericos,
      qaConectividad: _diagPerifericos,
      qaBateria: _diagBattery,
      qaTecladoTouchpad: _diagPerifericos,
      costoManoObra: manoObra,
    );

    await useCase.saveFormatoActividades(act);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitácora, Insumos y Pruebas de Diagnóstico guardadas con éxito.'),
          backgroundColor: SantiConstants.successGreen,
          duration: Duration(seconds: 2),
        ),
      );
      _tabController.animateTo(2);
    }
  }

  Future<void> _agregarRepuestoDialog() async {
    final refController = TextEditingController();
    final cantController = TextEditingController(text: '1');
    final precioController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar Repuesto / Insumo Facturable'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: refController,
              decoration: const InputDecoration(labelText: 'Referencia / Descripción', hintText: 'ej. Disco SSD 500GB Kingston'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio Unitario (\$ COP)', prefixText: '\$ '),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final ref = refController.text.trim();
              final cant = int.tryParse(cantController.text.trim()) ?? 1;
              final precio = double.tryParse(precioController.text.trim()) ?? 0.0;

              if (ref.isNotEmpty && precio > 0) {
                final repuesto = Repuesto(
                  ordenId: widget.ordenId,
                  referencia: ref,
                  cantidad: cant,
                  precioUnitario: precio,
                  subtotal: cant * precio,
                );
                final useCase = this.ref.read(manageTallerUseCaseProvider);
                await useCase.addRepuesto(repuesto);
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
                _cargarDatos();
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarRepuesto(int repuestoId) async {
    final useCase = ref.read(manageTallerUseCaseProvider);
    await useCase.deleteRepuesto(repuestoId);
    _cargarDatos();
  }

  Future<void> _subirFotoEvidencia(String etapa, {String? defaultNota}) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Img = base64Encode(bytes);

        final foto = FotoEvidencia(
          ordenId: widget.ordenId,
          etapa: etapa,
          rutaOBytesBase64: base64Img,
          notaTecnica: defaultNota ?? 'Evidencia en etapa $etapa',
          fechaCaptura: DateTime.now(),
        );

        final useCase = ref.read(manageTallerUseCaseProvider);
        await useCase.addFoto(foto);
        _cargarDatos();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(defaultNota != null
                  ? 'Captura de prueba técnica registrada con éxito.'
                  : 'Evidencia fotográfica subida correctamente.'),
              backgroundColor: SantiConstants.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir foto: $e')));
      }
    }
  }

  Future<void> _eliminarFoto(int fotoId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Evidencia Fotográfica'),
        content: const Text('¿Está seguro de eliminar esta fotografía de evidencia técnica? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final useCase = ref.read(manageTallerUseCaseProvider);
      await useCase.deleteFoto(fotoId);
      await _cargarDatos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evidencia fotográfica eliminada.'),
            backgroundColor: SantiConstants.primaryBlue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _cerrarOrdenYGenerarActa() async {
    if (!_checkConformidad) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe marcar la casilla de verificación y conformidad del cliente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final useCase = ref.read(manageTallerUseCaseProvider);
    final acta = FormatoActaEntrega(
      ordenId: widget.ordenId,
      estadoOperatividad: _estadoOperatividad,
      observaciones: _obsEntregaController.text.trim(),
      recomendacionesCuidado: _recomController.text.trim(),
      garantiaDias: _garantiaDias,
      personaRecibeNombre: _nombreRecibeController.text.trim(),
      personaRecibeDocumento: _docRecibeController.text.trim(),
      checkConformidad: _checkConformidad,
      fechaEntrega: DateTime.now(),
    );

    await useCase.cerrarOrdenConActa(acta);
    await _cargarDatos();

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Orden Cerrada y Entregada'),
          content: const Text('Se ha registrado el Acta de Entrega oficial. Toda la información ha sido archivada en modo solo lectura. ¿Desea ver e imprimir el Documento Oficial ahora?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Quedarme Aquí'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DocumentoOficialScreen(ordenId: widget.ordenId)),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Ver Documento Oficial'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _orden == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final orden = _orden!;
    final isCerrada = orden.estado == 'ENTREGADO_CERRADO';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(orden.codigoOrden, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 10),
                StatusBadge(status: orden.estado),
              ],
            ),
            Text(
              '${orden.cliente?.nombreCompleto ?? ''} • ${orden.equipo?.marca ?? ''} ${orden.equipo?.modelo ?? ''}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
            ),
          ],
        ),
        actions: [
          // Selector de cambio rápido de estado (Deshabilitado si está cerrada)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: orden.estado,
              dropdownColor: SantiConstants.primaryNavy,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'RECIBIDO', child: Text('Recibido')),
                DropdownMenuItem(value: 'EN_DIAGNOSTICO', child: Text('En Diagnóstico')),
                DropdownMenuItem(value: 'EN_TALLER', child: Text('En Taller')),
                DropdownMenuItem(value: 'LISTO_ENTREGA', child: Text('Listo Entrega')),
                DropdownMenuItem(value: 'ENTREGADO_CERRADO', child: Text('Entregado / Cerrado')),
              ],
              onChanged: isCerrada
                  ? null
                  : (newVal) async {
                      if (newVal != null) {
                        final useCase = ref.read(manageTallerUseCaseProvider);
                        await useCase.updateEstado(orden.id!, newVal);
                        _cargarDatos();
                      }
                    },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Ver Documento Oficial',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DocumentoOficialScreen(ordenId: widget.ordenId)),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.cyanAccent,
          tabs: const [
            Tab(icon: Icon(Icons.assignment), text: '1. Orden de Trabajo & Evidencias'),
            Tab(icon: Icon(Icons.handyman), text: '2. Bitácora & Insumos'),
            Tab(icon: Icon(Icons.verified_outlined), text: '3. Acta de Entrega'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner de Alerta cuando la orden está CERRADA
          if (isCerrada)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.amber.shade100,
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.amber.shade900, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'ORDEN FINALIZADA Y ENTREGADA: Toda la información técnica, evidencias y liquidación se encuentran archivadas en modo solo lectura para garantizar la validez legal del acta de entrega.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.brown.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTab1OrdenTrabajo(isCerrada),
                _buildTab2Bitacora(isCerrada),
                _buildTab3ActaEntrega(isCerrada),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PESTAÑA 1 (OT & EVIDENCIAS) =====================
  Widget _buildTab1OrdenTrabajo(bool isCerrada) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Diagnóstico Técnico Preliminar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _diagController,
            readOnly: isCerrada,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Consigne las observaciones de encendido, voltajes, ruidos, temperaturas iniciales...',
              filled: isCerrada,
              fillColor: isCerrada ? Colors.grey.shade100 : null,
            ),
          ),
          const SizedBox(height: 20),

          // Herramientas dinámicas con chips
          const Text('Herramientas Empleadas en Mesón de Trabajo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              if (_herramientas.isEmpty)
                Text('Ninguna herramienta registrada.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ..._herramientas.map(
                (h) => Chip(
                  label: Text(h),
                  deleteIcon: isCerrada ? null : const Icon(Icons.close, size: 16),
                  onDeleted: isCerrada
                      ? null
                      : () {
                          setState(() => _herramientas.remove(h));
                        },
                ),
              ),
            ],
          ),
          if (!isCerrada) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _toolInputController,
                    decoration: const InputDecoration(
                      hintText: 'Nueva herramienta (ej. Multímetro, Pulsera ESD, Estación calor)...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    final text = _toolInputController.text.trim();
                    if (text.isNotEmpty && !_herramientas.contains(text)) {
                      setState(() {
                        _herramientas.add(text);
                        _toolInputController.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),

          // Accesorios y Estado inicial
          const Text('Accesorios Recibidos e Inspección Física', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            children: [
              FilterChip(
                label: const Text('Cargador / Adaptador'),
                selected: _accCargador,
                onSelected: isCerrada ? null : (v) => setState(() => _accCargador = v),
              ),
              FilterChip(
                label: const Text('Cable de Poder'),
                selected: _accCablePoder,
                onSelected: isCerrada ? null : (v) => setState(() => _accCablePoder = v),
              ),
              FilterChip(
                label: const Text('Mouse USB / Inalámbrico'),
                selected: _accMouse,
                onSelected: isCerrada ? null : (v) => setState(() => _accMouse = v),
              ),
              FilterChip(
                label: const Text('Maletín / Funda'),
                selected: _accMaletin,
                onSelected: isCerrada ? null : (v) => setState(() => _accMaletin = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('¿El equipo enciende al momento de la recepción?'),
            value: _encendido,
            onChanged: isCerrada ? null : (v) => setState(() => _encendido = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _carcasaController,
                  readOnly: isCerrada,
                  decoration: InputDecoration(
                    labelText: 'Estado Estético de la Carcasa',
                    hintText: 'Rayones leves, bisagras flojas, tornillos faltantes...',
                    filled: isCerrada,
                    fillColor: isCerrada ? Colors.grey.shade100 : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _pinController,
                  readOnly: isCerrada,
                  decoration: InputDecoration(
                    labelText: 'Contraseña / PIN de Inicio de Sesión',
                    hintText: 'Sin contraseña o PIN de 4 dígitos',
                    filled: isCerrada,
                    fillColor: isCerrada ? Colors.grey.shade100 : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // SECCIÓN DE EVIDENCIAS FOTOGRÁFICAS (INTEGRADA EN OT)
          _buildSeccionEvidencias(isCerrada),

          const SizedBox(height: 24),
          if (!isCerrada)
            ElevatedButton.icon(
              onPressed: _guardarPestana1,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Formato de Orden de Trabajo'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continuar a Bitácora & Insumos (Solo Lectura)'),
              style: ElevatedButton.styleFrom(backgroundColor: SantiConstants.primaryNavy),
            ),
        ],
      ),
    );
  }

  // ===================== SECCIÓN EVIDENCIAS (DENTRO DE TAB 1) =====================
  Widget _buildSeccionEvidencias(bool isCerrada) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.photo_camera, color: SantiConstants.primaryBlue),
                  SizedBox(width: 8),
                  Text(
                    'Evidencias Fotográficas de la Orden',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy),
                  ),
                ],
              ),
              if (!isCerrada)
                PopupMenuButton<String>(
                  onSelected: (etapa) => _subirFotoEvidencia(etapa),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'RECEPCION', child: Text('Foto en Recepción')),
                    PopupMenuItem(value: 'PROCESO', child: Text('Foto durante el Proceso')),
                    PopupMenuItem(value: 'ENTREGA', child: Text('Foto de Entrega / Terminado')),
                  ],
                  child: ElevatedButton.icon(
                    onPressed: null, // El popup captura el toque
                    icon: const Icon(Icons.add_a_photo, size: 18),
                    label: const Text('Cargar Evidencia'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SantiConstants.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_fotos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.photo_library_outlined, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No hay evidencias fotográficas registradas para esta orden.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                childAspectRatio: 0.82,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _fotos.length,
              itemBuilder: (context, index) {
                final f = _fotos[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.memory(
                              base64Decode(f.rutaOBytesBase64),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: SantiConstants.primaryBlue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    f.etapa,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(f.fechaCaptura),
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                ),
                                if (f.notaTecnica != null)
                                  Text(
                                    f.notaTecnica!,
                                    style: const TextStyle(fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (!isCerrada && f.id != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => _eliminarFoto(f.id!),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(Icons.delete_outline, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  FotoEvidencia? _buscarEvidenciaHerramienta(String toolKey) {
    try {
      return _fotos.firstWhere(
        (f) => (f.notaTecnica ?? '').toLowerCase().contains(toolKey.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildCardPruebaDiagnostico({
    required String titulo,
    required String nombreHerramienta,
    required String subtitulo,
    required IconData icon,
    required Color color,
    required bool checked,
    required ValueChanged<bool?> onChecked,
    required TextEditingController controller,
    required String hintText,
    required bool isCerrada,
    required String toolKey,
  }) {
    final foto = _buscarEvidenciaHerramienta(toolKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: checked ? color.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: checked ? color.withOpacity(0.5) : Colors.grey.shade300,
          width: checked ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: checked,
                  activeColor: color,
                  onChanged: isCerrada ? null : onChecked,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: checked ? color : const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        subtitulo,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (!isCerrada)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: foto != null ? const Color(0xFF16A34A) : color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _subirFotoEvidencia(
                      'ENTREGA',
                      defaultNota: 'Evidencia: $nombreHerramienta (${controller.text.trim()})',
                    ),
                    icon: Icon(foto != null ? Icons.check_circle : Icons.camera_alt, size: 16),
                    label: Text(foto != null ? 'Captura Lista' : 'Cargar Captura'),
                  ),
              ],
            ),
            if (checked) ...[
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                readOnly: isCerrada,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Resultado de Prueba / Métrica ($nombreHerramienta)',
                  hintText: hintText,
                  filled: isCerrada,
                  fillColor: isCerrada ? Colors.grey.shade100 : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              if (foto != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: Color(0xFF16A34A), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Captura técnica de comprobación adjunta (${foto.notaTecnica ?? ""})',
                          style: const TextStyle(color: Color(0xFF166534), fontSize: 11, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.memory(
                          base64Decode(foto.rutaOBytesBase64),
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadgePrueba(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PESTAÑA 2 (BITÁCORA & INSUMOS) =====================
  Widget _buildTab2Bitacora(bool isCerrada) {
    double totalRepuestos = 0.0;
    for (final r in _repuestos) {
      totalRepuestos += r.subtotal;
    }
    final manoObra = double.tryParse(_manoObraController.text.trim()) ?? 0.0;
    final totalGeneral = totalRepuestos + manoObra;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Procedimientos y Labores Realizadas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _laboresController,
            readOnly: isCerrada,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describa el paso a paso del mantenimiento o reparación ejecutado...',
              filled: isCerrada,
              fillColor: isCerrada ? Colors.grey.shade100 : null,
            ),
          ),
          const SizedBox(height: 20),

          // Insumos físicos y químicos
          Material(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.science, color: SantiConstants.primaryBlue),
                      SizedBox(width: 8),
                      Text(
                        'Insumos Físicos y Químicos Aplicados (Sello Santi INC)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: SantiConstants.primaryNavy),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Pasta Térmica de Alto Rendimiento (Compuesto Plata/Carbono)'),
                    value: _insumoPasta,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _insumoPasta = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Limpieza con Alcohol Isopropílico de Alta Pureza (99.8%)'),
                    value: _insumoAlcohol,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _insumoAlcohol = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Sopleteado / Limpiador Dieléctrico de Contactos Electrónicos'),
                    value: _insumoSopleteado,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _insumoSopleteado = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Desempolvado con Brocha Antiestática ESD'),
                    value: _insumoBrocha,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _insumoBrocha = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Limpieza de Chasis y Pantalla con Paño de Microfibra'),
                    value: _insumoPano,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _insumoPano = v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Mantenimiento lógico
          Material(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mantenimiento Lógico y Optimización', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Depuración de Archivos Temporales y Caché del Sistema'),
                    value: _logicaTemporales,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _logicaTemporales = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Optimización de Aplicaciones de Inicio y Servicios'),
                    value: _logicaInicio,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _logicaInicio = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Escaneo y Eliminación de Malware / Spyware'),
                    value: _logicaMalware,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _logicaMalware = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Actualización de Controladores Críticos'),
                    value: _logicaDrivers,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _logicaDrivers = v!),
                  ),
                  CheckboxListTile(
                    title: const Text('Comprobación de Salud de Disco (SMART / CrystalDiskInfo)'),
                    value: _diagCrystalDisk,
                    dense: true,
                    onChanged: isCerrada ? null : (v) => setState(() => _diagCrystalDisk = v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tabla Dinámica de Repuestos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Repuestos e Insumos Facturables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (!isCerrada)
                ElevatedButton.icon(
                  onPressed: _agregarRepuestoDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Repuesto'),
                  style: ElevatedButton.styleFrom(backgroundColor: SantiConstants.accentCyan),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _repuestos.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No hay repuestos adicionales facturados.')),
                  )
                : DataTable(
                    columns: [
                      const DataColumn(label: Text('Referencia')),
                      const DataColumn(label: Text('Cant.')),
                      const DataColumn(label: Text('Valor Unit.')),
                      const DataColumn(label: Text('Subtotal')),
                      if (!isCerrada) const DataColumn(label: Text('Acción')),
                    ],
                    rows: _repuestos.map((r) {
                      return DataRow(
                        cells: [
                          DataCell(Text(r.referencia)),
                          DataCell(Text('${r.cantidad}')),
                          DataCell(Text(CurrencyFormatter.format(r.precioUnitario))),
                          DataCell(Text(CurrencyFormatter.format(r.subtotal))),
                          if (!isCerrada)
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _eliminarRepuesto(r.id!),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),

          // Liquidación de Costos
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manoObraController,
                  readOnly: isCerrada,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Costo de Mano de Obra Especializada',
                    prefixText: '\$ ',
                    filled: isCerrada,
                    fillColor: isCerrada ? Colors.grey.shade100 : null,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: SantiConstants.primaryNavy,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('TOTAL GENERAL A LIQUIDAR', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(totalGeneral),
                      style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 24),

          // Protocolo Oficial de Pruebas de Diagnóstico y Certificación Pre-Entrega (CrystalDisk, HWMonitor, MemTest, etc.)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.verified, color: Color(0xFF2563EB), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Protocolo de Pruebas de Diagnóstico y Salud Pre-Entrega',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Text(
                        'Comprobación por Software',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Compruebe el correcto funcionamiento de los componentes con herramientas técnicas antes de entregar el equipo al cliente. Active cada prueba y adjunte su captura como evidencia probatoria.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),

                // 1. CrystalDiskInfo (Salud del Disco Duro / SSD SMART)
                _buildCardPruebaDiagnostico(
                  titulo: 'CrystalDiskInfo (Salud y Estado SMART de Disco SSD/HDD)',
                  nombreHerramienta: 'CrystalDiskInfo',
                  subtitulo: 'Prueba de sectores defectuosos, % de vida restante, temperatura y horas de uso.',
                  icon: Icons.storage,
                  color: const Color(0xFF2563EB),
                  checked: _diagCrystalDisk,
                  onChecked: (v) => setState(() => _diagCrystalDisk = v ?? false),
                  controller: _resCrystalDiskCtrl,
                  hintText: 'ej. 100% Salud, SSD NVMe 512GB, 0 sectores reasignados, Temp 35°C',
                  isCerrada: isCerrada,
                  toolKey: 'crystaldisk',
                ),

                // 2. HWMonitor / Estrés Térmico (Temperaturas y Disipación CPU/GPU)
                _buildCardPruebaDiagnostico(
                  titulo: 'HWMonitor / Core Temp (Monitoreo Térmico y Carga de CPU)',
                  nombreHerramienta: 'HWMonitor',
                  subtitulo: 'Prueba de temperaturas en reposo y bajo estrés continuo para verificar disipación.',
                  icon: Icons.thermostat,
                  color: const Color(0xFFD97706),
                  checked: _diagHwMonitor,
                  onChecked: (v) => setState(() => _diagHwMonitor = v ?? false),
                  controller: _resHwMonitorCtrl,
                  hintText: 'ej. Reposo 36°C / Máx estrés 68°C. Ventiladores y disipación al 100%',
                  isCerrada: isCerrada,
                  toolKey: 'hwmonitor',
                ),

                // 3. MemTest86 / Diagnóstico de Memoria RAM
                _buildCardPruebaDiagnostico(
                  titulo: 'MemTest86 / Test de Memoria (Integridad de Memoria RAM)',
                  nombreHerramienta: 'MemTest86',
                  subtitulo: 'Pases de prueba para asegurar 0 fallos de dirección y estabilidad en RAM.',
                  icon: Icons.memory,
                  color: const Color(0xFF7C3AED),
                  checked: _diagMemTest,
                  onChecked: (v) => setState(() => _diagMemTest = v ?? false),
                  controller: _resMemTestCtrl,
                  hintText: 'ej. Pase de prueba completado: 0 errores detectados en bancos de RAM',
                  isCerrada: isCerrada,
                  toolKey: 'memtest',
                ),

                // 4. FurMark / Test 3D (GPU y Video)
                _buildCardPruebaDiagnostico(
                  titulo: 'FurMark / Render 3D (Estabilidad Gráfica y Pantalla)',
                  nombreHerramienta: 'FurMark',
                  subtitulo: 'Prueba de estabilidad bajo renderizado 3D para descartar artefactos o congelamientos.',
                  icon: Icons.speed,
                  color: const Color(0xFFDC2626),
                  checked: _diagFurmark,
                  onChecked: (v) => setState(() => _diagFurmark = v ?? false),
                  controller: _resFurmarkCtrl,
                  hintText: 'ej. Renderizado 3D fluido sin caídas de fps ni artefactos visuales',
                  isCerrada: isCerrada,
                  toolKey: 'furmark',
                ),

                // 5. BatteryBar / Diagnóstico de Carga y Batería
                _buildCardPruebaDiagnostico(
                  titulo: 'BatteryBar / Sistema Eléctrico (Batería, Ciclos y Cargador)',
                  nombreHerramienta: 'BatteryBar',
                  subtitulo: 'Verificación de capacidad de diseño, nivel de desgaste y retención de carga.',
                  icon: Icons.battery_charging_full,
                  color: const Color(0xFF059669),
                  checked: _diagBattery,
                  onChecked: (v) => setState(() => _diagBattery = v ?? false),
                  controller: _resBatteryCtrl,
                  hintText: 'ej. 92% capacidad retenida, carga nominal correcta y desconexión estable',
                  isCerrada: isCerrada,
                  toolKey: 'bateria',
                ),

                // 6. Test Integral de Periféricos y Puertos
                _buildCardPruebaDiagnostico(
                  titulo: 'Prueba de Teclado, Touchpad, Puertos USB, Sonido y WiFi',
                  nombreHerramienta: 'Periféricos',
                  subtitulo: 'Comprobación física de todas las teclas, puertos USB/HDMI, audio y navegación.',
                  icon: Icons.keyboard,
                  color: const Color(0xFF0284C7),
                  checked: _diagPerifericos,
                  onChecked: (v) => setState(() => _diagPerifericos = v ?? false),
                  controller: _resPerifericosCtrl,
                  hintText: 'ej. 100% teclas operativas, puertos USB 3.0 OK, WiFi 5GHz y sonido claros',
                  isCerrada: isCerrada,
                  toolKey: 'perifericos',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!isCerrada)
            ElevatedButton.icon(
              onPressed: _guardarPestana2,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Bitácora, Pruebas de Diagnóstico y Liquidación'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(2),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continuar al Acta de Entrega (Solo Lectura)'),
              style: ElevatedButton.styleFrom(backgroundColor: SantiConstants.primaryNavy),
            ),
        ],
      ),
    );
  }

  // ===================== PESTAÑA 3 (ACTA DE ENTREGA) =====================
  Widget _buildTab3ActaEntrega(bool isCerrada) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CERTIFICACIÓN DE PRUEBAS TÉCNICAS PRE-ENTREGA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user, color: Color(0xFF16A34A), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Certificación de Pruebas de Diagnóstico y Funcionamiento Pre-Entrega',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF166534)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'El equipo ha sido probado exhaustivamente con software técnico para garantizar su óptimo funcionamiento antes de ser entregado al cliente:',
                  style: TextStyle(fontSize: 12, color: Color(0xFF15803D)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_diagCrystalDisk)
                      _buildBadgePrueba('CrystalDiskInfo: ${_resCrystalDiskCtrl.text}', const Color(0xFF2563EB)),
                    if (_diagHwMonitor)
                      _buildBadgePrueba('HWMonitor: ${_resHwMonitorCtrl.text}', const Color(0xFFD97706)),
                    if (_diagMemTest)
                      _buildBadgePrueba('MemTest86: ${_resMemTestCtrl.text}', const Color(0xFF7C3AED)),
                    if (_diagFurmark)
                      _buildBadgePrueba('FurMark: ${_resFurmarkCtrl.text}', const Color(0xFFDC2626)),
                    if (_diagBattery)
                      _buildBadgePrueba('Batería: ${_resBatteryCtrl.text}', const Color(0xFF059669)),
                    if (_diagPerifericos)
                      _buildBadgePrueba('Periféricos: ${_resPerifericosCtrl.text}', const Color(0xFF0284C7)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Dictamen Final de Operatividad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Operativo y Conforme a Satisfacción'),
                  value: 'OPERATIVO',
                  groupValue: _estadoOperatividad,
                  onChanged: isCerrada ? null : (v) => setState(() => _estadoOperatividad = v!),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Sin Solución Técnica / Rechazado'),
                  value: 'SIN_SOLUCION',
                  groupValue: _estadoOperatividad,
                  onChanged: isCerrada ? null : (v) => setState(() => _estadoOperatividad = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _obsEntregaController,
            readOnly: isCerrada,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Observaciones de Entrega',
              hintText: 'Comportamiento en entrega, pruebas presenciales...',
              filled: isCerrada,
              fillColor: isCerrada ? Colors.grey.shade100 : null,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _recomController,
            readOnly: isCerrada,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Recomendaciones de Cuidado Preventivo',
              filled: isCerrada,
              fillColor: isCerrada ? Colors.grey.shade100 : null,
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: _garantiaDias,
            decoration: InputDecoration(
              labelText: 'Garantía Otorgada',
              filled: isCerrada,
              fillColor: isCerrada ? Colors.grey.shade100 : null,
            ),
            items: const [
              DropdownMenuItem(value: '30_DIAS', child: Text('30 Días de Garantía')),
              DropdownMenuItem(value: '60_DIAS', child: Text('60 Días de Garantía')),
              DropdownMenuItem(value: '90_DIAS', child: Text('90 Días de Garantía')),
              DropdownMenuItem(value: 'SIN_GARANTIA', child: Text('Sin Garantía (Daño por líquidos / Fuera de cobertura)')),
            ],
            onChanged: isCerrada ? null : (v) => setState(() => _garantiaDias = v!),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nombreRecibeController,
                  readOnly: isCerrada,
                  decoration: InputDecoration(
                    labelText: 'Nombre de Quien Recibe',
                    filled: isCerrada,
                    fillColor: isCerrada ? Colors.grey.shade100 : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _docRecibeController,
                  readOnly: isCerrada,
                  decoration: InputDecoration(
                    labelText: 'Documento de Quien Recibe',
                    filled: isCerrada,
                    fillColor: isCerrada ? Colors.grey.shade100 : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text(
              'Certifico que el cliente ha verificado el encendido, funcionamiento y limpieza del equipo en su presencia y acepta los términos del servicio y garantía legal (Ley 1480 de Colombia).',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            value: _checkConformidad,
            onChanged: isCerrada ? null : (v) => setState(() => _checkConformidad = v!),
          ),
          const SizedBox(height: 24),

          if (!isCerrada)
            ElevatedButton.icon(
              onPressed: _cerrarOrdenYGenerarActa,
              icon: const Icon(Icons.check_circle),
              label: const Text('Finalizar Servicio y Emitir Acta Oficial'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SantiConstants.successGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: SantiConstants.primaryNavy.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: SantiConstants.primaryNavy.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: SantiConstants.successGreen, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Servicio Finalizado y Acta Oficial Registrada',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta orden fue finalizada formalmente y su acta se encuentra firmada. Puede descargar o imprimir el documento oficial en cualquier momento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DocumentoOficialScreen(ordenId: widget.ordenId)),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Descargar / Imprimir Acta Oficial'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SantiConstants.primaryNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
