class Produccion {
  final int? idproduccion;
  final int idreceta;
  final DateTime fecha;
  final int cantidadproducida;
  final int cantidadmerma;
  final String? nombreReceta;

  Produccion({
    this.idproduccion,
    required this.idreceta,
    required this.fecha,
    required this.cantidadproducida,
    required this.cantidadmerma,
    this.nombreReceta,
  });

  factory Produccion.fromJson(Map<String, dynamic> json) {
    return Produccion(
      idproduccion: json['idproduccion'] as int?,
      idreceta: json['idreceta'] as int? ?? 0,
      fecha: json['fecha'] != null
          ? DateTime.parse(json['fecha'] as String)
          : DateTime.now(),
      cantidadproducida: json['cantidadproducida'] as int? ?? 0,
      cantidadmerma: json['cantidadmerma'] as int? ?? 0,
      nombreReceta: json['nombrereceta'] as String? ?? json['nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'idreceta': idreceta,
      'fecha': fecha.toIso8601String().split('T')[0],
      'cantidadproducida': cantidadproducida,
      'cantidadmerma': cantidadmerma,
    };
    
    if (idproduccion != null) {
      data['idproduccion'] = idproduccion;
    }
    
    return data;
  }

  Produccion copyWith({
    int? idproduccion,
    int? idreceta,
    DateTime? fecha,
    int? cantidadproducida,
    int? cantidadmerma,
    String? nombreReceta,
  }) {
    return Produccion(
      idproduccion: idproduccion ?? this.idproduccion,
      idreceta: idreceta ?? this.idreceta,
      fecha: fecha ?? this.fecha,
      cantidadproducida: cantidadproducida ?? this.cantidadproducida,
      cantidadmerma: cantidadmerma ?? this.cantidadmerma,
      nombreReceta: nombreReceta ?? this.nombreReceta,
    );
  }
  
  // Helper methods
  int get cantidadTotal => cantidadproducida + cantidadmerma;
  
  double get porcentajeMerma {
    if (cantidadTotal == 0) return 0.0;
    return (cantidadmerma / cantidadTotal) * 100;
  }
}
