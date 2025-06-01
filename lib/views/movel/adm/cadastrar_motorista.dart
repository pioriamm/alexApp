import 'package:alex/repository/api_motorista.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarMotorista extends StatefulWidget {
  const CadastrarMotorista({super.key});

  @override
  State<CadastrarMotorista> createState() => _CadastrarMotoristaState();
}

class _CadastrarMotoristaState extends State<CadastrarMotorista> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _ativo = false;

  final MaskTextInputFormatter _phoneFormatter = MaskTextInputFormatter(
    mask: '+55 0## #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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

  void _cadastrarCondutor() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        _showSnackBar('As senhas não coincidem.', isError: true);
        return;
      }

      final usuario = {
        "displayName": name,
        "passWord": password,
        "telefone": phone.replaceAll(RegExp(r'\D'), ''),
        "isAdim": _ativo,
        "celularId": 'Null'
      };

      final sucesso = await ApiCondutor.criarNovoMotorista(usuario);

      if (sucesso) {
        _showSnackBar('Motorista $name cadastrado com sucesso!');
        _clearFields();
      } else {
        _showSnackBar('Erro ao cadastrar Motorista.', isError: true);
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
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Motorista',
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
                'Preencha os dados do Condutor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: _buildInputDecoration('Senha'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (value.length < 9) {
                          return 'A senha deve ter no mínimo 9 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16), // Espaço entre os campos
                  Expanded(
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      decoration: _buildInputDecoration('Confirme a senha'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme a senha';
                        }
                        if (value.length < 9) {
                          return 'A senha deve ter no mínimo 9 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Administrador'),
                  const SizedBox(width: 8),
                  Switch(
                    activeColor: Colors.deepPurple,
                    value: _ativo,
                    onChanged: (bool novoValor) {
                      setState(() {
                        _ativo = novoValor;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btnCadastrarMotorista',
        onPressed: _cadastrarCondutor,
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
