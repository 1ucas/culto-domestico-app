import 'dart:convert';

import '../models/culto.dart';
import 'deposito.dart';

class CultosRepository {
  CultosRepository(this._deposito);

  /// Chave herdada da v1 — trocar apagaria o histórico de quem já usa o app.
  static const _chave = 'cultinhos';

  final Deposito _deposito;

  /// Do mais recente para o mais antigo.
  Future<List<Culto>> listar() async {
    final bruto = await _deposito.ler(_chave);
    if (bruto == null || bruto.isEmpty) return [];

    final decodificado = json.decode(bruto);
    if (decodificado is! List) return [];

    final cultos = decodificado
        .whereType<Map<String, dynamic>>()
        .map(Culto.fromJson)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
    return cultos;
  }

  Future<void> salvar(Culto culto) async {
    final cultos = await listar();
    final existente = cultos.indexWhere((c) => c.id == culto.id);
    if (existente >= 0) {
      cultos[existente] = culto;
    } else {
      cultos.add(culto);
    }
    await _gravar(cultos);
  }

  Future<void> remover(String id) async {
    final cultos = await listar()
      ..removeWhere((c) => c.id == id);
    await _gravar(cultos);
  }

  Future<void> _gravar(List<Culto> cultos) => _deposito.escrever(
        _chave,
        json.encode(cultos.map((c) => c.toJson()).toList()),
      );
}
