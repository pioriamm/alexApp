import 'dart:convert';

import 'package:alex/models/infracoes.dart';
import 'package:http/http.dart' as http;

import '../config/configuracao.dart';

abstract class ApiInfracoes {
  static Future<bool> cadastrarNovaInfracao(
      Map<String, dynamic> infracao) async {
    try {
      final Uri url = Uri.parse(
        Configuracao.isPRD
            ? '${Configuracao.uri_PRD}/criarInfracoes'
            : '${Configuracao.uri_QAS}/criarInfracoes',
      );

      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(infracao),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse['infracaoId']?.isNotEmpty == true;
      }
    } catch (e) {
      print("Erro na API: $e");
    }
    return false;
  }

  static Future<List<Infracoes>> buscarInfracoesPorMotoristaId(
      {required DateTime dataInicial,
      required DateTime dataFinal,
      required String motoristaID}) async {
    try {
      var url = Uri.parse(Configuracao.isPRD
          ? '${Configuracao.uri_PRD}/ListarInfracoesPorPeriodo/${dataInicial.toString().substring(0, 10)}/${dataFinal.toString().substring(0, 10)}/${motoristaID}'
          : '${Configuracao.uri_QAS}/ListarInfracoesPorPeriodo/${dataInicial.toString().substring(0, 10)}/${dataFinal.toString().substring(0, 10)}/${motoristaID}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return decodedResponse.map((item) => Infracoes.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }
}
