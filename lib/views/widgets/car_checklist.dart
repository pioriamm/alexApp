import 'package:alex/models/checklist.dart';
import 'package:flutter/material.dart';

class CardUListaChecklist extends StatelessWidget {
  final List<Checklist> listaChecklist;
  final ScrollController scrollController;

  const CardUListaChecklist(
      {required this.listaChecklist, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (listaChecklist.isEmpty) {
      return const Center(child: Text('Nenhuma checklist encontrado'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: listaChecklist.length,
      itemBuilder: (context, index) {
        final ChecklistSelecionado = listaChecklist[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            trailing: IconButton(
                onPressed: () => showPopup(
                      context: context,
                      formulario: null,
                    ),
                icon: const Icon(Icons.edit)),
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
