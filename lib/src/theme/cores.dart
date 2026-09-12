import 'package:flutter/material.dart';

/// Um par de cores para um estado: o tom cheio (ícone, texto) e o tom de fundo
/// (o chip atrás dele).
@immutable
class Tom {
  const Tom(this.cor, this.fundo);

  final Color cor;
  final Color fundo;

  static Tom lerp(Tom a, Tom b, double t) =>
      Tom(Color.lerp(a.cor, b.cor, t)!, Color.lerp(a.fundo, b.fundo, t)!);
}

/// Superfícies brancas arredondadas sobre um creme quente, uma cor de marca
/// forte usada em blocos, e tons tonais para estados.
@immutable
class AppCores extends ThemeExtension<AppCores> {
  const AppCores({
    required this.fundo,
    required this.superficie,
    required this.superficieAlt,
    required this.borda,
    required this.texto,
    required this.textoSuave,
    required this.marca,
    required this.marcaConteudo,
    required this.marcaTom,
    required this.sucesso,
    required this.perigo,
    required this.agradecimento,
    required this.normal,
    required this.importante,
    required this.urgente,
  });

  /// Creme de fundo da tela.
  final Color fundo;

  /// Branco dos cartões.
  final Color superficie;

  /// Fundo de blocos internos — caixas de aviso, campos.
  final Color superficieAlt;

  final Color borda;
  final Color texto;
  final Color textoSuave;

  /// Azul-noite da marca: os blocos de destaque.
  final Color marca;

  /// O que se escreve em cima da marca.
  final Color marcaConteudo;

  /// A marca em versão tonal, para chips e seleções.
  final Tom marcaTom;

  final Tom sucesso;
  final Tom perigo;

  final Tom agradecimento;
  final Tom normal;
  final Tom importante;
  final Tom urgente;

  static const claro = AppCores(
    fundo: Color(0xFFF6F4F0),
    superficie: Colors.white,
    superficieAlt: Color(0xFFF4F2ED),
    borda: Color(0xFFEAE6DE),
    texto: Color(0xFF16181D),
    textoSuave: Color(0xFF74777F),
    marca: Color(0xFF22386B),
    marcaConteudo: Colors.white,
    marcaTom: Tom(Color(0xFF22386B), Color(0xFFE9EDF6)),
    sucesso: Tom(Color(0xFF1D6B49), Color(0xFFE3F0E8)),
    perigo: Tom(Color(0xFFB8433A), Color(0xFFF8E7E5)),
    agradecimento: Tom(Color(0xFF1D6B49), Color(0xFFE3F0E8)),
    normal: Tom(Color(0xFF2F6FB5), Color(0xFFE6EFF9)),
    importante: Tom(Color(0xFFA86B16), Color(0xFFF9EEDD)),
    urgente: Tom(Color(0xFFB8433A), Color(0xFFF8E7E5)),
  );

  static const escuro = AppCores(
    fundo: Color(0xFF101216),
    superficie: Color(0xFF1B1E25),
    superficieAlt: Color(0xFF242832),
    borda: Color(0xFF2A2E38),
    texto: Color(0xFFF3F3F5),
    textoSuave: Color(0xFF9B9FA9),
    marca: Color(0xFF2B457E),
    marcaConteudo: Colors.white,
    marcaTom: Tom(Color(0xFFA8BEE8), Color(0xFF22293A)),
    sucesso: Tom(Color(0xFF77C79C), Color(0xFF1B2C24)),
    perigo: Tom(Color(0xFFE58A80), Color(0xFF31211F)),
    agradecimento: Tom(Color(0xFF77C79C), Color(0xFF1B2C24)),
    normal: Tom(Color(0xFF8CB6E8), Color(0xFF1C2733)),
    importante: Tom(Color(0xFFE0AE62), Color(0xFF2E2619)),
    urgente: Tom(Color(0xFFE58A80), Color(0xFF31211F)),
  );

  @override
  AppCores copyWith({
    Color? fundo,
    Color? superficie,
    Color? superficieAlt,
    Color? borda,
    Color? texto,
    Color? textoSuave,
    Color? marca,
    Color? marcaConteudo,
    Tom? marcaTom,
    Tom? sucesso,
    Tom? perigo,
    Tom? agradecimento,
    Tom? normal,
    Tom? importante,
    Tom? urgente,
  }) {
    return AppCores(
      fundo: fundo ?? this.fundo,
      superficie: superficie ?? this.superficie,
      superficieAlt: superficieAlt ?? this.superficieAlt,
      borda: borda ?? this.borda,
      texto: texto ?? this.texto,
      textoSuave: textoSuave ?? this.textoSuave,
      marca: marca ?? this.marca,
      marcaConteudo: marcaConteudo ?? this.marcaConteudo,
      marcaTom: marcaTom ?? this.marcaTom,
      sucesso: sucesso ?? this.sucesso,
      perigo: perigo ?? this.perigo,
      agradecimento: agradecimento ?? this.agradecimento,
      normal: normal ?? this.normal,
      importante: importante ?? this.importante,
      urgente: urgente ?? this.urgente,
    );
  }

  @override
  AppCores lerp(ThemeExtension<AppCores>? other, double t) {
    if (other is! AppCores) return this;
    return AppCores(
      fundo: Color.lerp(fundo, other.fundo, t)!,
      superficie: Color.lerp(superficie, other.superficie, t)!,
      superficieAlt: Color.lerp(superficieAlt, other.superficieAlt, t)!,
      borda: Color.lerp(borda, other.borda, t)!,
      texto: Color.lerp(texto, other.texto, t)!,
      textoSuave: Color.lerp(textoSuave, other.textoSuave, t)!,
      marca: Color.lerp(marca, other.marca, t)!,
      marcaConteudo: Color.lerp(marcaConteudo, other.marcaConteudo, t)!,
      marcaTom: Tom.lerp(marcaTom, other.marcaTom, t),
      sucesso: Tom.lerp(sucesso, other.sucesso, t),
      perigo: Tom.lerp(perigo, other.perigo, t),
      agradecimento: Tom.lerp(agradecimento, other.agradecimento, t),
      normal: Tom.lerp(normal, other.normal, t),
      importante: Tom.lerp(importante, other.importante, t),
      urgente: Tom.lerp(urgente, other.urgente, t),
    );
  }
}

/// Raios de canto. Um só sistema: cartões generosos, chips médios, pílulas
/// redondas de vez.
abstract final class Raio {
  static const cartao = 20.0;
  static const bloco = 16.0;
  static const chip = 13.0;
  static const botao = 16.0;
  static const pilula = 100.0;
}

extension AppCoresContext on BuildContext {
  AppCores get cores => Theme.of(this).extension<AppCores>()!;
}
