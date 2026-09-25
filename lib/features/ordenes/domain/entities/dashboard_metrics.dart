class DashboardMetrics {
  final int totalOrdenes;
  final int enTaller;
  final int resueltos;
  final int entregadosCerrados;

  const DashboardMetrics({
    required this.totalOrdenes,
    required this.enTaller,
    required this.resueltos,
    required this.entregadosCerrados,
  });

  const DashboardMetrics.empty()
      : totalOrdenes = 0,
        enTaller = 0,
        resueltos = 0,
        entregadosCerrados = 0;
}
