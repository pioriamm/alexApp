import 'package:alex/config/mudarDePagina.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/views/web/web_login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/jornada.dart';
import '../../repository/api_condutor.dart';
import '../../repository/api_jornada.dart';
import '../movel/adm/cadastrar_condutor.dart';
import '../movel/adm/cadastrar_jornada.dart';
import '../movel/adm/editar_condutor.dart';

class AdminDashboardPage extends StatefulWidget {
  final Motorista motorista;
  const AdminDashboardPage({super.key, required this.motorista});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Motorista> listaCondutores = [];
  List<Jornada> listaJornadas = [];

  final ScrollController _condutoresController = ScrollController();
  final ScrollController _jornadasController = ScrollController();

  bool AtualizarJornadas() {
    ApiJornada.buscarTodasJornadas().then((value) {
      setState(() {
        listaJornadas = value;
      });
    });
    return true;
  }

  bool atualizarCondutores() {
    ApiCondutor.buscarTodosCondutores().then((value) {
      setState(() {
        listaCondutores = value;
      });
    });
    return true;
  }

  @override
  void initState() {
    super.initState();

    AtualizarJornadas();
    atualizarCondutores();
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
                        _Card(
                            chamada: () {},
                            title: 'Cadastrar Condutor',
                            show: false,
                            child: const CadastrarCondutor()),
                        _Card(
                            chamada: () {},
                            show: false,
                            title: 'Cadastrar Jornada',
                            child: const CadastrarJornada()),
                        _Card(
                          title: 'Lista de Condutores',
                          chamada: atualizarCondutores,
                          show: true,
                          child: _CardUListaUsuarios(
                            listaCondutores: listaCondutores,
                            scrollController: _condutoresController,
                          ),
                        ),
                        _Card(
                          chamada: AtualizarJornadas,
                          show: true,
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
        CircleAvatar(
          radius: 48,
          child: Text(
            getIniciais(motorista.displayName ?? ''),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Text(motorista.displayName ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(motorista.telefone != null
            ? formatarTelefone(motorista.telefone!)
            : '-'),
        motorista.isAdim!
            ? const Icon(
                Icons.safety_check_rounded,
                color: Colors.green,
              )
            : const Icon(
                Icons.safety_check_rounded,
                color: Colors.yellow,
              ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            'Sair',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => MudarDePagina.logoff(context, const WebLogin()),
        ),
      ],
    );
  }

  String getIniciais(String nome) {
    final partes = nome.trim().split(' ');

    if (partes.isEmpty) return '';
    final primeira = partes[0].isNotEmpty ? partes[0][0] : '';
    final segunda =
        partes.length > 1 && partes[1].isNotEmpty ? partes[1][0] : '';
    return (primeira + segunda).toUpperCase();
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
  final VoidCallback chamada;
  final show;

  const _Card(
      {required this.title,
      required this.child,
      required this.chamada,
      required this.show});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  show
                      ? IconButton(
                          onPressed: chamada,
                          icon: const Icon(Icons.refresh_outlined),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardUListaUsuarios extends StatelessWidget {
  final List<Motorista> listaCondutores;
  final ScrollController scrollController;

  const _CardUListaUsuarios(
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
        final motorista = listaCondutores[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            trailing: IconButton(
                onPressed: () => _editarDados(
                      context,
                      motorista,
                      EditarCondutor(
                        motorista: motorista,
                      ),
                    ),
                icon: const Icon(Icons.edit)),
            title: Text(motorista.displayName ?? 'Sem nome',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(motorista.login?.toLowerCase() ?? ''),
          ),
        );
      },
    );
  }

  _editarDados(BuildContext context, motorista, Widget child) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar dados'),
          content: SizedBox(width: 350, height: 400, child: child),
        );
      },
    );
  }
}

String formatarTelefone(String telefone) {
  if (telefone.isEmpty) return '-';
  final numeros = telefone.replaceAll(RegExp(r'\D'), '');

  if (numeros.length >= 13) {
    return '+${numeros.substring(0, 2)} '
        '${numeros.substring(2, 5)} '
        '${numeros.substring(5, 6)} '
        '${numeros.substring(6, 10)}-${numeros.substring(10, 14)}';
  }

  return telefone;
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
                Text(j.placa ?? ''),
                Text('${j.km ?? '0'} km'),
                Text(
                  '${j.jornadaData != null ? DateFormat('dd/MM/yyyy').format(j.jornadaData!) : ''} ${j.jornadaHora.toString()}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
