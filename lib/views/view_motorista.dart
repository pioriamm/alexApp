import 'package:alex/config/mudarDePagina.dart';
import 'package:alex/controlls/premiacao.dart';
import 'package:alex/helps/formatadores.dart';
import 'package:alex/models/jornada.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/repository/api.dart';
import 'package:alex/views/login.dart';
import 'package:flutter/material.dart';

class ViewMotorista extends StatefulWidget {
  final Motorista motorista;
  const ViewMotorista({Key? key, required this.motorista}) : super(key: key);

  @override
  State<ViewMotorista> createState() => _ViewMotoristaState();
}

class _ViewMotoristaState extends State<ViewMotorista> {
  List<Jornada> listaJornadas = [];
  double valoKm = 0.0;
  late DateTime ultimaApuracao;
  bool isLoading = true;
  double valorPremio = 0.0;

  @override
  void initState() {
    super.initState();
    carregarJornadas();
  }

  Future<void> carregarJornadas() async {
    try {
      final jornadas = await Api.getJornadasPorMotoristaIdPendentes(
          motoristaID: widget.motorista.motoristaID!);
      final double novoValorKm = await Api.auditoriaKm(DateTime(2025, 2, 1),
          DateTime(2025, 2, 10), widget.motorista.motoristaID.toString());
      setState(() {
        listaJornadas = jornadas;
        valoKm = novoValorKm;
        var hoje = DateTime.now();
        ultimaApuracao = DateTime(hoje.year, hoje.month - 1, 20);
        isLoading = false;
        valorPremio = Premiacao.valorTotalPremio(valoKm);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           Text("${widget.motorista.isAdim}"),
          _buildHeader(),
          _buildKmInfo(),
          _buildJornadaList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.black12,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Text(
                _getInitials(widget.motorista.displayName),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.motorista.displayName ?? 'Sem nome',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Text(
              widget.motorista.telefone?.isNotEmpty == true
                  ? formatarTelefone(widget.motorista.telefone!)
                  : 'Telefone não informado',
              style: const TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: () => mudarDePagina.logoff(context, Login()),
              child: const Text("Sair",
                  style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKmInfo() {
    return SizedBox(
      height: 230,
      child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Última Apuração: ${Formatador.dataBrasileira(ultimaApuracao)}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text('Km: $valoKm',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      ExpansionTile(
                        showTrailingIcon: false,
                        title: Text(
                          'Valor do prêmio: ${Formatador.dinheiro.format(valorPremio)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Jornada: ${Formatador.dinheiro.format(Premiacao.faixaJornada(valoKm).$2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Segurança: ${Formatador.dinheiro.format(Premiacao.faixaSeguranca(valoKm).$2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Produtividade: ${Formatador.dinheiro.format(Premiacao.faixaProdutividade(valoKm).$2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
    );
  }

  Widget _buildJornadaList() {
    if (isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (listaJornadas.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("Nenhuma jornada encontrada.",
              style: TextStyle(fontSize: 16)),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: listaJornadas.length,
        itemBuilder: (context, index) {
          var jornada = listaJornadas[index];
          return _buildJornadaCard(index, jornada);
        },
      ),
    );
  }

  Widget _buildJornadaCard(int index, Jornada jornada) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Jornada #${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                          '${Formatador.dataBrasileira(jornada.jornadaData!)}' ??
                              'Data não informada',
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(jornada.jornadaHora ?? 'Hora não informada',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text("${jornada.km} km",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  String formatarTelefone(String numero) {
    final limpa = numero.replaceAll(RegExp(r'\D'), '');

    if (limpa.length == 14) {
      //55031985440060
      var pais = limpa.substring(0, 2);
      var ddd = limpa.substring(2, 5);
      var numero = limpa.substring(5, 10);
      var numerofinal = limpa.substring(10);
      return "+$pais $ddd $numero-$numerofinal";
    } else {
      return numero;
    }
  }
}
