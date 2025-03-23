class Jornada {
  String? quilometragemId;
  DateTime? jornadaData;
  String? jornadaHora;
  String? motoristaID;
  String? displayName;
  String? telefone;
  String? placa;
  double? km;

  Jornada(
      {this.quilometragemId,
      this.jornadaData,
      this.jornadaHora,
      this.motoristaID,
      this.displayName,
      this.telefone,
      this.placa,
      this.km});

  Jornada.fromJson(Map<String, dynamic> json) {
    quilometragemId = json['quilometragemId'];
    jornadaData = json['jornadaData'] != null
        ? DateTime.tryParse(json['jornadaData'])
        : null;
    jornadaHora = json['jornadaHora'];
    motoristaID = json['motoristaID'];
    displayName = json['displayName'];
    telefone = json['telefone'];
    placa = json['placa'];
    km = json['km'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['quilometragemId'] = quilometragemId;
    data['jornadaData'] = jornadaData?.toIso8601String();
    data['jornadaHora'] = jornadaHora;
    data['motoristaID'] = motoristaID;
    data['displayName'] = displayName;
    data['telefone'] = telefone;
    data['placa'] = placa;
    data['km'] = km;
    return data;
  }
}
