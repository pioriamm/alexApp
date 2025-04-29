import 'package:alex/config/mudarDePagina.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/views/web/web_login.dart';
import 'package:flutter/material.dart';

import '../../models/jornada.dart';
import '../../models/motoristaDto.dart';
import '../../repository/api_condutor.dart';
import '../../repository/api_jornada.dart';
import '../movel/adm/cadastrar_condutor.dart';
import '../movel/adm/cadastrar_jornada.dart';

class AdminDashboardPage extends StatefulWidget {
  final Motorista motorista;
  const AdminDashboardPage({super.key, required this.motorista});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<MotoristaDTO> listaCondutores = [];
  List<Jornada> listaJornadas = [];

  final ScrollController _condutoresController = ScrollController();
  final ScrollController _jornadasController = ScrollController();

  @override
  void initState() {
    super.initState();

    ApiCondutor.buscarTodosCondutores().then((value) {
      setState(() {
        listaCondutores = value;
      });
    });

    ApiJornada.buscarTodasJornadas().then((value) {
      setState(() {
        listaJornadas = value;
      });
    });
  }

  @override
  void dispose() {
    _condutoresController.dispose();
    _jornadasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          Container(
            width: 260,
            color: Colors.white,
            child: _SidebarMenu(motorista: widget.motorista),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        const _Card(
                            title: 'Cadastrar Condutor',
                            child: CadastrarCondutor()),
                        const _Card(
                            title: 'Cadastrar Jornada',
                            child: CadastrarJornada()),
                        _Card(
                          title: 'Lista de Condutores',
                          child: _CardUsuarios(
                            listaCondutores: listaCondutores,
                            scrollController: _condutoresController,
                          ),
                        ),
                        _Card(
                          title: 'Lista de Jornadas',
                          child: _CardJornada(
                            listaJornada: listaJornadas,
                            scrollController: _jornadasController,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SidebarMenu extends StatelessWidget {
  final Motorista motorista;
  const _SidebarMenu({required this.motorista});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(radius: 48),
        const SizedBox(height: 16),
        Text(motorista.displayName ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(motorista.telefone ?? '-'),
        Text(motorista.isAdim?.toString() ?? 'false'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Sair'),
          onPressed: () => MudarDePagina.logoff(context, const WebLogin()),
        ),
      ],
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: const Text(
        'Painel de Administração',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardUsuarios extends StatelessWidget {
  final List<MotoristaDTO> listaCondutores;
  final ScrollController scrollController;

  const _CardUsuarios(
      {required this.listaCondutores, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (listaCondutores.isEmpty) {
      return const Center(child: Text('Nenhum condutor encontrado'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: listaCondutores.length,
      itemBuilder: (context, index) {
        final m = listaCondutores[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            title: Text(m.displayName ?? 'Sem nome',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(m.motoristaID ?? ''),
          ),
        );
      },
    );
  }
}

class _CardJornada extends StatelessWidget {
  final List<Jornada> listaJornada;
  final ScrollController scrollController;

  const _CardJornada(
      {required this.listaJornada, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (listaJornada.isEmpty) {
      return const Center(child: Text('Nenhuma jornada encontrada'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: listaJornada.length,
      itemBuilder: (context, index) {
        final j = listaJornada[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(j.quilometragemId ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(j.displayName ?? ''),
                Text(j.telefone ?? ''),
                Text(j.placa ?? ''),
                Text('${j.km ?? '0'} km'),
                Text(j.jornadaData?.toString() ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
