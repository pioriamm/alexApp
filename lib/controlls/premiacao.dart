class Premiacao {
  static (int, double) faixaProdutividade(km) {
    if (km >= 8.501) {
      return (1, 2500.00);
    } else if (km > 7.501 && km <= 8.500) {
      return (2, 1900.00);
    } else if (km > 6.501 && km <= 7.500) {
      return (3, 1300.00);
    }
    return (0, 0.0);
  }

  static (int, double) faixaJornada(km) {
    if (km >= 8.501) {
      return (1, 400.00);
    } else if (km > 7.501 && km <= 8.500) {
      return (2, 300.00);
    } else if (km > 6.501 && km <= 7.500) {
      return (3, 150.00);
    }
    return (0, 0.0);
  }

  static (int, double) faixaSeguranca(pontuacao) {
    if (pontuacao == 0) {
      return (1, 500.00);
    } else if (pontuacao >= 1 && pontuacao <= 5) {
      return (2, 300.00);
    } else if (pontuacao >= 6 && pontuacao <= 10) {
      return (3, 150.00);
    } else {
      return (4, 0.00);
    }
  }

  static (int, double) mediaCombustivel(media) {
    if (media >= 2.05 && media <= 2.09) {
      return (4, 200.00);
    } else if (media >= 2.10 && media <= 2.14) {
      return (3, 300.00);
    } else if (media >= 2.15 && media <= 2.19) {
      return (2, 500.00);
    } else {
      return (1, 600.00);
    }
  }

  static double valorTotalPremio(km, pontuacao) {
    var _faixaJornada = faixaJornada(km);
    var _faixaProdutividade = faixaProdutividade(km);
    var _faixaSeguranca = faixaSeguranca(pontuacao);

    //var mediaConbustivel = mediaCombustivel(media);

    return _faixaJornada.$2 + _faixaSeguranca.$2 + _faixaProdutividade.$2;
  }
}
