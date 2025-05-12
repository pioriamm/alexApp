import 'package:alex/models/motorista.dart';
import 'package:alex/repository/api_condutor.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarCondutor extends StatefulWidget {
  Motorista motorista;
  EditarCondutor({super.key, required this.motorista});

  @override
  State<EditarCondutor> createState() => _EditarCondutorState();
}

class _EditarCondutorState extends State<EditarCondutor> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _isAdminController = TextEditingController();

  final MaskTextInputFormatter _phoneFormatter = MaskTextInputFormatter(
    mask: '+55 0## #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    _nameController.text = widget.motorista.displayName ?? '';
    _phoneController.text = widget.motorista.telefone ?? '';
    _loginController.text = widget.motorista.login ?? '';
    _isAdminController.text = widget.motorista.isAdim.toString() ?? '';
    super.initState();
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

  void _editarCondutor() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final login = _loginController.text.trim();
      final isAdmin = _isAdminController.text.trim();

      Motorista motorista = Motorista(
        displayName: name,
        telefone: phone.replaceAll(
          RegExp(r'\D'),
          '',
        ),
        login: login,
        isAdim: isAdmin as bool,
      );

      final sucesso = await ApiCondutor.editarCondutor(motorista: motorista);

      if (sucesso) {
        _showSnackBar('Condutor $name cadastrado com sucesso!');
        _clearFields();
      } else {
        _showSnackBar('Erro ao cadastrar condutor.', isError: true);
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
  }

  void _clearFields() {
    _nameController.clear();
    _phoneController.clear();
    _loginController.clear();
    _isAdminController.clear();
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
                controller: _nameController,
                decoration: _buildInputDecoration('Nome completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do condutor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: _buildInputDecoration('Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o telefone';
                  }
                  if (value.length < 17) {
                    return 'Número de telefone incompleto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _loginController,
                decoration: _buildInputDecoration('login'),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a login';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _isAdminController,
                decoration: _buildInputDecoration('Acesso adm'),
                obscureText: false,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _editarCondutor,
        label: const Text(
          'Salvar Condutor',
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
