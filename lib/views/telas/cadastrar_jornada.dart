import 'package:alex/helps/constantes.dart';
import 'package:alex/repository/api_infracoes.dart';
import 'package:alex/repository/api_jornada.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../models/motorista.dart';
import '../../../repository/api_motorista.dart';

class CadastrarJornada extends StatefulWidget {
  const CadastrarJornada({super.key});

  @override
  State<CadastrarJornada> createState() => _CadastrarJornadaState();
}

class _CadastrarJornadaState extends State<CadastrarJornada> {
  final _formKey = GlobalKey<FormState>();
  Motorista? _selectedCondutor;
  List<Motorista> _condutores = [];

  final _dataJornadaController = TextEditingController();
  final _dataEntradaController = TextEditingController();
  final _dataSaidaController = TextEditingController();
  final _placaController = TextEditingController();
  final _kmController = TextEditingController();
  final _localidadeJornada = TextEditingController();

  var velocidade = false;
  var reclamacao = false;
  var multa = false;
  var pequenaMonta = false;
  var grandeMonta = false;

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
    final condutores = await ApiCondutor.buscarTodosMotoristas();
    setState(() {
      _condutores = condutores
        ..sort((a, b) => a.displayName!.compareTo(b.displayName!));
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _salvarJornada() {
    if (_formKey.currentState!.validate()) {
      final jornadaData = {
        "jornadaData": _dataJornadaController.text,
        "jornadaLocalidade": _localidadeJornada.text,
        "motoristaID": _selectedCondutor?.Id,
        "placa": _placaController.text.toUpperCase(),
        "km": double.tryParse(_kmController.text)
      };

      final infracao = {
        "entradaInfracao": _dataEntradaController.text,
        "saidaInfracao": _dataSaidaController.text,
        "velocidade": velocidade,
        "reclamacao": reclamacao,
        "multa": multa,
        "pequenaMonta": pequenaMonta,
        "grandeMonta": grandeMonta,
        "motoristaId": _selectedCondutor?.Id
      };

      ApiJornada.cadastrarNovaJornada(jornadaData).then((sucesso) {
        if (sucesso) {
          _limparCampos();
        }

        ApiInfracoes.cadastrarNovaInfracao(infracao);

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
    _dataJornadaController.clear();
    _localidadeJornada.clear();
    _kmController.clear();
    _placaController.clear();
    _dataEntradaController.clear();
    _dataSaidaController.clear();
    setState(() {
      _selectedCondutor = null;
      velocidade = false;
      reclamacao = false;
      multa = false;
      pequenaMonta = false;
      grandeMonta = false;
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

  Widget buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        Switch(
          inactiveThumbColor: Constantes.roxo,
          activeColor: Constantes.roxo,
          value: value,
          onChanged: (val) {
            setState(() {
              onChanged(val);
            });
          },
        ),
      ],
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

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _inputDecoration(
        label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      onTap: () => _selectDate(context, controller),
      validator: (value) => value!.isEmpty ? 'Informe a $label' : null,
    );
  }

  Widget _buildPlacaField() {
    return TextFormField(
      controller: _placaController,
      decoration: _inputDecoration('Placa do veículo'),
      inputFormatters: [_placaMaskFormatter],
      validator: (value) => value!.isEmpty ? 'Informe a placa' : null,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildKmField() {
    return TextFormField(
      controller: _kmController,
      decoration: _inputDecoration('KM'),
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? 'Informe a quilometragem' : null,
    );
  }

  Widget _buildLocalidadeJornada() {
    return TextFormField(
      controller: _localidadeJornada,
      decoration: _inputDecoration('Origem X Destino'),
      keyboardType: TextInputType.text,
      validator: (value) =>
          value!.isEmpty ? 'Informe a Origem X Destino' : null,
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
              const SizedBox(height: 16),
              _buildDropdownCondutor(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                      child: _buildDateField(
                          'Data Jornada', _dataJornadaController)),
                  const SizedBox(width: 12),
                  Flexible(child: _buildLocalidadeJornada()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(child: _buildPlacaField()),
                  const SizedBox(width: 12),
                  Flexible(child: _buildKmField()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                      child: _buildDateField(
                          'Entrada Infração', _dataEntradaController)),
                  const SizedBox(width: 12),
                  Flexible(
                      child: _buildDateField(
                          'Saída Infração', _dataSaidaController)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 25,
                runSpacing: 6,
                children: [
                  buildSwitch(
                      'Velocidade', velocidade, (val) => velocidade = val),
                  buildSwitch(
                      'Reclamação', reclamacao, (val) => reclamacao = val),
                  buildSwitch('Multa', multa, (val) => multa = val),
                  buildSwitch('Pequena Monta', pequenaMonta,
                      (val) => pequenaMonta = val),
                  buildSwitch(
                      'Grande Monta', grandeMonta, (val) => grandeMonta = val),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btncadastrarJornada',
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
}
