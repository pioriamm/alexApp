import 'dart:convert';

import 'package:alex/config/configuracao.dart';
import 'package:alex/models/motorista.dart';
import 'package:http/http.dart' as http;

abstract class ApiCondutor {
  static Future<List<Motorista>> buscarTodosCondutores() async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/listarCondutor'
          : '${Configuracao.uri_QAS}/listarCondutor');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => Motorista.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }

  static Future<bool> criarNovoCondutor(Map<String, dynamic> usuario) async {
    try {
      var url = Uri.parse(
        Configuracao.isPRD
            ? '${Configuracao.uri_PRD}/criarCondutor'
            : '${Configuracao.uri_QAS}/criarCondutor',
      );

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(usuario),
      );

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse["usuarioCriado"] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print("Erro na API: $e");
      return false;
    }
  }

  static Future<bool> editarCondutor({required Motorista motorista}) async {
    try {
      var url = Uri.parse(
        Configuracao.isPRD
            ? '${Configuracao.uri_PRD}/atualizarCondutor'
            : '${Configuracao.uri_QAS}/atualizarCondutor',
      );

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(motorista),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erro na API: $e");
      return false;
    }
  }
}
