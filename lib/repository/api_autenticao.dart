import 'dart:convert';

import 'package:alex/config/configuracao.dart';
import 'package:alex/models/jornada.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/models/motoristaDto.dart';
import 'package:http/http.dart' as http;

abstract class ApiAutenticao {

  static Future<Motorista?> logarUsuario(String login, String senha) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
              ? '${Configuracao.uri_PRD}/Auth/credenciais'
              : '${Configuracao.uri_QAS}/Auth/credenciais')
          .replace(queryParameters: {'login': login, 'senha': senha});

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse is List) {
          return decodedResponse.isNotEmpty
              ? Motorista.fromJson(decodedResponse.first)
              : null;
        } else if (decodedResponse is Map<String, dynamic>) {
          return Motorista.fromJson(decodedResponse);
        } else {
          print("Erro: Resposta inesperada da API.");
          return null;
        }
      } else {
        print("Erro: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erro na API: $e");
      return null;
    }
  }


}
