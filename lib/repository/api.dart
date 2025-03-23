import 'dart:convert';

import 'package:alex/config/configuracao.dart';
import 'package:alex/models/jornada.dart';
import 'package:alex/models/motorista.dart';
import 'package:alex/models/motoristaDto.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  static Future<Motorista?> logarUsuario(String login, String senha) async {
    try {
      var url = Uri.parse(!Configuracao.isDevelop
              ? Configuracao.uri_PRD
              : Configuracao.uri_QAS + '/Auth/credenciais')
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

  static Future<List<Jornada>> getJornadas() async {
    try {
      var url = Uri.parse(!Configuracao.isDevelop
          ? Configuracao.uri_PRD
          : Configuracao.uri_QAS + '/Jornada');
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

  static Future<bool> criarUsuario(Map<String, dynamic> usuario) async {
    try {
      var url = Uri.parse(
        '${!Configuracao.isDevelop ? Configuracao.uri_PRD : Configuracao.uri_QAS}/criarCondutor',
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

  static Future<List<Jornada>> getJornadasPorMotoristaID(
      {required String motoristaID}) async {
    try {
      var url = Uri.parse(!Configuracao.isDevelop
          ? Configuracao.uri_PRD
          : Configuracao.uri_QAS + '/Jornada/porMotoristaID/${motoristaID}');
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

  static Future<List<Jornada>> getJornadasPorMotoristaIdPendentes(
      {required String motoristaID}) async {
    try {
      var url = Uri.parse(!Configuracao.isDevelop
          ? Configuracao.uri_PRD
          : Configuracao.uri_QAS +
              '/Jornada/ListarTodasJornadasData/${motoristaID}');
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

  static Future<List<MotoristaDTO>> buscarTodosCondutores() async {
    try {
      var url = Uri.parse(!Configuracao.isDevelop
          ? '${Configuracao.uri_PRD}/listarCondutor'
          : '${Configuracao.uri_QAS}/listarCondutor');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => MotoristaDTO.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }

  static Future<List<Jornada>> getJornadasPeloCondutor(
      String codigoCondutor) async {
    try {
      var url = Uri.parse(!Configuracao.isDevelop
          ? Configuracao.uri_PRD
          : Configuracao.uri_QAS + '/Jornada/{{$codigoCondutor}}');
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

  static Future<double> auditoriaKm(
      DateTime dataIni, DateTime dataFin, String idMotorista) async {
    try {
      String dataInicioStr = dataIni.toIso8601String().split('T')[0];
      String dataFimStr = dataFin.toIso8601String().split('T')[0];

      var url = Uri.parse(
          "${!Configuracao.isDevelop ? Configuracao.uri_PRD : Configuracao.uri_QAS} + /Jornada/auditoria/$dataInicioStr/$dataFimStr/$idMotorista");

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return double.tryParse(decodedResponse.toString()) ?? 0.0;
      } else {
        return 100.0;
      }
    } catch (e) {
      print("Erro na API: $e");
      return 3.0;
    }
  }


  static Future<bool> cadastrarNovaJornada(Map<String, dynamic> jornada) async {
    try {
      final Uri url = Uri.parse(
        Configuracao.isDevelop
            ? '${Configuracao.uri_QAS}/Jornada/criarNovaJornada'
            : '${Configuracao.uri_PRD}/Jornada/criarNovaJornada',
      );

      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jornada),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse['motoristaID']?.isNotEmpty == true;
      }
    } catch (e) {
      print("Erro na API: $e");
    }
    return false;
  }
}
