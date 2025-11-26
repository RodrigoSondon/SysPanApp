class Usuario {
  final int? idusuario;
  final String nombre;
  final String correo;
  final String? password;
  final String rol;

  Usuario({
    this.idusuario,
    required this.nombre,
    required this.correo,
    this.password,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idusuario: json['id_usuario'] as int?,
      nombre: json['nombre'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      password: json['contraseña'] as String?,
      rol: json['rol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'email': correo,
      'rol': rol,
    };
    
    if (idusuario != null) {
      data['id_usuario'] = idusuario;
    }
    
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    
    return data;
  }

  Usuario copyWith({
    int? idusuario,
    String? nombre,
    String? correo,
    String? password,
    String? rol,
  }) {
    return Usuario(
      idusuario: idusuario ?? this.idusuario,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      password: password ?? this.password,
      rol: rol ?? this.rol,
    );
  }
}
