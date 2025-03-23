import 'package:alex/config/mudarDePagina.dart';
import 'package:alex/repository/api.dart';
import 'package:alex/views/view_admin.dart';
import 'package:alex/views/view_motorista.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController loginController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  late var isAdm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: loginController,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () async {
                  /*String login = loginController.text.trim();
                  String senha = senhaController.text.trim();*/

                  String login = 'tim@novohorizonte.com';
                  String senha = 'Ru1p@1xe5';

                  if (login.isEmpty || senha.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Preencha todos os campos",
                        ),
                      ),
                    );
                    return;
                  }

                  var motorista = await Api.logarUsuario(login, senha);
                  if (motorista != null) {

                    motorista.isAdim == true
                        ?  mudarDePagina.logIn( context, ViewAdmin(motorista: motorista),)
                        :  mudarDePagina.logIn( context, ViewMotorista(motorista: motorista),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Usuário ou senha incorretos")),
                    );
                  }
                },
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
