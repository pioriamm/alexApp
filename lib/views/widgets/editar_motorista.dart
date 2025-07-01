import 'package:alex/helps/mudarDePagina.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/repository/api_motorista.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarMotorista extends StatefulWidget {
  Motorista motorista;
  EditarMotorista({super.key, required this.motorista});

  @override
  State<EditarMotorista> createState() => _EditarMotoristaState();
}

class _EditarMotoristaState extends State<EditarMotorista> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  late int _perfilAcessoController;
  late final String idMotorista;
  String _perfilSelecionado = '1';

  final MaskTextInputFormatter _phoneFormatter = MaskTextInputFormatter(
    mask: '+55 0## #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    _nameController.text = widget.motorista.displayName ?? '';
    _phoneController.text = widget.motorista.telefone ?? '';
    _loginController.text = widget.motorista.login ?? '';
    _perfilAcessoController = widget.motorista.perfilAcesso ?? 2;
    idMotorista = widget.motorista.Id!;

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

  void _editarMotorista() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final login = _loginController.text.trim();
      final isAdmin = _perfilAcessoController;

      Motorista motorista = Motorista(
        Id: idMotorista,
        displayName: name,
        telefone: phone.replaceAll(
          RegExp(r'\D'),
          '',
        ),
        perfilAcesso: isAdmin,
      );

      final sucesso = await ApiCondutor.editarMotorista(motorista: motorista);

      if (sucesso) {
        _showSnackBar('Condutor $name cadastrado com sucesso!');
        _clearFields();
      } else {
        _showSnackBar('Erro ao cadastrar condutor.', isError: true);
      }

      MudarDePagina.sairTela(context);
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
              Row(
                children: [
                  const Text('Perfim de Acesso'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _perfilSelecionado,
                    items: const [
                      DropdownMenuItem(
                        value: '1',
                        child: Text('Administrador'),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        child: Text('Motorista'),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('Administrativo'),
                      ),
                    ],
                    onChanged: (String? novoValor) {
                      setState(() {
                        _perfilSelecionado = novoValor!;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btnSalvarMotorista',
        onPressed: _editarMotorista,
        label: const Text(
          'Salvar Motorista',
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
