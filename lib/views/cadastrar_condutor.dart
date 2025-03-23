import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../repository/api.dart';

class CadastrarCondutor extends StatefulWidget {
  const CadastrarCondutor({super.key});

  @override
  State<CadastrarCondutor> createState() => _CadastrarCondutorState();
}

class _CadastrarCondutorState extends State<CadastrarCondutor> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  final phoneFormatter = MaskTextInputFormatter(
    mask: '+55 0## #####-####',
    filter: {"#": RegExp(r'[0-10]')},
  );

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final phone = _phoneController.text;
      final password1 = _passwordController1.text;
      final password2 = _passwordController2.text;

      if (password1 != password2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas precisam ser iguais'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        var usuario = {
          "displayName": name,
          "passWord": password1,
          "telefone": phone.replaceAll(RegExp(r'-'), '')
        };

        Api.criarUsuario(usuario).then((valor) {

          if (valor==true){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Condutor $name cadastrado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro para criar o usário'),
                backgroundColor: Colors.red,
              ),
            );
          }

        });
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Condutor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu telefone';
                  }
                  if (value.length < 17) {
                    return 'Número de telefone incompleto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController1,
                decoration: _inputDecoration('Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua senha';
                  }
                  if (value.length < 9) {
                    return 'A senha deve ter 9 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController2,
                decoration: _inputDecoration('Confirme a Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value.length < 9) {
                    return 'A senha deve ter 9 caracteres';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: const Icon(Icons.check),
      ),
    );
  }
}
