import 'package:flutter/material.dart';

import '../../../models/motorista.dart';
import 'editar_motorista.dart';

class CardUListaMotorista extends StatelessWidget {
  final List<Motorista> listaMotoristas;
  final ScrollController scrollController;

  const CardUListaMotorista(
      {required this.listaMotoristas, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (listaMotoristas.isEmpty) {
      return const Center(child: Text('Nenhum condutor encontrado'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: listaMotoristas.length,
      itemBuilder: (context, index) {
        final motoristaSelecionado = listaMotoristas[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            trailing: IconButton(
                onPressed: () => showPopup(
                      formulario: EditarMotorista(
                        motorista: motoristaSelecionado,
                      ),
                      context: context,
                    ),
                icon: const Icon(Icons.edit)),
            title: Text(motoristaSelecionado.displayName ?? 'Sem nome',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(motoristaSelecionado.login?.toLowerCase() ?? ''),
          ),
        );
      },
    );
  }
}

void showPopup({required BuildContext context, required formulario}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar dados'),
        content: SizedBox(width: 350, height: 400, child: formulario),
      );
    },
  );
}
