import 'package:intl/intl.dart';

class Formatador {
  static final DateFormat formatarData = DateFormat('dd/MM/yyyy');

  static final NumberFormat dinheiro = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String dataBrasileira(DateTime data) {
    return formatarData.format(data);
  }

  static String formatarTelefone(String telefone) {
    if (telefone.isEmpty) return '-';
    final numeros = telefone.replaceAll(RegExp(r'\D'), '');

    if (numeros.length >= 13) {
      return '+${numeros.substring(0, 2)} '
          '0${numeros.substring(2, 4)} '
          '${numeros.substring(4, 5)} '
          '${numeros.substring(5, 9)}'
          '-${numeros.substring(9, numeros.length)}';
    }

    return telefone;
  }

  static String gerarIniciais(String nome) {
    final partes = nome.trim().split(' ');

    if (partes.isEmpty) return '';
    final primeira = partes[0].isNotEmpty ? partes[0][0] : '';
    final segunda =
        partes.length > 1 && partes[1].isNotEmpty ? partes[1][0] : '';
    return (primeira + segunda).toUpperCase();
  }
}
