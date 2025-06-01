import 'package:alex/models/motorista.dart';
import 'package:flutter/material.dart';

import '../../models/jornada.dart';
import '../../repository/api_jornada.dart';
import '../../repository/api_motorista.dart';
import '../movel/adm/cabecalho.dart';
import '../movel/adm/cadastrar_jornada.dart';
import '../movel/adm/cadastrar_motorista.dart';
import '../movel/adm/card.dart';
import '../movel/adm/card_jornada.dart';
import '../movel/adm/card_motorista.dart';
import '../movel/adm/menu_lateral.dart';

class AdminDashboardPage extends StatefulWidget {
  final Motorista motorista;

  const AdminDashboardPage({super.key, required this.motorista});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Motorista> listaMotorista = [];
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

  bool atualizarMotoristas() {
    ApiCondutor.buscarTodosMotoristas().then((value) {
      setState(() {
        listaMotorista = value;
      });
    });
    return true;
  }

  @override
  void initState() {
    super.initState();

    AtualizarJornadas();
    atualizarMotoristas();
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
            child: SidebarMenu(motorista: widget.motorista),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        PaineldaLista(
                            chamada: () {},
                            tituloPainel: 'Cadastrar Motorista',
                            atualizaPainel: false,
                            formularioDoCard: const CadastrarMotorista()),
                        PaineldaLista(
                            chamada: () {},
                            atualizaPainel: false,
                            tituloPainel: 'Cadastrar Jornada',
                            formularioDoCard: const CadastrarJornada()),
                        PaineldaLista(
                          tituloPainel: 'Lista de Motorista',
                          chamada: atualizarMotoristas,
                          atualizaPainel: true,
                          formularioDoCard: CardUListaMotorista(
                            listaMotoristas: listaMotorista,
                            scrollController: _condutoresController,
                          ),
                        ),
                        PaineldaLista(
                          chamada: AtualizarJornadas,
                          atualizaPainel: true,
                          tituloPainel: 'Lista de Jornadas',
                          formularioDoCard: CardUListaJornada(
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
