import 'package:flutter/material.dart';

/// Uma única família, Plus Jakarta Sans, com a hierarquia feita por peso e
/// tamanho. É uma fonte variável: o peso precisa ir em `fontVariations` para o
/// eixo ser instanciado.
abstract final class Fontes {
  static const familia = 'PlusJakarta';
}

TextStyle jakarta(
  double size,
  int weight, {
  double? height,
  double? letterSpacing,
  Color? color,
}) {
  return TextStyle(
    fontFamily: Fontes.familia,
    fontSize: size,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontWeight: FontWeight.values[(weight ~/ 100) - 1],
    fontVariations: [FontVariation('wght', weight.toDouble())],
  );
}

abstract final class Tipo {
  /// Números e frases-chave dos blocos de destaque.
  static TextStyle get display =>
      jakarta(32, 800, height: 1.1, letterSpacing: -0.8);

  static TextStyle get displayMedio =>
      jakarta(26, 800, height: 1.15, letterSpacing: -0.6);

  /// Título da tela, na barra.
  static TextStyle get titulo =>
      jakarta(22, 700, height: 1.2, letterSpacing: -0.4);

  /// Cabeçalho de seção entre blocos.
  static TextStyle get secao =>
      jakarta(17, 700, height: 1.25, letterSpacing: -0.2);

  /// Primeira linha de um cartão.
  static TextStyle get cartaoTitulo =>
      jakarta(16, 700, height: 1.3, letterSpacing: -0.2);

  static TextStyle get corpo => jakarta(15, 500, height: 1.45);
  static TextStyle get corpoForte => jakarta(15, 700, height: 1.35);
  static TextStyle get apoio => jakarta(13.5, 500, height: 1.4);
  static TextStyle get apoioForte => jakarta(13.5, 700, height: 1.35);

  /// Rótulo pequeno em caixa alta — usado com moderação, sobre um valor.
  static TextStyle get micro => jakarta(11, 700, letterSpacing: 0.9);

  static TextStyle get pilula => jakarta(12, 700, letterSpacing: 0.1);
  static TextStyle get botao => jakarta(15.5, 700, letterSpacing: -0.1);
  static TextStyle get campo => jakarta(16, 500, height: 1.35);
}
