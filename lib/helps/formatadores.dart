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
}
