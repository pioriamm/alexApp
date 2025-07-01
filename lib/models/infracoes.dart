class Infracoes {
  String? infracaoId;
  String? entradaInfracao;
  String? saidaInfracao;
  bool? velocidade;
  bool? reclamacao;
  bool? multa;
  bool? pequenaMonta;
  bool? grandeMonta;
  String? motoristaId;

  Infracoes(
      {this.infracaoId,
      this.entradaInfracao,
      this.saidaInfracao,
      this.velocidade,
      this.reclamacao,
      this.multa,
      this.pequenaMonta,
      this.grandeMonta,
      this.motoristaId});

  Infracoes.fromJson(Map<String, dynamic> json) {
    infracaoId = json['infracaoId'];
    entradaInfracao = json['entradaInfracao'];
    saidaInfracao = json['saidaInfracao'];
    velocidade = json['velocidade'];
    reclamacao = json['reclamacao'];
    multa = json['multa'];
    pequenaMonta = json['pequenaMonta'];
    grandeMonta = json['grandeMonta'];
    motoristaId = json['motoristaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['infracaoId'] = this.infracaoId;
    data['entradaInfracao'] = this.entradaInfracao;
    data['saidaInfracao'] = this.saidaInfracao;
    data['velocidade'] = this.velocidade;
    data['reclamacao'] = this.reclamacao;
    data['multa'] = this.multa;
    data['pequenaMonta'] = this.pequenaMonta;
    data['grandeMonta'] = this.grandeMonta;
    data['motoristaId'] = this.motoristaId;
    return data;
  }
}
