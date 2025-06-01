import 'package:alex/helps/formatadores.dart';
import 'package:flutter/material.dart';

import '../../../helps/mudarDePagina.dart';
import '../../../models/motorista.dart';
import '../../web/web_login.dart';

class SidebarMenu extends StatelessWidget {
  final Motorista motorista;

  SidebarMenu({required this.motorista});

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
            ? Formatador.formatarTelefone(motorista.telefone!)
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
