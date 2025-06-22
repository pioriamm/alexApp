import 'package:alex/helps/formatadores.dart';
import 'package:flutter/material.dart';

import '../../helps/mudarDePagina.dart';
import '../../models/motorista.dart';
import '../plataformas/web/web_login.dart';
import '../telas/cadastrar_jornada.dart';
import '../telas/cadastrar_motorista.dart';
import '../telas/casdastrar_checklist.dart';
import 'menu_opcoes.dart';

class SidebarMenu extends StatelessWidget {
  final Motorista motorista;

  const SidebarMenu({super.key, required this.motorista});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // define uma largura fixa para o menu lateral
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),
          // Avatar
          CircleAvatar(
            radius: 48,
            child: Text(
              Formatador.gerarIniciais(motorista.displayName ?? ''),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Nome e telefone
          Text(
            motorista.displayName ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            motorista.telefone != null
                ? Formatador.formatarTelefone(motorista.telefone!)
                : '-',
          ),

          const SizedBox(height: 8),

          // Icone de Admin
          Icon(
            Icons.safety_check_rounded,
            color: motorista.isAdim! ? Colors.green : Colors.yellow,
          ),

          const SizedBox(height: 24),
          // Opções de Menu
          if (motorista.isAdim! == true &&
              !motorista.login!.contains('adm')) ...[
            const MenuOpcoes(
                titulo: 'Cadastrar Motorista', page: CadastrarMotorista()),
            const MenuOpcoes(
                titulo: 'Cadastrar Jornada', page: CadastrarJornada()),
            const MenuOpcoes(
                titulo: 'Cadastrar Checklist', page: CadastrarChecklist()),
          ] else ...[
            const MenuOpcoes(
                titulo: 'Cadastrar Checklist', page: CadastrarChecklist()),
          ],

          const SizedBox(height: 100),

          // Botão de Logout
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.red),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => MudarDePagina.logoff(context, const WebLogin()),
          ),
        ],
      ),
    );
  }
}
