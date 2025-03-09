import 'package:alex/config/mudarDePagina.dart';
import 'package:alex/repository/api.dart';
import 'package:alex/views/dash.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

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
                decoration: InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () async {
                  /*String login = loginController.text.trim();
                  String senha = senhaController.text.trim();*/

                  String login = 'tim@novohorizonte.com';
                  String senha = 'Ru1p@1xe5';

                  if (login.isEmpty || senha.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Preencha todos os campos",
                        ),
                      ),
                    );
                    return;
                  }

                  var motorista = await Api.getMotorista(login, senha);
                  if (motorista != null) {
                    MudarDePagina.logIn(
                      context,
                      MyHomePage(motorista: motorista),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Usuário ou senha incorretos")),
                    );
                  }
                },
                child: Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
