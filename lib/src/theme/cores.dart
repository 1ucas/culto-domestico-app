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

/// A paleta é a de uma sala à noite com uma vela acesa: papel quente, índigo
/// profundo nos blocos de marca e um âmbar que marca o que vale comemorar.
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
    required this.marcaFim,
    required this.marcaConteudo,
    required this.marcaTom,
    required this.acento,
    required this.sucesso,
    required this.perigo,
    required this.agradecimento,
    required this.normal,
    required this.importante,
    required this.urgente,
  });

  /// Papel quente de fundo da tela.
  final Color fundo;

  /// Branco dos cartões.
  final Color superficie;

  /// Fundo de blocos internos — caixas de aviso, campos.
  final Color superficieAlt;

  final Color borda;
  final Color texto;
  final Color textoSuave;

  /// Índigo da marca: onde começa o degradê dos blocos de destaque.
  final Color marca;

  /// Onde ele termina. Os dois juntos dão profundidade ao bloco sem imagem.
  final Color marcaFim;

  /// O que se escreve em cima da marca.
  final Color marcaConteudo;

  /// A marca em versão tonal, para chips e seleções.
  final Tom marcaTom;

  /// O âmbar da vela. Reservado ao que é conquista: ritmo, livros lidos,
  /// oração respondida.
  final Tom acento;

  final Tom sucesso;
  final Tom perigo;

  final Tom agradecimento;
  final Tom normal;
  final Tom importante;
  final Tom urgente;

  /// O tom do que ainda não aconteceu: a semana sem cultinho, o livro que a
  /// família ainda não leu. Precisa aparecer como lugar vago — e não sumir no
  /// papel, como sumiria [superficieAlt].
  Color get vago => textoSuave.withValues(alpha: 0.16);

  /// O degradê dos blocos de marca, do canto superior esquerdo ao inferior
  /// direito.
  LinearGradient get degradeMarca => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [marca, marcaFim],
      );

  static const claro = AppCores(
    fundo: Color(0xFFF7F3EB),
    superficie: Colors.white,
    superficieAlt: Color(0xFFF3EDE2),
    borda: Color(0xFFE8E0D2),
    texto: Color(0xFF1C1822),
    textoSuave: Color(0xFF77707F),
    marca: Color(0xFF2B2450),
    marcaFim: Color(0xFF47376B),
    marcaConteudo: Colors.white,
    marcaTom: Tom(Color(0xFF3A3168), Color(0xFFEBE7F4)),
    acento: Tom(Color(0xFFB4762A), Color(0xFFFBF0DE)),
    sucesso: Tom(Color(0xFF1D6B49), Color(0xFFE2F0E7)),
    perigo: Tom(Color(0xFFB8433A), Color(0xFFF9E8E5)),
    agradecimento: Tom(Color(0xFF1D6B49), Color(0xFFE2F0E7)),
    normal: Tom(Color(0xFF2F6FA8), Color(0xFFE4EFF7)),
    importante: Tom(Color(0xFFB4762A), Color(0xFFFBF0DE)),
    urgente: Tom(Color(0xFFB8433A), Color(0xFFF9E8E5)),
  );

  static const escuro = AppCores(
    fundo: Color(0xFF121017),
    superficie: Color(0xFF1C1924),
    superficieAlt: Color(0xFF262231),
    borda: Color(0xFF322C3E),
    texto: Color(0xFFF4F1F7),
    textoSuave: Color(0xFF9C93A8),
    marca: Color(0xFF2A2350),
    marcaFim: Color(0xFF473A72),
    marcaConteudo: Colors.white,
    marcaTom: Tom(Color(0xFFB6A9E0), Color(0xFF262138)),
    acento: Tom(Color(0xFFE0A857), Color(0xFF2E2517)),
    sucesso: Tom(Color(0xFF77C79C), Color(0xFF1B2C24)),
    perigo: Tom(Color(0xFFE58A80), Color(0xFF31211F)),
    agradecimento: Tom(Color(0xFF77C79C), Color(0xFF1B2C24)),
    normal: Tom(Color(0xFF86B4DC), Color(0xFF1B2732)),
    importante: Tom(Color(0xFFE0A857), Color(0xFF2E2517)),
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
    Color? marcaFim,
    Color? marcaConteudo,
    Tom? marcaTom,
    Tom? acento,
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
      marcaFim: marcaFim ?? this.marcaFim,
      marcaConteudo: marcaConteudo ?? this.marcaConteudo,
      marcaTom: marcaTom ?? this.marcaTom,
      acento: acento ?? this.acento,
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
      marcaFim: Color.lerp(marcaFim, other.marcaFim, t)!,
      marcaConteudo: Color.lerp(marcaConteudo, other.marcaConteudo, t)!,
      marcaTom: Tom.lerp(marcaTom, other.marcaTom, t),
      acento: Tom.lerp(acento, other.acento, t),
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
