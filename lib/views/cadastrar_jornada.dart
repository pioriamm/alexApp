import 'package:alex/models/jornada.dart';
import 'package:alex/models/motoristaDto.dart';
import 'package:alex/repository/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarJornada extends StatefulWidget {
  const CadastrarJornada({super.key});

  @override
  State<CadastrarJornada> createState() => _CadastrarJornadaState();
}

class _CadastrarJornadaState extends State<CadastrarJornada> {
  final _formKey = GlobalKey<FormState>();
  MotoristaDTO? _selectedCondutor;
  List<MotoristaDTO> _condutores = [];

  final _dataController = TextEditingController();
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _horasController = TextEditingController();

  final _placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA9A99',
    filter: {'A': RegExp(r'[A-Za-z]'), '9': RegExp(r'[0-9]')},
  );

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() => _dataController.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _horasController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
    }
  }

  void _salvarJornada() {
    if (_formKey.currentState!.validate()) {
      final jornadaData = {
        "jornadaData": _dataController.text,
        "jornadaHora": "1990-01-01T${_horasController.text}:22.136Z",
        "motoristaID": _selectedCondutor?.motoristaID,
        "placa": _placaController.text.toUpperCase(),
        "km": double.tryParse(_kmController.text),
      };

      Api.cadastrarNovaJornada(jornadaData).then((sucesso) {
        if (sucesso) {
          _dataController.clear();
          _horasController.clear();
          _kmController.clear();
          _placaController.clear();
          _selectedCondutor = null;
          setState(() {});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sucesso ? "Jornada cadastrada com sucesso!" : "Falha ao cadastrar jornada."),
            backgroundColor: sucesso ? Colors.green : Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Api.buscarTodosCondutores().then((valor) {
      setState(() {
        _condutores = valor..sort((a, b) => a.displayName.compareTo(b.displayName));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Jornada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<MotoristaDTO>(
                decoration: _inputDecoration('Condutor'),
                value: _selectedCondutor,
                items: _condutores.map((condutor) => DropdownMenuItem(value: condutor, child: Text(condutor.displayName))).toList(),
                onChanged: (value) => setState(() => _selectedCondutor = value),
                validator: (value) => value == null ? 'Selecione um condutor' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dataController,
                decoration: _inputDecoration(
                  'Data da Jornada',
                  suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _selectDate(context)),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => value!.isEmpty ? 'Informe a data' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _horasController,
                decoration: _inputDecoration(
                  'Horas de Jornada',
                  suffixIcon: IconButton(icon: const Icon(Icons.access_time), onPressed: () => _selectTime(context)),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) => value!.isEmpty ? 'Informe a hora da jornada' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _placaController,
                decoration: _inputDecoration('Placa'),
                validator: (value) => value!.isEmpty ? 'Informe a placa' : null,
                inputFormatters: [_placaMaskFormatter],
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kmController,
                decoration: _inputDecoration('KM'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe a quilometragem' : null,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarJornada,
        child: const Icon(Icons.save),
      ),
    );
  }
}
