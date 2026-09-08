import '../services/api_service.dart';
import '../models/materia_prima_model.dart';
import '../../core/constants/api_constants.dart';

class InventarioRepository {
  final ApiService _apiService = ApiService();

  // Get all materias primas
  Future<List<MateriaPrima>> getMateriasPrimas() async {
    try {
      final response = await _apiService.get(ApiConstants.materiasPrimas);
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => MateriaPrima.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get materia prima by ID
  Future<MateriaPrima> getMateriaPrimaById(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.materiaPrimaById(id));
      return MateriaPrima.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get materias primas bajo stock
  Future<List<MateriaPrima>> getMateriasPrimasBajoStock() async {
    try {
      final response = await _apiService.get(ApiConstants.materiasPrimasBajoStock);
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => MateriaPrima.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get materias primas por vencer
  Future<List<MateriaPrima>> getMateriasPrimasPorVencer() async {
    try {
      final response = await _apiService.get(ApiConstants.materiasPrimasPorVencer);
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => MateriaPrima.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create materia prima
  Future<MateriaPrima> createMateriaPrima(MateriaPrima materiaPrima) async {
    try {
      final response = await _apiService.post(
        ApiConstants.materiasPrimas,
        materiaPrima.toJson(),
      );
      return MateriaPrima.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update materia prima
  Future<MateriaPrima> updateMateriaPrima(MateriaPrima materiaPrima) async {
    try {
      final response = await _apiService.put(
        ApiConstants.materiaPrimaById(materiaPrima.idmateriaprima!),
        materiaPrima.toJson(),
      );
      return MateriaPrima.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Delete materia prima
  Future<void> deleteMateriaPrima(int id) async {
    try {
      await _apiService.delete(ApiConstants.materiaPrimaById(id));
    } catch (e) {
      rethrow;
    }
  }
}
