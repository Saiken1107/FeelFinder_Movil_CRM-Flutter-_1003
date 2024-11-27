class Cotizacion {
  int id;
  String cliente;
  String descripcion;
  double precio;
  DateTime fecha;

  Cotizacion({
    required this.id,
    required this.cliente,
    required this.descripcion,
    required this.precio,
    required this.fecha,
  });

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      id: json['id'],
      cliente: json['cliente'],
      descripcion: json['descripcion'],
      precio: json['precio'],
      fecha: DateTime.parse(json['fecha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente': cliente,
      'descripcion': descripcion,
      'precio': precio,
      'fecha': fecha.toIso8601String(),
    };
  }
}
