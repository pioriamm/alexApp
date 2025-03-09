class Motorista {
  String? login;
  String? telefone;
  String? displayName;
  String? motoristaID;

  Motorista({this.login, this.telefone, this.displayName});

  Motorista.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    telefone = json['telefone'];
    displayName = json['displayName'];
    motoristaID = json['motoristaID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['telefone'] = this.telefone;
    data['displayName'] = this.displayName;
    data['motoristaID'] = this.motoristaID;
    return data;
  }
}
