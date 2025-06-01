class Jornada {
  String? id;
  DateTime? jornadaData;
  String? jornadaLocalidade;
  String? motoristaID;
  String? displayName;
  String? telefone;
  String? placa;
  double? km;

  Jornada(
      {this.id,
      this.jornadaData,
      this.jornadaLocalidade,
      this.motoristaID,
      this.displayName,
      this.telefone,
      this.placa,
      this.km});

  Jornada.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jornadaData = json['jornadaData'] != null
        ? DateTime.tryParse(json['jornadaData'])
        : null;
    jornadaLocalidade = json['jornadaLocalidade'];
    motoristaID = json['motoristaID'];
    displayName = json['displayName'];
    telefone = json['telefone'];
    placa = json['placa'];
    km = json['km'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['jornadaData'] = jornadaData?.toIso8601String();
    data['jornadaLocalidade'] = jornadaLocalidade;
    data['motoristaID'] = motoristaID;
    data['displayName'] = displayName;
    data['telefone'] = telefone;
    data['placa'] = placa;
    data['km'] = km;
    return data;
  }
}
