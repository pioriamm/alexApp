import 'package:flutter/material.dart';

import '../../helps/mudarDePagina.dart';

class MenuOpcoes extends StatelessWidget {
  final String titulo;
  final Widget page;

  const MenuOpcoes({
    super.key,
    required this.titulo,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const Icon(Icons.arrow_right),
      title: Text(titulo),
      onTap: () => MudarDePagina.trocarTela(context, page),
    );
  }
}
