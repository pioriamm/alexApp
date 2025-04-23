import 'package:alex/views/movel/login.dart';
import 'package:alex/views/web/tela_administracao_web.dart';
import 'package:alex/views/web/web_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: kIsWeb ?  const WebLogin(): Login(),
    );
  }
}
