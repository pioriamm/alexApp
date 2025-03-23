class Motorista {
  String? login;
  String? telefone;
  String? displayName;
  String? motoristaID;
  bool? isAdim;

  Motorista({this.login, this.telefone, this.displayName, this.isAdim});

  Motorista.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    telefone = json['telefone'];
    displayName = json['displayName'];
    motoristaID = json['motoristaID'];
    isAdim = json['isAdim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['login'] = this.login;
    data['telefone'] = this.telefone;
    data['displayName'] = this.displayName;
    data['motoristaID'] = this.motoristaID;
    data['isAdmin'] = this.isAdim;
    return data;
  }
}
