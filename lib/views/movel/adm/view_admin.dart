import 'package:alex/models/motorista.dart';
import 'package:alex/repository/api_jornada.dart';
import 'package:flutter/material.dart';

import '../../../controlls/premiacao.dart';
import '../../../helps/formatadores.dart';
import '../../../helps/mudarDePagina.dart';
import '../../../models/jornada.dart';
import '../../../repository/api_motorista.dart';
import '../login.dart';
import 'cadastrar_jornada.dart';
import 'cadastrar_motorista.dart';

class ViewAdmin extends StatefulWidget {
  final Motorista motorista;

  const ViewAdmin({Key? key, required this.motorista}) : super(key: key);

  @override
  State<ViewAdmin> createState() => _ViewAdminState();
}

class _ViewAdminState extends State<ViewAdmin> {
  List<Jornada> listaJornadas = [];
  List<Motorista> _condutores = [];
  Motorista? _selectedCondutor;
  double valoKm = 0.0;
  var hoje = DateTime.now();
  double valorPremio = 0.0;
  late DateTime ultimaApuracao;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarCondutores();
  }

  Future<void> _carregarCondutores() async {
    final condutores = await ApiCondutor.buscarTodosMotoristas();
    setState(() {
      _condutores = condutores
        ..sort((a, b) => a.displayName!.compareTo(b.displayName!));
    });
  }

  Future<void> carregarJornadas() async {
    try {
      final motoristaID = widget.motorista.Id!;
      final jornadas = await ApiJornada.buscarJornadasPorMotoristaId(
          dataInicial: ultimaApuracao,
          dataFinal: hoje,
          motoristaID: motoristaID);
      double novoValorKm =
          jornadas.fold(0.0, (soma, x) => soma + (x.km ?? 0.0));

      setState(() {
        listaJornadas = jornadas;
        valoKm = novoValorKm;
        ultimaApuracao =
            DateTime(DateTime.now().year, DateTime.now().month - 1, 20);
        isLoading = false;
        valorPremio = Premiacao.valorTotalPremio(valoKm);
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Painel Administrativo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildDropdownCondutores(),
            const SizedBox(height: 20),
            Expanded(child: _buildJornadaList()),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoCard(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            accountName: Text(widget.motorista.displayName ?? ''),
            accountEmail: Text(widget.motorista.login ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
          ),
          _buildDrawerItem('Cadastrar Motorista', const CadastrarMotorista()),
          _buildDrawerItem('Cadastrar Jornada', const CadastrarJornada()),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () => MudarDePagina.logoff(context, Login()),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, Widget page) {
    return ListTile(
      leading: const Icon(Icons.arrow_right),
      title: Text(title),
      onTap: () => MudarDePagina.trocarTela(context, page),
    );
  }

  Widget _buildDropdownCondutores() {
    return DropdownButtonFormField<Motorista>(
      decoration: _inputDecoration('Selecione o Condutor'),
      value: _selectedCondutor,
      items: _condutores
          .map((condutor) => DropdownMenuItem(
              value: condutor, child: Text(condutor.displayName!)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            isLoading = true;
            _selectedCondutor = value;
          });
          _carregarJornadas(value.Id!);
        }
      },
      validator: (value) => value == null ? 'Selecione um condutor' : null,
    );
  }

  Future<void> _carregarJornadas(String motoristaID) async {
    final jornadas =
        await ApiJornada.buscarTodasJornadasPeloCondutor(motoristaID);
    setState(() {
      listaJornadas = jornadas;
      isLoading = false;
    });
  }

  Widget _buildJornadaList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (listaJornadas.isEmpty) {
      return const Center(
          child: Text("Nenhuma jornada encontrada.",
              style: TextStyle(fontSize: 16)));
    }

    return ListView.builder(
      itemCount: listaJornadas.length,
      itemBuilder: (context, index) {
        return _buildJornadaCard(index, listaJornadas[index]);
      },
    );
  }

  Widget _buildJornadaCard(int index, Jornada jornada) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ListTile(
          leading: const Icon(Icons.local_shipping, color: Colors.deepPurple),
          title: Text('Jornada ${index + 1}'),
          subtitle: Text(
              Formatador.dataBrasileira(jornada.jornadaData ?? DateTime.now())),
          trailing: Text('${jornada.km} km',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: suffixIcon,
    );
  }
}
