import 'dart:convert';

import 'package:alex/config/configuracao.dart';
import 'package:alex/models/jornada.dart';
import 'package:http/http.dart' as http;

abstract class ApiJornada {
  static Future<List<Jornada>> buscarTodasJornadas() async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/Jornada/listarTodasJornadas'
          : '${Configuracao.uri_QAS}/Jornada/listarTodasJornadas');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => Jornada.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }

  static Future<List<Jornada>> buscarJornadasPeloIdMotorista(
      {required String motoristaID}) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/Jornada/porMotoristaID/${motoristaID}'
          : '${Configuracao.uri_QAS}/Jornada/porMotoristaID/${motoristaID}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => Jornada.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }

  static Future<List<Jornada>> buscarJornadasPorMotoristaId(
      {required DateTime dataInicial,
      required DateTime dataFinal,
      required String motoristaID}) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/Jornada/ListarTodasJornadasData/${dataInicial.toString().substring(0, 10)}/${dataFinal.toString().substring(0, 10)}/${motoristaID}'
          : '${Configuracao.uri_QAS}/Jornada/ListarTodasJornadasData/${dataInicial.toString().substring(0, 10)}/${dataFinal.toString().substring(0, 10)}/${motoristaID}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => Jornada.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }

  static Future<bool> cadastrarNovaJornada(Map<String, dynamic> jornada) async {
    try {
      final Uri url = Uri.parse(
        Configuracao.isPRD
            ? '${Configuracao.uri_PRD}/Jornada/criarNovaJornada'
            : '${Configuracao.uri_QAS}/Jornada/criarNovaJornada',
      );

      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jornada),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse['id']?.isNotEmpty == true;
      }
    } catch (e) {
      print("Erro na API: $e");
    }
    return false;
  }

  static Future<List<Jornada>> buscarTodasJornadasPeloCondutor(
      String codigoCondutor) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/Jornada/{{$codigoCondutor}}'
          : '${Configuracao.uri_QAS}/Jornada/{{$codigoCondutor}}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => Jornada.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }

  static Future<bool> editarJornada(Jornada jornada) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/Jornada/atualizarJornada'
          : '${Configuracao.uri_QAS}/Jornada/atualizarJornada');

      var body = jsonEncode({
        "id": jornada.id,
        "jornadaData": jornada.jornadaData?.toIso8601String().substring(0, 10),
        "jornadaLocalidade": jornada.jornadaLocalidade?.toUpperCase(),
        "motoristaID": jornada.motoristaID,
        "placa": jornada.placa?.toUpperCase(),
        "km": jornada.km,
      });

      var response = await http.post(
        url,
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print("Jornada atualizada com sucesso!");
        return true;
      } else {
        print(
            "Erro ao atualizar jornada: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro na API: $e");
      return false;
    }
  }
}
