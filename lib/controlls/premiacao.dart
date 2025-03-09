class Premiacao {
  static (int, double) faixaJornada(km) {
    if (km >= 6.500 && km <= 100.000) {
      return (1, 1900.00);
    } else if (km > 5.501 && km <= 5.500) {
      return (2, 1200.00);
    } else if (km > 4.501 && km <= 5.500) {
      return (3, 700.00);
    } else if (km > 3.500 && km <= 4.500) {
      return (4, 300.00);
    }
    return (0, 0.0);
  }

  static (int, double) faixaSeguranca(km) {
    if (km >= 6.500 && km <= 100.000) {
      return (1, 700.00);
    } else if (km > 5.501 && km <= 5.500) {
      return (2, 440.00);
    } else if (km > 4.501 && km <= 5.500) {
      return (3, 260.00);
    } else if (km > 3.500 && km <= 4.500) {
      return (4, 110.00);
    }
    return (0, 0.0);
  }

  static (int, double) faixaProdutividade(km) {
    if (km >= 6.500 && km <= 100.000) {
      return (1, 700.00);
    } else if (km > 5.501 && km <= 5.500) {
      return (2, 440.00);
    } else if (km > 4.501 && km <= 5.500) {
      return (3, 260.00);
    } else if (km > 3.500 && km <= 4.500) {
      return (4, 110.00);
    }
    return (0, 0.0);
  }

  static double valorTotalPremio(km) {
    var resultado1 = faixaJornada(km);
    var resultado2 = faixaSeguranca(km);
    var produtividade = faixaProdutividade(km);
    return resultado1.$2 + resultado2.$2 + produtividade.$2;
  }
}
