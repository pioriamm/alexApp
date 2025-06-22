import 'dart:convert';

import 'package:alex/config/configuracao.dart';
import 'package:alex/models/motorista.dart';
import 'package:http/http.dart' as http;

abstract class ApiAutenticao {
  static Future<Motorista?> logarUsuario(
      String login, String senha, String idCelular) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
              ? '${Configuracao.uri_PRD}/Auth/credenciais'
              : '${Configuracao.uri_QAS}/Auth/credenciais')
          .replace(queryParameters: {
        'login': login,
        'senha': senha,
        'idCelular': idCelular
      });

      var response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return Motorista.fromJson(decoded['motorista']);
      }
    } catch (e) {
      return null;
    }
  }
}
