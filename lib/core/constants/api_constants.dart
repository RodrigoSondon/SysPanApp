class ApiConstants {
  // Base URL - Configurable for development/production
  // Use 10.0.2.2 for Android emulator to connect to host machine
  static const String baseUrl = 'http://localhost:3000';
  
  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  
  // Usuarios Endpoints
  static const String usuarios = '/users';
  static String usuarioById(int id) => '/users/$id';
  
  // Cliente Endpoints
  static const String clientes = '/clientes';
  static String clienteById(int id) => '/clientes/$id';
  
  // Materia Prima Endpoints
  static const String materiasPrimas = '/materias-primas';
  static String materiaPrimaById(int id) => '/materias-primas/$id';
  static const String materiasPrimasBajoStock = '/materias-primas/bajo-stock';
  static const String materiasPrimasPorVencer = '/materias-primas/por-vencer';
  
  // Receta Endpoints
  static const String recetas = '/recetas';
  static String recetaById(int id) => '/recetas/$id';
  static String recetasByCategoria(String categoria) => '/recetas/categoria/$categoria';
  static String ingredientesReceta(int id) => '/recetas/$id/ingredientes';
  
  // Produccion Endpoints
  static const String producciones = '/producciones';
  static String produccionById(int id) => '/producciones/$id';
  static String produccionesByFecha(String fecha) => '/producciones/fecha/$fecha';
  
  // Pedido Endpoints
  static const String pedidos = '/pedidos';
  static String pedidoById(int id) => '/pedidos/$id';
  static String pedidosByEstado(String estado) => '/pedidos/estado/$estado';
  static String pedidosByCliente(int clienteId) => '/pedidos/cliente/$clienteId';
  static String detallePedido(int id) => '/pedidos/$id/detalle';
  
  // Reporte Endpoints
  static const String reportes = '/reportes';
  static String reporteById(int id) => '/reportes/$id';
  static String reportesByTipo(String tipo) => '/reportes/tipo/$tipo';
  static const String reporteVentas = '/reportes/ventas';
  static const String reporteCostos = '/reportes/costos';
  static const String reporteMermas = '/reportes/mermas';
  static const String reporteInventario = '/reportes/inventario';
  static const String reporteGanancias = '/reportes/ganancias';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> headersWithAuth(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
