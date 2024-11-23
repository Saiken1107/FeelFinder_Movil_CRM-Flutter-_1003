class OportunidadVenta {
  int id;
  String nombreCliente;
  String descripcion;
  int valorEstimado;
  DateTime fechaCierre;
  String estado;

  OportunidadVenta({
    required this.id,
    required this.nombreCliente,
    required this.descripcion,
    required this.valorEstimado,
    required this.fechaCierre,
    required this.estado,
  });

  factory OportunidadVenta.fromJson(Map<String, dynamic> json) {
    return OportunidadVenta(
      id: json['id'],
      nombreCliente: json['nombreCliente'],
      descripcion: json['descripcion'],
      valorEstimado: json['valorEstimado'],
      fechaCierre: DateTime.parse(json['fechaCierre']),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreCliente': nombreCliente,
      'descripcion': descripcion,
      'valorEstimado': valorEstimado,
      'fechaCierre': fechaCierre.toIso8601String(),
      'estado': estado,
    };
  }
}
