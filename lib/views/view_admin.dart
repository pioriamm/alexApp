import 'package:alex/models/motorista.dart';
import 'package:alex/views/cadastrar_jornada.dart';
import 'package:flutter/material.dart';

import '../config/mudarDePagina.dart';
import 'cadastrar_condutor.dart';

class ViewAdmin extends StatefulWidget {
  late Motorista motorista;

  ViewAdmin({required Motorista this.motorista});

  @override
  State<ViewAdmin> createState() => _ViewAdminState();
}

class _ViewAdminState extends State<ViewAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.motorista.displayName}"),
      ),
      drawer: Drawer(
        elevation: 10,
        child: ListView(
          children: [
            ListTile(
              title: InkWell(child: const Text("Condutor"), onTap: () => mudarDePagina.trocarTela(context, const CadastrarCondutor()),),
            ),
            ListTile(
              title: InkWell(child: const Text("Jornada"), onTap: () => mudarDePagina.trocarTela(context, const CadastrarJornada()),),
            ),
          ],
        ),
      ),
    );
  }
}
