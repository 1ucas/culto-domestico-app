import 'dart:convert';

import '../models/pedido_oracao.dart';
import 'deposito.dart';

class OracoesRepository {
  OracoesRepository(this._deposito);

  /// Chave herdada da v1 — ver [CultosRepository].
  static const _chave = 'oracoes';

  final Deposito _deposito;

  Future<List<PedidoOracao>> listar() async {
    final bruto = await _deposito.ler(_chave);
    if (bruto == null || bruto.isEmpty) return [];

    final decodificado = json.decode(bruto);
    if (decodificado is! List) return [];

    return decodificado
        .whereType<Map<String, dynamic>>()
        .map(PedidoOracao.fromJson)
        .toList();
  }

  Future<void> inserir(PedidoOracao pedido) async {
    final pedidos = await listar()
      ..insert(0, pedido);
    await _gravar(pedidos);
  }

  Future<void> atualizar(PedidoOracao pedido) async {
    final pedidos = await listar();
    final indice = pedidos.indexWhere((p) => p.id == pedido.id);
    if (indice < 0) return;
    pedidos[indice] = pedido;
    await _gravar(pedidos);
  }

  Future<void> remover(String id) async {
    final pedidos = await listar()
      ..removeWhere((p) => p.id == id);
    await _gravar(pedidos);
  }

  Future<void> _gravar(List<PedidoOracao> pedidos) => _deposito.escrever(
        _chave,
        json.encode(pedidos.map((p) => p.toJson()).toList()),
      );
}
