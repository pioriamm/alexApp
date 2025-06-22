import 'package:package_info_plus/package_info_plus.dart';

class Configuracao {
  static const String uri_QAS = "http://192.168.100.82:5032";
  static const String uri_PRD = "https://api-catalogo.up.railway.app";
  static bool isPRD = true;

  static Future<Map<String, String>> obterVersaoAplicacao() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return {
      "versaoBuild": packageInfo.version,
      "numeroBuild": packageInfo.buildNumber
    };
  }
}
