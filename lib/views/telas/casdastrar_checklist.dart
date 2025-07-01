import 'package:alex/models/motorista.dart';
import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  final Motorista motorista;
  const ChecklistPage({super.key, required this.motorista});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController kmController = TextEditingController();

  String operacao = 'Rodoviário';

  Map<String, bool> itensChecklist = {
    'Líquido de Arrefecimento no nível': true,
    'Direção ajustada e sem folgas': true,
    'Trava das tampas sem desgastes': true,
    'Cilindro da caçamba sem vazamento': true,
    'Mangueiras em bom estado': true,
    'Lonas e enlonador em conformidade': true,
    'Freio de serviço funcionando': true,
    'Freio de estacionamento funcionando': true,
    'Cinto de segurança ok': true,
    'Retrovisores em bom estado': true,
    'Placas do veículo ok': true,
    'Faixas refletivas ok': true,
    'Parabrisa em conformidade': true,
    'Buzina funcionando': true,
    'Sirene de ré funcionando': true,
    'Luz da caçamba funcionando': true,
    'Faróis e luzes funcionando': true,
    'Limpador de para-brisa funcionando': true,
    'Luz do suspensor do eixo funcionando': true,
    'Vidros funcionando corretamente': true,
    'Cabine limpa e em boas condições': true,
    'Pneus em bom estado': true,
    'Possui estepe': true,
    'Setas dos parafusos da roda instaladas': true,
    'Paralamas e parabarro em ordem': true,
    'Cones e calços disponíveis': true,
    'Tacógrafo funcionando e dentro da validade': true,
    'EPI completo e em ordem': true,
  };

  @override
  void initState() {
    setState(() {
      nomeController.text = widget.motorista.displayName ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checklist Pré-Operacional',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Informativo
            Card(
              color: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '${widget.motorista.displayName}, bom dia!\n\n'
                  'Vamos começar mais uma jornada. Antes de iniciar, por favor, preencha com atenção o checklist, marcando todos os itens conferidos.\n\n'
                  'Que sua viagem seja tranquila, segura e cheia de bons momentos!\n\n'
                  'Boa viagem e vá com Deus!',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dados iniciais
            _buildTextField('Nome do Motorista', nomeController),
            const SizedBox(height: 10),
            _buildTextField('Placa', placaController),
            const SizedBox(height: 10),
            _buildTextField('KM', kmController,
                inputType: TextInputType.number),
            const SizedBox(height: 10),

            // Dropdown operação
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown ocupa o máximo possível do espaço
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Operação de Viagem',
                      border: OutlineInputBorder(),
                    ),
                    value: operacao,
                    items: const [
                      DropdownMenuItem(
                        value: 'Rodoviário',
                        child: Text('Rodoviário'),
                      ),
                      DropdownMenuItem(
                        value: 'Poços de Caldas',
                        child: Text('Poços de Caldas'),
                      ),
                      DropdownMenuItem(
                        value: 'Outro',
                        child: Text('Outro'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        operacao = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Botão de informação
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Informação'),
                          content: const Text(
                            'POÇOS DE CALDAS É SOMENTE PARA OPERAÇÃO ALCOA.',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Itens de Verificação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            ListView.builder(
              itemCount: itensChecklist.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                String key = itensChecklist.keys.elementAt(index);
                bool status = itensChecklist[key]!;
                return _buildChecklistCard(key, status);
              },
            ),

            const SizedBox(height: 20),

            // Botão Enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // ação de enviar
                },
                child: const Text(
                  'Enviar Checklist',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget de campo texto
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Widget de card do item do checklist
  Widget _buildChecklistCard(String titulo, bool status) {
    return Card(
      color: status ? Colors.white : Colors.red[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.build_circle,
          color: Colors.deepPurple,
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          status ? 'Conforme' : 'Não Conforme',
          style: TextStyle(
            color: status ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          status ? Icons.check_circle : Icons.cancel,
          color: status ? Colors.green : Colors.red,
        ),
        onTap: () {
          setState(() {
            itensChecklist[titulo] = !status;
          });
        },
      ),
    );
  }
}
