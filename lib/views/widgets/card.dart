import 'package:flutter/material.dart';

class PaineldaLista extends StatelessWidget {
  final String tituloPainel;
  final Widget formularioDoCard;
  final VoidCallback chamada;
  final atualizaPainel;
  final int tamanhoLista;

  const PaineldaLista(
      {required this.tituloPainel,
      required this.formularioDoCard,
      required this.chamada,
      required this.tamanhoLista,
      required this.atualizaPainel,
      required});

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
                  Text(tituloPainel,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Quantidade:  $tamanhoLista',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  atualizaPainel
                      ? IconButton(
                          onPressed: chamada,
                          icon: const Icon(Icons.refresh_outlined),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(flex: tamanhoLista, child: formularioDoCard),
            ],
          ),
        ),
      ),
    );
  }
}
