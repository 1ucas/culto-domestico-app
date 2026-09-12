import 'passagem.dart';
import 'pedido_oracao.dart';

/// Um cultinho: a data, a leitura, quem orou e os pedidos levados naquele dia.
///
/// Os pedidos ficam copiados dentro do registro de propósito — o cultinho é um
/// retrato daquela noite e não muda quando a lista de oração muda depois.
class Culto {
  Culto({
    required this.id,
    required this.data,
    required this.quemOrou,
    this.leituras = const [],
    this.pedidosOracao = const [],
  });

  Culto.novo({
    required this.data,
    required this.quemOrou,
    this.leituras = const [],
    this.pedidosOracao = const [],
  }) : id = gerarId();

  final String id;
  final DateTime data;
  final String quemOrou;
  final List<Passagem> leituras;
  final List<PedidoOracao> pedidosOracao;

  Passagem? get leitura => leituras.isEmpty ? null : leituras.first;

  /// Quantos pedidos por categoria, na ordem do enum — o resumo que aparece na
  /// linha do registro.
  Map<Categoria, int> get pedidosPorCategoria {
    final contagem = <Categoria, int>{};
    for (final pedido in pedidosOracao) {
      contagem.update(pedido.categoria, (n) => n + 1, ifAbsent: () => 1);
    }
    return Map.fromEntries(
      Categoria.values
          .where(contagem.containsKey)
          .map((c) => MapEntry(c, contagem[c]!)),
    );
  }

  factory Culto.fromJson(Map<String, dynamic> json) {
    return Culto(
      id: json['id'] as String? ?? gerarId(),
      data: DateTime.tryParse(json['data'] as String? ?? '') ?? DateTime.now(),
      quemOrou: json['quemOrou'] as String? ?? '',
      leituras: ((json['leituraFeita'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(Passagem.fromJson)
          .toList(),
      pedidosOracao: ((json['pedidosOracao'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(PedidoOracao.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data.toIso8601String(),
        'quemOrou': quemOrou,
        'leituraFeita': leituras.map((l) => l.toJson()).toList(),
        'pedidosOracao': pedidosOracao.map((p) => p.toJson()).toList(),
      };
}
