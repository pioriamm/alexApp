import 'package:flutter/material.dart';

class MudarDePagina {
  static void trocarTela(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  static void logIn(BuildContext context, Widget tela) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  static void logoff(BuildContext context, tela) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => tela),
      (Route<dynamic> route) => false,
    );
  }
}
