import '../services/api_service.dart';
import '../models/receta_model.dart';
import '../../core/constants/api_constants.dart';

class RecetaRepository {
  final ApiService _apiService = ApiService();

  // Get all recetas
  Future<List<Receta>> getRecetas() async {
    try {
      final response = await _apiService.get(ApiConstants.recetas);
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Receta.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get receta by ID
  Future<Receta> getRecetaById(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.recetaById(id));
      return Receta.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get recetas by categoria
  Future<List<Receta>> getRecetasByCategoria(String categoria) async {
    try {
      final response = await _apiService.get(ApiConstants.recetasByCategoria(categoria));
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Receta.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get ingredientes de receta
  Future<List<IngredienteReceta>> getIngredientesReceta(int idReceta) async {
    try {
      final response = await _apiService.get(ApiConstants.ingredientesReceta(idReceta));
      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => IngredienteReceta.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create receta
  Future<Receta> createReceta(Receta receta) async {
    try {
      final response = await _apiService.post(
        ApiConstants.recetas,
        receta.toJson(),
      );
      return Receta.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update receta
  Future<Receta> updateReceta(Receta receta) async {
    try {
      final response = await _apiService.put(
        ApiConstants.recetaById(receta.idreceta!),
        receta.toJson(),
      );
      return Receta.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Delete receta
  Future<void> deleteReceta(int id) async {
    try {
      await _apiService.delete(ApiConstants.recetaById(id));
    } catch (e) {
      rethrow;
    }
  }
}
