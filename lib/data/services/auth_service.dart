import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/usuario_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Usuario> login(String correo, String password) async {
    try {
      print('Attempting login with email: $correo');
      
      final response = await _apiService.post(
        ApiConstants.login,
        {
          'email': correo,
          'password': password,
        },
      );

      print('Login response received: $response');

      if (response == null) {
        throw Exception('La respuesta del servidor está vacía');
      }

      // Check if response has the expected structure
      if (!response.containsKey('token')) {
        print('Response keys: ${response.keys}');
        throw Exception('Respuesta inválida del servidor: falta el token');
      }

      final token = response['token'];
      print('Token received, length: ${token?.toString().length ?? 0}');
      
      if (token == null || token.toString().isEmpty) {
        throw Exception('Token vacío recibido del servidor');
      }
      
      // The API returns user data in 'user' field
      Map<String, dynamic> usuarioData;
      if (response.containsKey('user')) {
        usuarioData = response['user'] as Map<String, dynamic>;
        print('User data from "user" field: $usuarioData');
      } else if (response.containsKey('usuario')) {
        usuarioData = response['usuario'] as Map<String, dynamic>;
        print('User data from "usuario" field');
      } else {
        // If the user data is at the root level
        usuarioData = Map<String, dynamic>.from(response);
        usuarioData.remove('token');
        usuarioData.remove('message');
        print('User data from root level');
      }
      
      print('Parsing usuario data...');
      final usuario = Usuario.fromJson(usuarioData);
      print('Usuario parsed successfully: ${usuario.nombre}, rol: ${usuario.rol}');

      // Save token and user data
      await _apiService.setAuthToken(token.toString());
      await _saveUserData(usuario);

      return usuario;
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Call logout endpoint if exists
      try {
        await _apiService.post(ApiConstants.logout, {});
      } catch (_) {
        // Continue even if logout endpoint fails
      }

      // Clear local data
      await _apiService.clearAuthToken();
      await _clearUserData();
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Get current user
  Future<Usuario?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(AppConstants.keyUserId);
      final userName = prefs.getString(AppConstants.keyUserName);
      final userEmail = prefs.getString(AppConstants.keyUserEmail);
      final userRole = prefs.getString(AppConstants.keyUserRole);

      print('Getting current user from local storage:');
      print('  userId: $userId');
      print('  userName: $userName');
      print('  userEmail: $userEmail');
      print('  userRole: $userRole');

      if (userId == null || userName == null || userEmail == null || userRole == null) {
        print('Some user data is missing, returning null');
        return null;
      }

      return Usuario(
        idusuario: userId,
        nombre: userName,
        correo: userEmail,
        rol: userRole,
      );
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Save user data locally
  Future<void> _saveUserData(Usuario usuario) async {
    print('Saving user data locally:');
    print('  idusuario: ${usuario.idusuario}');
    print('  nombre: ${usuario.nombre}');
    print('  correo: ${usuario.correo}');
    print('  rol: ${usuario.rol}');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyUserId, usuario.idusuario ?? 0);
    await prefs.setString(AppConstants.keyUserName, usuario.nombre);
    await prefs.setString(AppConstants.keyUserEmail, usuario.correo);
    await prefs.setString(AppConstants.keyUserRole, usuario.rol);
    
    print('User data saved successfully');
  }

  // Clear user data
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyUserId);
    await prefs.remove(AppConstants.keyUserName);
    await prefs.remove(AppConstants.keyUserEmail);
    await prefs.remove(AppConstants.keyUserRole);
  }

  // Register (if needed)
  Future<Usuario> register(String nombre, String correo, String password, String rol) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        {
          'nombre': nombre,
          'email': correo,
          'password': password,
          'rol': rol,
        },
      );

      // The API might return user data in different formats
      if (response.containsKey('user')) {
        final usuarioData = response['user'] as Map<String, dynamic>;
        return Usuario.fromJson(usuarioData);
      } else if (response.containsKey('usuario')) {
        final usuarioData = response['usuario'] as Map<String, dynamic>;
        return Usuario.fromJson(usuarioData);
      } else {
        // If user data is at root level
        return Usuario.fromJson(response as Map<String, dynamic>);
      }
    } catch (e) {
      rethrow;
    }
  }
}
