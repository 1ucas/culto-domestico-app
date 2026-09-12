/// Quão pesado é o pedido. A ordem é chave de persistência — não reordene.
enum Severidade {
  agradecimento('Agradecimento'),
  normal('Normal'),
  importante('Importante'),
  urgente('Urgente');

  const Severidade(this.nome);
  final String nome;
}

/// Sobre o que é o pedido. A ordem é chave de persistência — não reordene.
enum Categoria {
  saude('Saúde'),
  profissional('Profissional'),
  pessoal('Pessoal'),
  casa('Casa'),
  relacionamento('Relacionamento'),
  outro('Outro');

  const Categoria(this.nome);
  final String nome;
}

class PedidoOracao {
  PedidoOracao({
    required this.id,
    required this.texto,
    required this.severidade,
    required this.categoria,
    this.respondidaEm,
    DateTime? criadaEm,
  }) : criadaEm = criadaEm ?? DateTime.now();

  final String id;
  final String texto;
  final Severidade severidade;
  final Categoria categoria;
  final DateTime criadaEm;

  /// Quando Deus respondeu. Nulo enquanto o pedido está aberto.
  final DateTime? respondidaEm;

  bool get respondida => respondidaEm != null;

  PedidoOracao copyWith({
    String? texto,
    Severidade? severidade,
    Categoria? categoria,
    DateTime? respondidaEm,
    bool limparResposta = false,
  }) {
    return PedidoOracao(
      id: id,
      texto: texto ?? this.texto,
      severidade: severidade ?? this.severidade,
      categoria: categoria ?? this.categoria,
      criadaEm: criadaEm,
      respondidaEm: limparResposta ? null : (respondidaEm ?? this.respondidaEm),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is PedidoOracao && other.id == id);

  @override
  int get hashCode => id.hashCode;

  /// Aceita tanto o formato v2 quanto o da v1, que não tinha `id` nem data de
  /// resposta — só o booleano `respondida`.
  factory PedidoOracao.fromJson(Map<String, dynamic> json) {
    final respondidaLegado = json['respondida'] == true;
    final respondidaEm = json['respondidaEm'] as String?;
    final criadaEm = json['criadaEm'] as String?;

    return PedidoOracao(
      id: json['id'] as String? ?? gerarId(),
      texto: json['texto'] as String? ?? '',
      severidade: Severidade.values[((json['severidade'] as num?)?.toInt() ?? 1)
          .clamp(0, Severidade.values.length - 1)],
      categoria: Categoria.values[((json['categoria'] as num?)?.toInt() ?? 0)
          .clamp(0, Categoria.values.length - 1)],
      criadaEm: criadaEm != null ? DateTime.tryParse(criadaEm) : null,
      respondidaEm: respondidaEm != null
          ? DateTime.tryParse(respondidaEm)
          : (respondidaLegado ? DateTime.fromMillisecondsSinceEpoch(0) : null),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'texto': texto,
        'severidade': severidade.index,
        'categoria': categoria.index,
        'criadaEm': criadaEm.toIso8601String(),
        'respondidaEm': respondidaEm?.toIso8601String(),
        // Mantido para que uma eventual volta à v1 ainda leia o estado.
        'respondida': respondida,
      };
}

var _sequencia = 0;

/// Id estável e ordenável: a v1 identificava pedidos pelo `hashCode` do
/// conteúdo, então dois pedidos iguais eram o mesmo registro.
String gerarId() {
  _sequencia = (_sequencia + 1) & 0xFFFF;
  final agora = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  return '$agora-${_sequencia.toRadixString(36)}';
}
