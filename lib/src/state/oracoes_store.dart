import 'package:flutter/foundation.dart';

import '../data/oracoes_repository.dart';
import '../models/pedido_oracao.dart';

class OracoesStore extends ChangeNotifier {
  OracoesStore(this._repository);

  final OracoesRepository _repository;

  List<PedidoOracao> _pedidos = const [];
  bool _carregando = true;

  bool get carregando => _carregando;

  /// Abertos primeiro os mais pesados; empate desempata pelo mais recente.
  List<PedidoOracao> get abertos {
    final lista = _pedidos.where((p) => !p.respondida).toList()
      ..sort((a, b) {
        final peso = b.severidade.index.compareTo(a.severidade.index);
        return peso != 0 ? peso : b.criadaEm.compareTo(a.criadaEm);
      });
    return lista;
  }

  /// Respostas, da mais recente para a mais antiga.
  List<PedidoOracao> get respondidos {
    final lista = _pedidos.where((p) => p.respondida).toList()
      ..sort((a, b) => b.respondidaEm!.compareTo(a.respondidaEm!));
    return lista;
  }

  Future<void> carregar() async {
    _pedidos = await _repository.listar();
    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionar(PedidoOracao pedido) async {
    await _repository.inserir(pedido);
    await carregar();
  }

  Future<void> marcarRespondida(String id) async {
    final pedido = _porId(id);
    if (pedido == null) return;
    await _repository.atualizar(
      pedido.copyWith(respondidaEm: DateTime.now()),
    );
    await carregar();
  }

  Future<void> reabrir(String id) async {
    final pedido = _porId(id);
    if (pedido == null) return;
    await _repository.atualizar(pedido.copyWith(limparResposta: true));
    await carregar();
  }

  Future<void> remover(String id) async {
    _pedidos = List.of(_pedidos)..removeWhere((p) => p.id == id);
    notifyListeners();
    await _repository.remover(id);
  }

  Future<void> restaurar(PedidoOracao pedido) async {
    await _repository.inserir(pedido);
    await carregar();
  }

  PedidoOracao? _porId(String id) {
    for (final pedido in _pedidos) {
      if (pedido.id == id) return pedido;
    }
    return null;
  }
}
