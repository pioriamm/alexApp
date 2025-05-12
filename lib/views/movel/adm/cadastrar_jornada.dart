import 'package:alex/repository/api_jornada.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../models/motorista.dart';
import '../../../repository/api_condutor.dart';

class CadastrarJornada extends StatefulWidget {
  const CadastrarJornada({super.key});

  @override
  State<CadastrarJornada> createState() => _CadastrarJornadaState();
}

class _CadastrarJornadaState extends State<CadastrarJornada> {
  final _formKey = GlobalKey<FormState>();
  Motorista? _selectedCondutor;
  List<Motorista> _condutores = [];

  final _dataController = TextEditingController();
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _horasController = TextEditingController();

  final _placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA9A99',
    filter: {'A': RegExp(r'[A-Za-z]'), '9': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _carregarCondutores();
  }

  Future<void> _carregarCondutores() async {
    final condutores = await ApiCondutor.buscarTodosCondutores();
    setState(() {
      _condutores = condutores
        ..sort((a, b) => a.displayName!.compareTo(b.displayName!));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      _dataController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _horasController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  void _salvarJornada() {
    if (_formKey.currentState!.validate()) {
      final jornadaData = {
        "jornadaData": _dataController.text,
        "jornadaHora": "1990-01-01T${_horasController.text}:00.000Z",
        "motoristaID": _selectedCondutor?.motoristaID,
        "placa": _placaController.text.toUpperCase(),
        "km": double.tryParse(_kmController.text),
      };

      ApiJornada.cadastrarNovaJornada(jornadaData).then((sucesso) {
        if (sucesso) {
          _limparCampos();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sucesso
                ? "Jornada cadastrada com sucesso!"
                : "Falha ao cadastrar jornada."),
            backgroundColor: sucesso ? Colors.green : Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  void _limparCampos() {
    _dataController.clear();
    _horasController.clear();
    _kmController.clear();
    _placaController.clear();
    setState(() {
      _selectedCondutor = null;
    });
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Jornada',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preencha os dados da jornada',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdownCondutor(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: _buildDateField()),
                  const SizedBox(width: 12),
                  Flexible(child: _buildTimeField()),
                ],
              ),
              const SizedBox(height: 12),
              _buildPlacaField(),
              const SizedBox(height: 12),
              _buildKmField(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _salvarJornada,
        label: const Text(
          'Salvar Jornada',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildDropdownCondutor() {
    return DropdownButtonFormField<Motorista>(
      decoration: _inputDecoration('Condutor'),
      value: _selectedCondutor,
      items: _condutores.map((condutor) {
        return DropdownMenuItem(
          value: condutor,
          child: Text(condutor.displayName!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCondutor = value;
        });
      },
      validator: (value) => value == null ? 'Selecione um condutor' : null,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dataController,
      readOnly: true,
      decoration: _inputDecoration(
        'Data da Jornada',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
      validator: (value) => value!.isEmpty ? 'Informe a data' : null,
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _horasController,
      readOnly: true,
      decoration: _inputDecoration(
        'Horas de Jornada',
        suffixIcon: IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () => _selectTime(context),
        ),
      ),
      onTap: () => _selectTime(context),
      validator: (value) => value!.isEmpty ? 'Informe a hora' : null,
    );
  }

  Widget _buildPlacaField() {
    return TextFormField(
      controller: _placaController,
      decoration: _inputDecoration('BRA2E19'),
      inputFormatters: [_placaMaskFormatter],
      validator: (value) => value!.isEmpty ? 'Placa do Veículo' : null,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildKmField() {
    return TextFormField(
      controller: _kmController,
      decoration: _inputDecoration('1.0 (KM)'),
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? 'Informe a quilometragem' : null,
    );
  }
}
