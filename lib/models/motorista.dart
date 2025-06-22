class Motorista {
  String? login;
  String? telefone;
  String? displayName;
  String? Id;
  bool? isAdim;
  String? celularId;

  Motorista(
      {this.login,
      this.telefone,
      this.displayName,
      this.isAdim,
      this.Id,
      this.celularId});

  Motorista.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    telefone = json['telefone'];
    displayName = json['displayName'];
    Id = json['id'];
    isAdim = json['isAdim'];
    celularId = json['celularId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['telefone'] = this.telefone;
    data['displayName'] = this.displayName;
    data['id'] = this.Id;
    data['isAdim'] = this.isAdim;
    data['celularId'] = this.celularId;
    return data;
  }
}
