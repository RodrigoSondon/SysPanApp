import '../services/api_service.dart';
import '../models/pedido_model.dart';
import '../../core/constants/api_constants.dart';

class PedidoRepository {
  final ApiService _apiService = ApiService();

  // Get all pedidos
  Future<List<Pedido>> getPedidos() async {
    try {
      final response = await _apiService.get(ApiConstants.pedidos);
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Pedido.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get pedido by ID
  Future<Pedido> getPedidoById(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.pedidoById(id));
      return Pedido.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get pedidos by estado
  Future<List<Pedido>> getPedidosByEstado(String estado) async {
    try {
      final response = await _apiService.get(ApiConstants.pedidosByEstado(estado));
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Pedido.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get pedidos by cliente
  Future<List<Pedido>> getPedidosByCliente(int clienteId) async {
    try {
      final response = await _apiService.get(ApiConstants.pedidosByCliente(clienteId));
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Pedido.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get detalle pedido
  Future<List<DetallePedido>> getDetallePedido(int idPedido) async {
    try {
      final response = await _apiService.get(ApiConstants.detallePedido(idPedido));
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => DetallePedido.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create pedido
  Future<Pedido> createPedido(Pedido pedido) async {
    try {
      final response = await _apiService.post(
        ApiConstants.pedidos,
        pedido.toJson(),
      );
      return Pedido.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update pedido
  Future<Pedido> updatePedido(Pedido pedido) async {
    try {
      final response = await _apiService.put(
        ApiConstants.pedidoById(pedido.idpedido!),
        pedido.toJson(),
      );
      return Pedido.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Delete pedido
  Future<void> deletePedido(int id) async {
    try {
      await _apiService.delete(ApiConstants.pedidoById(id));
    } catch (e) {
      rethrow;
    }
  }
}
