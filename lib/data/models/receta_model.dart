class Receta {
  final int? idreceta;
  final String nombre;
  final String categoria;
  final String? pasos;
  final List<IngredienteReceta>? ingredientes;

  Receta({
    this.idreceta,
    required this.nombre,
    required this.categoria,
    this.pasos,
    this.ingredientes,
  });

  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      idreceta: json['idreceta'] as int?,
      nombre: json['nombre'] as String? ?? '',
      categoria: json['categoria'] as String? ?? '',
      pasos: json['pasos'] as String?,
      ingredientes: json['ingredientes'] != null
          ? (json['ingredientes'] as List)
              .map((i) => IngredienteReceta.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'categoria': categoria,
    };
    
    if (idreceta != null) {
      data['idreceta'] = idreceta;
    }
    
    if (pasos != null) {
      data['pasos'] = pasos;
    }
    
    if (ingredientes != null) {
      data['ingredientes'] = ingredientes!.map((i) => i.toJson()).toList();
    }
    
    return data;
  }

  Receta copyWith({
    int? idreceta,
    String? nombre,
    String? categoria,
    String? pasos,
    List<IngredienteReceta>? ingredientes,
  }) {
    return Receta(
      idreceta: idreceta ?? this.idreceta,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      pasos: pasos ?? this.pasos,
      ingredientes: ingredientes ?? this.ingredientes,
    );
  }
}

class IngredienteReceta {
  final int idreceta;
  final int idmateriaprima;
  final double cantidadnecesaria;
  final String? nombreMateriaPrima;
  final String? unidadmedida;

  IngredienteReceta({
    required this.idreceta,
    required this.idmateriaprima,
    required this.cantidadnecesaria,
    this.nombreMateriaPrima,
    this.unidadmedida,
  });

  factory IngredienteReceta.fromJson(Map<String, dynamic> json) {
    return IngredienteReceta(
      idreceta: json['idreceta'] as int? ?? 0,
      idmateriaprima: json['idmateriaprima'] as int? ?? 0,
      cantidadnecesaria: (json['cantidadnecesaria'] as num?)?.toDouble() ?? 0.0,
      nombreMateriaPrima: json['nombremateria'] as String? ?? json['nombre'] as String?,
      unidadmedida: json['unidadmedida'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idreceta': idreceta,
      'idmateriaprima': idmateriaprima,
      'cantidadnecesaria': cantidadnecesaria,
    };
  }

  IngredienteReceta copyWith({
    int? idreceta,
    int? idmateriaprima,
    double? cantidadnecesaria,
    String? nombreMateriaPrima,
    String? unidadmedida,
  }) {
    return IngredienteReceta(
      idreceta: idreceta ?? this.idreceta,
      idmateriaprima: idmateriaprima ?? this.idmateriaprima,
      cantidadnecesaria: cantidadnecesaria ?? this.cantidadnecesaria,
      nombreMateriaPrima: nombreMateriaPrima ?? this.nombreMateriaPrima,
      unidadmedida: unidadmedida ?? this.unidadmedida,
    );
  }
}
