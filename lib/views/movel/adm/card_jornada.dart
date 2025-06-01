import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/jornada.dart';
import 'editar_jornada.dart';

class CardUListaJornada extends StatelessWidget {
  final List<Jornada> listaJornada;
  final ScrollController scrollController;

  const CardUListaJornada(
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
        final jornadaSelecionada = listaJornada[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jornadaSelecionada.id ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        "Motorista: ${jornadaSelecionada.displayName?.toLowerCase() ?? ''}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Placa: ${jornadaSelecionada.placa ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Data: ${jornadaSelecionada.jornadaData != null ? DateFormat('dd/MM/yyyy').format(jornadaSelecionada.jornadaData!) : ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Localidade: ${jornadaSelecionada.jornadaLocalidade ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Kilometragem: ${jornadaSelecionada.km ?? '0'} km',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => showPopup(
                    formulario: EditarJornada(
                      jornada: jornadaSelecionada,
                    ),
                    context: context,
                  ),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
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
