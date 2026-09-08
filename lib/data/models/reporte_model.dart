class Reporte {
  final int? idreporte;
  final String tiporeporte;
  final DateTime fechageneracion;
  final int? generadopor;
  final String? nombreUsuario;
  final Map<String, dynamic>? datos;

  Reporte({
    this.idreporte,
    required this.tiporeporte,
    required this.fechageneracion,
    this.generadopor,
    this.nombreUsuario,
    this.datos,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      idreporte: json['idreporte'] as int?,
      tiporeporte: json['tiporeporte'] as String? ?? '',
      fechageneracion: json['fechageneracion'] != null
          ? DateTime.parse(json['fechageneracion'] as String)
          : DateTime.now(),
      generadopor: json['generadopor'] as int?,
      nombreUsuario: json['nombreusuario'] as String?,
      datos: json['datos'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'tiporeporte': tiporeporte,
      'fechageneracion': fechageneracion.toIso8601String().split('T')[0],
    };
    
    if (idreporte != null) {
      data['idreporte'] = idreporte;
    }
    
    if (generadopor != null) {
      data['generadopor'] = generadopor;
    }
    
    if (datos != null) {
      data['datos'] = datos;
    }
    
    return data;
  }

  Reporte copyWith({
    int? idreporte,
    String? tiporeporte,
    DateTime? fechageneracion,
    int? generadopor,
    String? nombreUsuario,
    Map<String, dynamic>? datos,
  }) {
    return Reporte(
      idreporte: idreporte ?? this.idreporte,
      tiporeporte: tiporeporte ?? this.tiporeporte,
      fechageneracion: fechageneracion ?? this.fechageneracion,
      generadopor: generadopor ?? this.generadopor,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      datos: datos ?? this.datos,
    );
  }
}
