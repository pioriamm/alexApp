class Motorista {
  String? login;
  String? telefone;
  String? displayName;
  String? Id;
  int? perfilAcesso;
  String? celularId;

  Motorista(
      {this.login,
      this.telefone,
      this.displayName,
      this.perfilAcesso,
      this.Id,
      this.celularId});

  Motorista.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    telefone = json['telefone'];
    displayName = json['displayName'];
    Id = json['id'];
    perfilAcesso = json['perfilAcesso'];
    celularId = json['celularId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['telefone'] = this.telefone;
    data['displayName'] = this.displayName;
    data['id'] = this.Id;
    data['perfilAcesso'] = this.perfilAcesso;
    data['celularId'] = this.celularId;
    return data;
  }
}
