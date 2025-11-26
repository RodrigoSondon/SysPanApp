class MateriaPrima {
  final int? idmateriaprima;
  final String nombre;
  final String unidadmedida;
  final double cantidaddisponible;
  final String? proveedor;
  final DateTime? fechacaducidad;
  final double cantidadminima;

  MateriaPrima({
    this.idmateriaprima,
    required this.nombre,
    required this.unidadmedida,
    required this.cantidaddisponible,
    this.proveedor,
    this.fechacaducidad,
    required this.cantidadminima,
  });

  factory MateriaPrima.fromJson(Map<String, dynamic> json) {
    return MateriaPrima(
      idmateriaprima: json['idmateriaprima'] as int?,
      nombre: json['nombre'] as String? ?? '',
      unidadmedida: json['unidadmedida'] as String? ?? '',
      cantidaddisponible: (json['cantidaddisponible'] as num?)?.toDouble() ?? 0.0,
      proveedor: json['proveedor'] as String?,
      fechacaducidad: json['fechacaducidad'] != null 
          ? DateTime.parse(json['fechacaducidad'] as String)
          : null,
      cantidadminima: (json['cantidadminima'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'unidadmedida': unidadmedida,
      'cantidaddisponible': cantidaddisponible,
      'cantidadminima': cantidadminima,
    };
    
    if (idmateriaprima != null) {
      data['idmateriaprima'] = idmateriaprima;
    }
    
    if (proveedor != null) {
      data['proveedor'] = proveedor;
    }
    
    if (fechacaducidad != null) {
      data['fechacaducidad'] = fechacaducidad!.toIso8601String().split('T')[0];
    }
    
    return data;
  }

  MateriaPrima copyWith({
    int? idmateriaprima,
    String? nombre,
    String? unidadmedida,
    double? cantidaddisponible,
    String? proveedor,
    DateTime? fechacaducidad,
    double? cantidadminima,
  }) {
    return MateriaPrima(
      idmateriaprima: idmateriaprima ?? this.idmateriaprima,
      nombre: nombre ?? this.nombre,
      unidadmedida: unidadmedida ?? this.unidadmedida,
      cantidaddisponible: cantidaddisponible ?? this.cantidaddisponible,
      proveedor: proveedor ?? this.proveedor,
      fechacaducidad: fechacaducidad ?? this.fechacaducidad,
      cantidadminima: cantidadminima ?? this.cantidadminima,
    );
  }
  
  // Helper methods
  bool get isBajoStock => cantidaddisponible <= cantidadminima;
  
  bool get isExpired {
    if (fechacaducidad == null) return false;
    return fechacaducidad!.isBefore(DateTime.now());
  }
  
  bool get isExpiringSoon {
    if (fechacaducidad == null) return false;
    final daysUntilExpiration = fechacaducidad!.difference(DateTime.now()).inDays;
    return daysUntilExpiration >= 0 && daysUntilExpiration <= 7;
  }
}
