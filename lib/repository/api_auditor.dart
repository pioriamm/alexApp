abstract class ApiAuditor {
  // TODO(Remover): Confirmar se ainda e nescessário essa chamada.
  /*static Future<double> auditoriaKm( DateTime ultimaAuditoria, String idMotorista) async {
    try {
      DateTime dataInicio = DateTime( ultimaAuditoria.year,ultimaAuditoria.month - 1,ultimaAuditoria.day);
      DateTime dataFim = ultimaAuditoria;

      var url = Uri.parse(
          Configuracao.isPRD ?
          '${Configuracao.uri_PRD}/Jornada/auditoria/$dataInicio/$dataFim/$idMotorista' :
          '${Configuracao.uri_QAS}/Jornada/auditoria/$dataInicio/$dataFim/$idMotorista');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return double.tryParse(decodedResponse.toString()) ?? 0.0;
      } else {
        return 0.0;
      }
    } catch (e) {
      print("Erro na API: $e");
      return 0.0;
    }
  }*/
}
