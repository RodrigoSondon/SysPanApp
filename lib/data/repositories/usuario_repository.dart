import '../models/usuario_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class UsuarioRepository {
  final ApiService _apiService = ApiService();

  // Get all usuarios
  Future<List<Usuario>> getAllUsuarios() async {
    try {
      final response = await _apiService.get(ApiConstants.usuarios);
      
      if (response is List) {
        return response.map((json) => Usuario.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Get usuario by ID
  Future<Usuario> getUsuarioById(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.usuarioById(id));
      return Usuario.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Create usuario
  Future<Usuario> createUsuario(Usuario usuario) async {
    try {
      final response = await _apiService.post(
        ApiConstants.usuarios,
        usuario.toJson(),
      );
      return Usuario.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update usuario
  Future<Usuario> updateUsuario(Usuario usuario) async {
    try {
      final response = await _apiService.put(
        ApiConstants.usuarioById(usuario.idusuario!),
        usuario.toJson(),
      );
      return Usuario.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Delete usuario
  Future<void> deleteUsuario(int id) async {
    try {
      await _apiService.delete(ApiConstants.usuarioById(id));
    } catch (e) {
      rethrow;
    }
  }
}
