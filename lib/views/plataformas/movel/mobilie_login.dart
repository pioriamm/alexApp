import 'dart:io';

import 'package:alex/helps/mudarDePagina.dart';
import 'package:alex/repository/api_autenticao.dart';
import 'package:alex/views/plataformas/movel/tela_dash_motorista.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../config/configuracao.dart';
import '../../../helps/constantes.dart';
import '../web/tela_administracao_web.dart';
import 'adm/view_admin.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  late Map<String, String> versao = {};
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _carregarVersao();
  }

  void _carregarVersao() async {
    versao = await Configuracao.obterVersaoAplicacao();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: kIsWeb
                ? const EdgeInsets.symmetric(horizontal: 100.0)
                : const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    const Text(
                      "Bem Vindo!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Entrar",
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
                        labelText: "Senha",
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
                          backgroundColor: const Color(0xFF6C4AB6),
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
                        "Esqueceu sua senha?",
                        style: TextStyle(
                          color: Constantes.roxo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Não tem uma conta?"),
                        TextButton(
                          onPressed: () {
                            // Aqui você pode implementar o "Sign Up"
                          },
                          child: const Text(
                            "Registar",
                            style: TextStyle(
                              color: Constantes.roxo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    kIsWeb
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20)
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10),
                    Text("Versão build: ${versao["versaoBuild"]}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    } else {
      return 'BP22.250325.006';
    }
  }

  Future<void> _logar() async {
    String login = loginController.text.trim();
    String senha = senhaController.text.trim();
    String idCelular = kIsWeb ? 'BP22.250325.006' : await getDeviceId();

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

    var motorista = await ApiAutenticao.logarUsuario(login, senha, idCelular);

    if (motorista != null) {
      if (kIsWeb) {
        (motorista.isAdim! == true && motorista.celularId! == 'BP22.250325.006')
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
            : MudarDePagina.logIn(
                context, TelaDashMotorista(motorista: motorista));
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
