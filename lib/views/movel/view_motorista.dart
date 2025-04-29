import 'package:alex/helps/formatadores.dart';
import 'package:alex/models/jornada.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/views/movel/login.dart';
import 'package:flutter/material.dart';

import '../../config/mudarDePagina.dart';
import '../../controlls/premiacao.dart';
import '../../repository/api_auditor.dart';
import '../../repository/api_jornada.dart';

class ViewMotorista extends StatefulWidget {
  final Motorista motorista;
  const ViewMotorista({Key? key, required this.motorista}) : super(key: key);

  @override
  State<ViewMotorista> createState() => _ViewMotoristaState();
}

class _ViewMotoristaState extends State<ViewMotorista> {
  List<Jornada> listaJornadas = [];
  bool isLoading = false;
  double valorPremio = 0.0;
  double valorKm = 0.0;
  double jornada = 0.0;
  double seguranca = 0.0;
  double produtividade = 0.0;
  late DateTime ultimaApuracao;
  final hoje = DateTime.now();

  @override
  void initState() {
    super.initState();
    ultimaApuracao = _hojeMaiorVinte(hoje);
    carregarJornadas();
  }

  Future<void> carregarJornadas() async {
    setState(() => isLoading = true);
    try {
      final jornadas =
          await ApiJornada.buscarJornadasPorMotoristaIdNaoAuditadas(
        dataInicial: ultimaApuracao,
        dataFinal: hoje,
        motoristaID: widget.motorista.motoristaID!,
      );
      final novoValorKm = await ApiAuditor.auditoriaKm(
        ultimaApuracao,
        widget.motorista.motoristaID!,
      );

      setState(() {
        listaJornadas = jornadas;
        valorKm = novoValorKm;
        valorPremio = Premiacao.valorTotalPremio(valorKm);
        jornada = Premiacao.faixaJornada(valorKm).$2;
        seguranca = Premiacao.faixaSeguranca(valorKm).$2;
        produtividade = Premiacao.faixaProdutividade(valorKm).$2;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: carregarJornadas,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildBemVindo(),
                _buildSaldoPremiacao(),
                _buildQuickActions(),
                _buildRecentTransactions(),
              ],
            ),
          ),
        ),
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
              onPressed: () => MudarDePagina.logoff(context, Login()),
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

  Widget _buildSaldoPremiacao() => _buildCard(
        padding: const EdgeInsets.all(20),
        color: Colors.deepPurple,
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
            const Text("Saldo Atual",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 25),
          ],
        ),
      );

  Widget _buildQuickActions() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionItem(Icons.fire_truck_rounded, "Jornada",
                '${Formatador.dinheiro.format(jornada)}'),
            _buildActionItem(Icons.security, "Segurança",
                '${Formatador.dinheiro.format(seguranca)}'),
            _buildActionItem(Icons.flash_on, "Produtividade",
                '${Formatador.dinheiro.format(produtividade)}'),
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
          title: Text("Jornada ${index + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
      Container(
        width: double.infinity,
        padding: padding,
        color: color,
        child: child,
      );

  DateTime _hojeMaiorVinte(DateTime hoje) => hoje.day > 20
      ? DateTime(hoje.year, hoje.month, 20)
      : DateTime(hoje.year, hoje.month - 1, 20);
}
