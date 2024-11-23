class TableroRendimiento {
  int leadsConcretados;
  int leadsCerrados;
  double tasaConversion;

  TableroRendimiento({
    required this.leadsConcretados,
    required this.leadsCerrados,
    required this.tasaConversion,
  });

  factory TableroRendimiento.fromJson(Map<String, dynamic> json) {
    return TableroRendimiento(
      leadsConcretados: json['leadsConcretados'],
      leadsCerrados: json['leadsCerrados'],
      tasaConversion: json['tasaConversion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leadsConcretados': leadsConcretados,
      'leadsCerrados': leadsCerrados,
      'tasaConversion': tasaConversion,
    };
  }
}
