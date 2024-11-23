class ListaPrecios {
  int id;
  String tipoPlan;
  double precioPlan;
  String empresa;
  int cantidadLicencias;
  int duracionContrato;
  double precioFinal;

  ListaPrecios({
    required this.id,
    required this.tipoPlan,
    required this.precioPlan,
    required this.empresa,
    required this.cantidadLicencias,
    required this.duracionContrato,
    required this.precioFinal,
  });

  factory ListaPrecios.fromJson(Map<String, dynamic> json) {
    return ListaPrecios(
      id: json['id'],
      tipoPlan: json['tipoPlan'],
      precioPlan: json['precioPlan'],
      empresa: json['empresa'],
      cantidadLicencias: json['cantidadLicencias'],
      duracionContrato: json['duracionContrato'],
      precioFinal: json['precioFinal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipoPlan': tipoPlan,
      'precioPlan': precioPlan,
      'empresa': empresa,
      'cantidadLicencias': cantidadLicencias,
      'duracionContrato': duracionContrato,
      'precioFinal': precioFinal,
    };
  }
}
