import 'package:alex/repository/api_jornada.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../helps/mudarDePagina.dart';
import '../../models/jornada.dart';

class EditarJornada extends StatefulWidget {
  final Jornada jornada;

  EditarJornada({
    super.key,
    required this.jornada,
  });

  @override
  State<EditarJornada> createState() => _EditarJornadaState();
}

class _EditarJornadaState extends State<EditarJornada> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _motoristaController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _localidadeController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final _placaMaskFormatter = MaskTextInputFormatter(
    mask: 'AAA9A99',
    filter: {'A': RegExp(r'[A-Za-z]'), '9': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _placaController.text = widget.jornada.placa ?? '';
    _dataController.text =
        DateFormat('dd/MM/yyyy').format(widget.jornada.jornadaData!) ?? '';
    _localidadeController.text = widget.jornada.jornadaLocalidade ?? '';
    _kmController.text = widget.jornada.km?.toString() ?? '';
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _editarJornada() async {
    if (_formKey.currentState!.validate()) {
      final jornadaData = DateFormat('dd/MM/yyyy').parse(_dataController.text);
      final jornadaLocalidade = _localidadeController.text.trim();
      final km = double.tryParse(_kmController.text.trim());
      final placa = _placaController.text;
      final motoristaID = widget.jornada.motoristaID;
      final id = widget.jornada.id;

      if (jornadaData == null || km == null) {
        _showSnackBar('Erro na conversão de valores.', isError: true);
        return;
      }

      Jornada jornada = Jornada(
        id: id,
        jornadaData: jornadaData,
        jornadaLocalidade: jornadaLocalidade,
        motoristaID: motoristaID,
        placa: placa,
        km: km,
      );

      var sucesso = await ApiJornada.editarJornada(jornada);

      if (sucesso) {
        _showSnackBar('Jornada $jornadaLocalidade Editada com sucesso!');
        _clearFields();
      } else {
        _showSnackBar('Erro ao Editar jornada.', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    MudarDePagina.sairTela(context);
  }

  void _clearFields() {
    _motoristaController.clear();
    _placaController.clear();
    _kmController.clear();
    _localidadeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _placaController,
                decoration: _inputDecoration('BRA2E19'),
                inputFormatters: [_placaMaskFormatter],
                validator: (value) =>
                    value!.isEmpty ? 'Placa do Veículo' : null,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dataController,
                decoration: _buildInputDecoration('Data'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Informe a Data' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _localidadeController,
                decoration: _buildInputDecoration('Localidade'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Informe a Localidade'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _kmController,
                decoration: _buildInputDecoration('Km'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Informe o KM' : null,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btnEditarJornada',
        onPressed: _editarJornada,
        label: const Text(
          'Editar Jornada',
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
}
