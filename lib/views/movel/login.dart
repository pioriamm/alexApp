import 'package:alex/helps/mudarDePagina.dart';
import 'package:alex/repository/api_autenticao.dart';
import 'package:alex/views/movel/adm/view_admin.dart';
import 'package:alex/views/movel/view_motorista.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../web/tela_administracao_web.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 100.0)
                  : const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C4AB6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _logar,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Aqui você pode implementar o "Forgot Password"
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF6C4AB6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          // Aqui você pode implementar o "Sign Up"
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFF6C4AB6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logar() async {
    String login = loginController.text.trim();
    String senha = senhaController.text.trim();

    if (login.isEmpty || senha.isEmpty) {
      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              "Preencha todos os campos",
              textAlign: TextAlign.center,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    var motorista = await ApiAutenticao.logarUsuario(login, senha);

    if (motorista != null) {
      if (kIsWeb) {
        motorista.isAdim!
            ? MudarDePagina.logIn(
                context, AdminDashboardPage(motorista: motorista))
            : _messengerKey.currentState?.showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF2E1E82),
                  content: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Text(
                      "Acesse a versão móvel",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
      } else {
        motorista.isAdim!
            ? MudarDePagina.logIn(context, ViewAdmin(motorista: motorista))
            : MudarDePagina.logIn(context, ViewMotorista(motorista: motorista));
      }
    } else {
      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              "Usuário ou senha incorretos",
              textAlign: TextAlign.center,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
