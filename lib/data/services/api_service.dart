import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  // Get auth token
  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    return _authToken;
  }

  // Set auth token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear auth token
  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final token = await getAuthToken();
      final headers = token != null
          ? ApiConstants.headersWithAuth(token)
          : ApiConstants.headers;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final token = await getAuthToken();
      final headers = token != null
          ? ApiConstants.headersWithAuth(token)
          : ApiConstants.headers;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final token = await getAuthToken();
      final headers = token != null
          ? ApiConstants.headersWithAuth(token)
          : ApiConstants.headers;

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final token = await getAuthToken();
      final headers = token != null
          ? ApiConstants.headersWithAuth(token)
          : ApiConstants.headers;

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Por favor inicie sesión nuevamente.');
    } else if (response.statusCode == 403) {
      throw Exception('No tiene permisos para realizar esta acción.');
    } else if (response.statusCode == 404) {
      throw Exception('Recurso no encontrado.');
    } else if (response.statusCode >= 500) {
      throw Exception('Error del servidor. Por favor intente más tarde.');
    } else {
      final errorBody = jsonDecode(response.body);
      final message = errorBody['message'] ?? errorBody['error'] ?? 'Error desconocido';
      throw Exception(message);
    }
  }

  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is Exception) return error;
    return Exception('Error de conexión. Verifique su conexión a internet.');
  }
}
