import 'package:alex/helps/formatadores.dart';
import 'package:alex/models/jornada.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/repository/api_infracoes.dart';
import 'package:flutter/material.dart';

import '../../../controlls/premiacao.dart';
import '../../../helps/mudarDePagina.dart';
import '../../../models/infracoes.dart';
import '../../../repository/api_jornada.dart';
import 'mobilie_login.dart';

class TelaDashMotorista extends StatefulWidget {
  final Motorista motorista;
  const TelaDashMotorista({Key? key, required this.motorista})
      : super(key: key);

  @override
  State<TelaDashMotorista> createState() => _TelaDashMotoristaState();
}

class _TelaDashMotoristaState extends State<TelaDashMotorista> {
  List<Jornada> listaJornadas = [];
  bool isLoading = false;
  double valorPremio = 0.0;
  double valorKm = 0.0;
  double jornada = 0.0;
  double seguranca = 0.0;
  double produtividade = 0.0;
  late DateTime ultimaApuracao;
  final hoje = DateTime.now();

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ultimaApuracao = _hojeMenosUm(hoje);
    _pageController.addListener(_onPageChanged);
    carregarJornadasNaoAuditadas();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    int page = _pageController.page?.round() ?? 0;
    if (page == 0) {
      carregarJornadasNaoAuditadas();
    } else {
      carregarJornadasAuditadas();
    }
  }

  Future<void> carregarJornadasAuditadas() async {
    setState(() => isLoading = true);
    try {
      final jornadas = await ApiJornada.buscarJornadasPorMotoristaId(
        dataInicial: _hojeMenosDois(ultimaApuracao),
        dataFinal: ultimaApuracao,
        motoristaID: widget.motorista.Id!,
      );
      final infracoes = await ApiInfracoes.buscarInfracoesPorMotoristaId(
        dataInicial: _hojeMenosDois(ultimaApuracao),
        dataFinal: ultimaApuracao,
        motoristaID: widget.motorista.Id!,
      );
      double novoValorKm =
          jornadas.fold(0.0, (soma, x) => soma + (x.km ?? 0.0));

      setState(() {
        listaJornadas = jornadas;
        valorKm = novoValorKm;
        valorPremio = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.valorTotalPremio(valorKm, valorKm);
        jornada = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.faixaJornada(valorKm).$2;
        seguranca = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.faixaSeguranca(verificarInfracoes(infracoes)).$2;
        produtividade = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.faixaProdutividade(valorKm).$2;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> carregarJornadasNaoAuditadas() async {
    setState(() => isLoading = true);
    try {
      final jornadas = await ApiJornada.buscarJornadasPorMotoristaId(
        dataInicial: ultimaApuracao,
        dataFinal: hoje,
        motoristaID: widget.motorista.Id!,
      );

      final infracoes = await ApiInfracoes.buscarInfracoesPorMotoristaId(
        dataInicial: ultimaApuracao,
        dataFinal: hoje,
        motoristaID: widget.motorista.Id!,
      );
      double novoValorKm =
          jornadas.fold(0.0, (soma, x) => soma + (x.km ?? 0.0));

      setState(() {
        listaJornadas = jornadas;
        valorKm = novoValorKm;
        valorPremio = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.valorTotalPremio(valorKm, valorKm);
        jornada = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.faixaJornada(valorKm).$2;
        seguranca = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.faixaSeguranca(verificarInfracoes(infracoes)).$2;
        produtividade = verificarInfracoesGrandeMonta(infracoes)
            ? 0.0
            : Premiacao.faixaProdutividade(valorKm).$2;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool verificarInfracoesGrandeMonta(List<Infracoes> infracoes) {
    return infracoes.any((e) => e?.grandeMonta == true);
  }

  int verificarInfracoes(List<Infracoes> infracoes) {
    bool temAlgumTrue = infracoes.any((e) =>
        e.velocidade == true ||
        e.reclamacao == true ||
        e.multa == true ||
        e.pequenaMonta == true);

    if (temAlgumTrue) {
      return 11;
    } else {
      return infracoes.fold(0, (soma, e) {
        int count = 0;
        if (e.velocidade == false) count++;
        if (e.reclamacao == false) count++;
        if (e.multa == false) count++;
        if (e.pequenaMonta == false) count++;
        return soma + count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            int page = _pageController.page?.round() ?? 0;
            return page == 0
                ? carregarJornadasNaoAuditadas()
                : carregarJornadasAuditadas();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildBemVindo(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildPage(saldoEmAberto: true),
                      _buildPage(saldoEmAberto: false),
                    ],
                  ),
                ),
                _buildRecentTransactions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage({required bool saldoEmAberto}) {
    return SizedBox(
      width: 350,
      child: Column(
        children: [
          _buildSaldoPremiacao(saldoEmAberto: saldoEmAberto),
          const SizedBox(height: 8),
          _buildQuickActions(saldoEmAberto: !saldoEmAberto),
        ],
      ),
    );
  }

  Widget _buildBemVindo() => _buildCard(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWelcomeText(),
            IconButton(
              onPressed: () => MudarDePagina.logoff(context, MobileLogin()),
              icon: const Icon(Icons.exit_to_app_outlined,
                  color: Colors.deepPurple, size: 30),
            ),
          ],
        ),
      );

  Widget _buildWelcomeText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text("Bem-vindo!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          Text(
            widget.motorista.displayName ?? 'Motorista',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      );

  Widget _buildSaldoPremiacao({required bool saldoEmAberto}) => _buildCard(
        padding: const EdgeInsets.all(20),
        color: saldoEmAberto ? Colors.black38 : Colors.deepPurple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            Text(
              Formatador.dinheiro.format(valorPremio),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              saldoEmAberto ? "Saldo em Aberto" : "Saldo Auditado",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 25),
          ],
        ),
      );

  Widget _buildQuickActions({required bool saldoEmAberto}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionItem(Icons.fire_truck_outlined, "Produtividade",
                Formatador.dinheiro.format(produtividade)),
            _buildActionItem(
                Icons.schedule, "Jornada", Formatador.dinheiro.format(jornada)),
            _buildActionItem(Icons.speed, "Segurança",
                Formatador.dinheiro.format(seguranca)),
            saldoEmAberto
                ? _buildActionItem(Icons.local_gas_station_outlined,
                    "Combustível", Formatador.dinheiro.format(seguranca))
                : const SizedBox(),
          ],
        ),
      );

  Widget _buildActionItem(IconData icon, String label, String valor) => Column(
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple[50],
            child: Icon(icon, color: Colors.deepPurple, size: 28),
          ),
          const SizedBox(height: 8),
          Text(valor,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      );

  Widget _buildRecentTransactions() {
    if (isLoading) {
      return const SizedBox(
          height: 300, child: Center(child: CircularProgressIndicator()));
    }
    if (listaJornadas.isEmpty) {
      return const SizedBox(
          height: 300,
          child: Center(
              child: Text("Nenhuma jornada encontrada.",
                  style: TextStyle(fontSize: 16))));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listaJornadas.length,
      itemBuilder: (context, index) =>
          _buildJornadaItem(listaJornadas[index], index),
    );
  }

  Widget _buildJornadaItem(Jornada jornada, int index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.fire_truck, color: Colors.deepPurple),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jornada.jornadaLocalidade ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(jornada.placa ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          subtitle: Text(Formatador.dataBrasileira(jornada.jornadaData!)),
          trailing: Text(
            "${jornada.km ?? 0} km",
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget _buildCard(
          {required Widget child, Color? color, EdgeInsets? padding}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: double.infinity,
          padding: padding,
          child: child,
        ),
      );

  DateTime _hojeMenosUm(DateTime hoje) => hoje.day > 20
      ? DateTime(hoje.year, hoje.month, 20)
      : DateTime(hoje.year, hoje.month - 1, 20);

  DateTime _hojeMenosDois(DateTime hoje) =>
      hoje.day == 20 ? DateTime(hoje.year, hoje.month - 1, 20) : hoje;
}
