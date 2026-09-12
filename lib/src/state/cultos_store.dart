import 'package:flutter/foundation.dart';

import '../data/cultos_repository.dart';
import '../models/culto.dart';

class CultosStore extends ChangeNotifier {
  CultosStore(this._repository);

  final CultosRepository _repository;

  List<Culto> _cultos = const [];
  bool _carregando = true;

  List<Culto> get cultos => _cultos;
  bool get carregando => _carregando;
  bool get vazio => !_carregando && _cultos.isEmpty;

  int get totalNoMes {
    final agora = DateTime.now();
    return _cultos
        .where((c) => c.data.year == agora.year && c.data.month == agora.month)
        .length;
  }

  Future<void> carregar() async {
    _cultos = await _repository.listar();
    _carregando = false;
    notifyListeners();
  }

  Future<void> salvar(Culto culto) async {
    await _repository.salvar(culto);
    await carregar();
  }

  Future<void> remover(String id) async {
    _cultos = List.of(_cultos)..removeWhere((c) => c.id == id);
    notifyListeners();
    await _repository.remover(id);
  }

  /// Devolve um cultinho apagado por engano ao seu lugar.
  Future<void> restaurar(Culto culto) async {
    await _repository.salvar(culto);
    await carregar();
  }
}
