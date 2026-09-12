import 'livro.dart';

/// Uma leitura: livro, capítulo(s) e versículo(s).
///
/// O JSON mantém o formato da v1 — `capitulos` e `versiculos` como listas de um
/// ou dois inteiros — para que o histórico já gravado continue abrindo.
class Passagem {
  Passagem({
    required this.livro,
    required this.capituloInicio,
    required this.versiculoInicio,
    this.capituloFim,
    this.versiculoFim,
  });

  final Livro livro;
  final int capituloInicio;
  final int versiculoInicio;
  final int? capituloFim;
  final int? versiculoFim;

  bool get temIntervaloCapitulos => capituloFim != null;

  /// `Salmos 23:1-6` — a notação como se lê numa Bíblia.
  String get referencia => _formatar(livro.nome);

  /// `Sl 23:1-6`, para espaços estreitos.
  String get referenciaCurta => _formatar(livro.abreviacao);

  String _formatar(String nomeLivro) {
    final buffer = StringBuffer('$nomeLivro $capituloInicio:$versiculoInicio');
    if (capituloFim != null) {
      // Travessia de capítulos: o fim precisa repetir o capítulo.
      buffer.write(' – $capituloFim');
      if (versiculoFim != null) buffer.write(':$versiculoFim');
    } else if (versiculoFim != null) {
      buffer.write('-$versiculoFim');
    }
    return buffer.toString();
  }

  @override
  String toString() => referencia;

  factory Passagem.fromJson(Map<String, dynamic> json) {
    final capitulos = (json['capitulos'] as List?)?.cast<num>() ?? const [];
    final versiculos = (json['versiculos'] as List?)?.cast<num>() ?? const [];
    final indiceLivro = (json['livro'] as num?)?.toInt() ?? 0;

    return Passagem(
      livro: Livro.values[indiceLivro.clamp(0, Livro.values.length - 1)],
      capituloInicio: capitulos.isNotEmpty ? capitulos.first.toInt() : 1,
      capituloFim: capitulos.length > 1 ? capitulos[1].toInt() : null,
      versiculoInicio: versiculos.isNotEmpty ? versiculos.first.toInt() : 1,
      versiculoFim: versiculos.length > 1 ? versiculos[1].toInt() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'livro': livro.index,
        'capitulos': [capituloInicio, if (capituloFim != null) capituloFim],
        'versiculos': [versiculoInicio, if (versiculoFim != null) versiculoFim],
      };
}
