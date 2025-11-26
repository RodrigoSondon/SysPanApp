class Pedido {
  final int? idpedido;
  final int idcliente;
  final DateTime fechapedido;
  final DateTime fechaentrega;
  final String prioridad;
  final String estado;
  final String? nombreCliente;
  final List<DetallePedido>? detalles;

  Pedido({
    this.idpedido,
    required this.idcliente,
    required this.fechapedido,
    required this.fechaentrega,
    required this.prioridad,
    required this.estado,
    this.nombreCliente,
    this.detalles,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      idpedido: json['idpedido'] as int?,
      idcliente: json['idcliente'] as int? ?? 0,
      fechapedido: json['fechapedido'] != null
          ? DateTime.parse(json['fechapedido'] as String)
          : DateTime.now(),
      fechaentrega: json['fechaentrega'] != null
          ? DateTime.parse(json['fechaentrega'] as String)
          : DateTime.now(),
      prioridad: json['prioridad'] as String? ?? 'Normal',
      estado: json['estado'] as String? ?? 'Pendiente',
      nombreCliente: json['nombrecliente'] as String?,
      detalles: json['detalles'] != null
          ? (json['detalles'] as List)
              .map((d) => DetallePedido.fromJson(d as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'idcliente': idcliente,
      'fechapedido': fechapedido.toIso8601String().split('T')[0],
      'fechaentrega': fechaentrega.toIso8601String().split('T')[0],
      'prioridad': prioridad,
      'estado': estado,
    };
    
    if (idpedido != null) {
      data['idpedido'] = idpedido;
    }
    
    if (detalles != null) {
      data['detalles'] = detalles!.map((d) => d.toJson()).toList();
    }
    
    return data;
  }

  Pedido copyWith({
    int? idpedido,
    int? idcliente,
    DateTime? fechapedido,
    DateTime? fechaentrega,
    String? prioridad,
    String? estado,
    String? nombreCliente,
    List<DetallePedido>? detalles,
  }) {
    return Pedido(
      idpedido: idpedido ?? this.idpedido,
      idcliente: idcliente ?? this.idcliente,
      fechapedido: fechapedido ?? this.fechapedido,
      fechaentrega: fechaentrega ?? this.fechaentrega,
      prioridad: prioridad ?? this.prioridad,
      estado: estado ?? this.estado,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      detalles: detalles ?? this.detalles,
    );
  }
}

class DetallePedido {
  final int idpedido;
  final int idreceta;
  final int cantidad;
  final String? nombreReceta;

  DetallePedido({
    required this.idpedido,
    required this.idreceta,
    required this.cantidad,
    this.nombreReceta,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      idpedido: json['idpedido'] as int? ?? 0,
      idreceta: json['idreceta'] as int? ?? 0,
      cantidad: json['cantidad'] as int? ?? 0,
      nombreReceta: json['nombrereceta'] as String? ?? json['nombre'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idpedido': idpedido,
      'idreceta': idreceta,
      'cantidad': cantidad,
    };
  }

  DetallePedido copyWith({
    int? idpedido,
    int? idreceta,
    int? cantidad,
    String? nombreReceta,
  }) {
    return DetallePedido(
      idpedido: idpedido ?? this.idpedido,
      idreceta: idreceta ?? this.idreceta,
      cantidad: cantidad ?? this.cantidad,
      nombreReceta: nombreReceta ?? this.nombreReceta,
    );
  }
}
