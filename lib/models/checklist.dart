class Checklist {
  String id;
  DateTime data;

  // Dados iniciais
  bool aceiteInformativo;
  String nomeMotorista;
  String placaVeiculo;
  String kmVeiculo;
  String operacao;
  String? anormalidades;

  String motoristaId;

  // Itens do checklist
  bool liquidoArrefecimento;
  bool direcaoAjustadaSemFolga;
  bool travaTampasSemDesgaste;
  bool cilindroSemVazamento;
  bool borrachaMangueirasOk;
  bool mangueirasSemMalhas;
  bool lonasCacambaEnlonadorOk;
  bool freioServico;
  bool freioEstacionamento;
  bool cintoSeguranca;
  bool retrovisoresOk;
  bool placasOk;
  bool faixasRefletivasOk;
  bool parabrisaOk;
  bool buzinaOk;
  bool sireneReOk;
  bool luzCacambaOk;
  bool faroisLuzesOk;
  bool limpadorParabrisaOk;
  bool luzSuspensorEixoOk;
  bool vidrosFuncionando;
  bool cabineLimpa;
  bool pneusOk;
  bool temEstepe;
  bool setasParafusoRodaOk;
  bool paralamasParabarroOk;
  bool conesCalcosOk;
  bool tacografoOk;
  bool epiOk;

  Checklist({
    required this.id,
    required this.data,
    required this.aceiteInformativo,
    required this.nomeMotorista,
    required this.placaVeiculo,
    required this.kmVeiculo,
    required this.operacao,
    this.anormalidades,
    required this.motoristaId,
    required this.liquidoArrefecimento,
    required this.direcaoAjustadaSemFolga,
    required this.travaTampasSemDesgaste,
    required this.cilindroSemVazamento,
    required this.borrachaMangueirasOk,
    required this.mangueirasSemMalhas,
    required this.lonasCacambaEnlonadorOk,
    required this.freioServico,
    required this.freioEstacionamento,
    required this.cintoSeguranca,
    required this.retrovisoresOk,
    required this.placasOk,
    required this.faixasRefletivasOk,
    required this.parabrisaOk,
    required this.buzinaOk,
    required this.sireneReOk,
    required this.luzCacambaOk,
    required this.faroisLuzesOk,
    required this.limpadorParabrisaOk,
    required this.luzSuspensorEixoOk,
    required this.vidrosFuncionando,
    required this.cabineLimpa,
    required this.pneusOk,
    required this.temEstepe,
    required this.setasParafusoRodaOk,
    required this.paralamasParabarroOk,
    required this.conesCalcosOk,
    required this.tacografoOk,
    required this.epiOk,
  });

  // Conversão para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'aceiteInformativo': aceiteInformativo,
      'nomeMotorista': nomeMotorista,
      'placaVeiculo': placaVeiculo,
      'kmVeiculo': kmVeiculo,
      'operacao': operacao,
      'anormalidades': anormalidades,
      'motoristaId': motoristaId,
      'liquidoArrefecimento': liquidoArrefecimento,
      'direcaoAjustadaSemFolga': direcaoAjustadaSemFolga,
      'travaTampasSemDesgaste': travaTampasSemDesgaste,
      'cilindroSemVazamento': cilindroSemVazamento,
      'borrachaMangueirasOk': borrachaMangueirasOk,
      'mangueirasSemMalhas': mangueirasSemMalhas,
      'lonasCacambaEnlonadorOk': lonasCacambaEnlonadorOk,
      'freioServico': freioServico,
      'freioEstacionamento': freioEstacionamento,
      'cintoSeguranca': cintoSeguranca,
      'retrovisoresOk': retrovisoresOk,
      'placasOk': placasOk,
      'faixasRefletivasOk': faixasRefletivasOk,
      'parabrisaOk': parabrisaOk,
      'buzinaOk': buzinaOk,
      'sireneReOk': sireneReOk,
      'luzCacambaOk': luzCacambaOk,
      'faroisLuzesOk': faroisLuzesOk,
      'limpadorParabrisaOk': limpadorParabrisaOk,
      'luzSuspensorEixoOk': luzSuspensorEixoOk,
      'vidrosFuncionando': vidrosFuncionando,
      'cabineLimpa': cabineLimpa,
      'pneusOk': pneusOk,
      'temEstepe': temEstepe,
      'setasParafusoRodaOk': setasParafusoRodaOk,
      'paralamasParabarroOk': paralamasParabarroOk,
      'conesCalcosOk': conesCalcosOk,
      'tacografoOk': tacografoOk,
      'epiOk': epiOk,
    };
  }

  // Conversão de JSON para objeto
  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'],
      data: DateTime.parse(json['data']),
      aceiteInformativo: json['aceiteInformativo'],
      nomeMotorista: json['nomeMotorista'],
      placaVeiculo: json['placaVeiculo'],
      kmVeiculo: json['kmVeiculo'],
      operacao: json['operacao'],
      anormalidades: json['anormalidades'],
      motoristaId: json['motoristaId'],
      liquidoArrefecimento: json['liquidoArrefecimento'],
      direcaoAjustadaSemFolga: json['direcaoAjustadaSemFolga'],
      travaTampasSemDesgaste: json['travaTampasSemDesgaste'],
      cilindroSemVazamento: json['cilindroSemVazamento'],
      borrachaMangueirasOk: json['borrachaMangueirasOk'],
      mangueirasSemMalhas: json['mangueirasSemMalhas'],
      lonasCacambaEnlonadorOk: json['lonasCacambaEnlonadorOk'],
      freioServico: json['freioServico'],
      freioEstacionamento: json['freioEstacionamento'],
      cintoSeguranca: json['cintoSeguranca'],
      retrovisoresOk: json['retrovisoresOk'],
      placasOk: json['placasOk'],
      faixasRefletivasOk: json['faixasRefletivasOk'],
      parabrisaOk: json['parabrisaOk'],
      buzinaOk: json['buzinaOk'],
      sireneReOk: json['sireneReOk'],
      luzCacambaOk: json['luzCacambaOk'],
      faroisLuzesOk: json['faroisLuzesOk'],
      limpadorParabrisaOk: json['limpadorParabrisaOk'],
      luzSuspensorEixoOk: json['luzSuspensorEixoOk'],
      vidrosFuncionando: json['vidrosFuncionando'],
      cabineLimpa: json['cabineLimpa'],
      pneusOk: json['pneusOk'],
      temEstepe: json['temEstepe'],
      setasParafusoRodaOk: json['setasParafusoRodaOk'],
      paralamasParabarroOk: json['paralamasParabarroOk'],
      conesCalcosOk: json['conesCalcosOk'],
      tacografoOk: json['tacografoOk'],
      epiOk: json['epiOk'],
    );
  }
}
