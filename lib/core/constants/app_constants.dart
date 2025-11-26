class AppConstants {
  // User Roles
  static const String rolAdministrador = 'Administrador';
  static const String rolPanadero = 'Panadero';
  static const String rolVendedor = 'Vendedor';
  static const String rolCliente = 'Cliente';
  
  static const List<String> roles = [
    rolAdministrador,
    rolPanadero,
    rolVendedor,
    rolCliente,
  ];
  
  // Cliente Types
  static const String tipoMinorista = 'Minorista';
  static const String tipoMayorista = 'Mayorista';
  
  static const List<String> tiposCliente = [
    tipoMinorista,
    tipoMayorista,
  ];
  
  // Receta Categories
  static const String categoriaPanDulce = 'Pan dulce';
  static const String categoriaPanSalado = 'Pan salado';
  static const String categoriaPastel = 'Pastel';
  
  static const List<String> categoriasReceta = [
    categoriaPanDulce,
    categoriaPanSalado,
    categoriaPastel,
  ];
  
  // Pedido Priority
  static const String prioridadNormal = 'Normal';
  static const String prioridadUrgente = 'Urgente';
  
  static const List<String> prioridades = [
    prioridadNormal,
    prioridadUrgente,
  ];
  
  // Pedido Status
  static const String estadoPendiente = 'Pendiente';
  static const String estadoEnProceso = 'En Proceso';
  static const String estadoEntregado = 'Entregado';
  
  static const List<String> estadosPedido = [
    estadoPendiente,
    estadoEnProceso,
    estadoEntregado,
  ];
  
  // Reporte Types
  static const String reporteVentas = 'Ventas';
  static const String reporteCostos = 'Costos';
  static const String reporteMermas = 'Mermas';
  static const String reporteInventario = 'Inventario';
  static const String reporteGanancia = 'Ganancia';
  
  static const List<String> tiposReporte = [
    reporteVentas,
    reporteCostos,
    reporteMermas,
    reporteInventario,
    reporteGanancia,
  ];
  
  // Unidades de Medida
  static const List<String> unidadesMedida = [
    'kg',
    'g',
    'L',
    'mL',
    'unidad',
    'paquete',
    'bolsa',
  ];
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  
  // App Info
  static const String appName = 'SysPan';
  static const String appVersion = '1.0.0';
}
