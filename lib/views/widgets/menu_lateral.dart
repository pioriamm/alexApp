import 'package:alex/helps/formatadores.dart';
import 'package:flutter/material.dart';

import '../../helps/mudarDePagina.dart';
import '../../models/motorista.dart';
import '../plataformas/web/web_login.dart';
import '../telas/cadastrar_jornada.dart';
import '../telas/cadastrar_motorista.dart';
import '../telas/casdastrar_checklist.dart';
import 'menu_opcoes.dart';

class SidebarMenu extends StatefulWidget {
  final Motorista motorista;

  const SidebarMenu({super.key, required this.motorista});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  @override
  Widget build(BuildContext context) {
    var m = widget.motorista;
    return Container(
      width: 260,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),
          // Avatar
          CircleAvatar(
            radius: 48,
            child: Text(
              Formatador.gerarIniciais(widget.motorista.displayName ?? ''),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Nome e telefone
          Text(
            widget.motorista.displayName ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            widget.motorista.telefone != null
                ? Formatador.formatarTelefone(widget.motorista.telefone!)
                : '-',
          ),

          const SizedBox(height: 24),

          if (widget.motorista.perfilAcesso! == 1) ...[
            const MenuOpcoes(
                titulo: 'Cadastrar Motorista', page: CadastrarMotorista()),
            const MenuOpcoes(
                titulo: 'Cadastrar Jornada', page: CadastrarJornada()),
            MenuOpcoes(
                titulo: 'Cadastrar Checklist',
                page: ChecklistPage(
                  motorista: widget.motorista,
                )),
          ] else ...[
            MenuOpcoes(
                titulo: 'Cadastrar Checklist',
                page: ChecklistPage(
                  motorista: widget.motorista,
                )),
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
