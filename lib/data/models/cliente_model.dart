class Cliente {
  final int? idcliente;
  final String nombre;
  final String tipo;
  final String? correo;
  final String? telefono;

  Cliente({
    this.idcliente,
    required this.nombre,
    required this.tipo,
    this.correo,
    this.telefono,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idcliente: json['idcliente'] as int?,
      nombre: json['nombre'] as String? ?? '',
      tipo: json['tipo'] as String? ?? '',
      correo: json['correo'] as String?,
      telefono: json['telefono'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'tipo': tipo,
    };
    
    if (idcliente != null) {
      data['idcliente'] = idcliente;
    }
    
    if (correo != null) {
      data['correo'] = correo;
    }
    
    if (telefono != null) {
      data['telefono'] = telefono;
    }
    
    return data;
  }

  Cliente copyWith({
    int? idcliente,
    String? nombre,
    String? tipo,
    String? correo,
    String? telefono,
  }) {
    return Cliente(
      idcliente: idcliente ?? this.idcliente,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
    );
  }
}
