import 'package:flutter/foundation.dart';

import '../data/cultos_repository.dart';
import '../models/culto.dart';
import '../models/livro.dart';

/// Um mês do histórico, com os cultinhos daquele mês do mais recente para o
/// mais antigo.
@immutable
class MesDeCultos {
  const MesDeCultos({required this.mes, required this.cultos});

  /// O primeiro dia do mês — só ano e mês importam.
  final DateTime mes;
  final List<Culto> cultos;
}

class CultosStore extends ChangeNotifier {
  CultosStore(this._repository);

  final CultosRepository _repository;

  /// Quantas semanas o ritmo mostra de uma vez.
  static const semanasNoRitmo = 8;

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

  /// O histórico quebrado por mês, na ordem em que a lista já vem.
  List<MesDeCultos> get porMes {
    final grupos = <DateTime, List<Culto>>{};
    for (final culto in _cultos) {
      final mes = DateTime(culto.data.year, culto.data.month);
      grupos.putIfAbsent(mes, () => []).add(culto);
    }
    return [
      for (final entrada in grupos.entries)
        MesDeCultos(mes: entrada.key, cultos: entrada.value),
    ];
  }

  /// As últimas [semanasNoRitmo] semanas, da mais antiga para a atual: `true`
  /// onde houve pelo menos um cultinho.
  List<bool> get ritmo {
    final semanas = _semanasComCulto;
    final atual = _segunda(DateTime.now());
    return [
      for (var atras = semanasNoRitmo - 1; atras >= 0; atras--)
        semanas.contains(_menosSemanas(atual, atras)),
    ];
  }

  /// Semanas seguidas com cultinho. A semana em curso nunca conta contra: se
  /// ainda não houve cultinho nela, a conta começa na semana passada — o app
  /// não cobra ninguém no meio da semana.
  int get semanasSeguidas {
    final semanas = _semanasComCulto;
    if (semanas.isEmpty) return 0;

    var cursor = _segunda(DateTime.now());
    if (!semanas.contains(cursor)) cursor = _menosSemanas(cursor, 1);

    var total = 0;
    while (semanas.contains(cursor)) {
      total++;
      cursor = _menosSemanas(cursor, 1);
    }
    return total;
  }

  /// Quantos cultinhos passaram por cada livro da Bíblia.
  Map<Livro, int> get cultosPorLivro {
    final contagem = <Livro, int>{};
    for (final culto in _cultos) {
      // Um livro lido duas vezes no mesmo cultinho conta uma vez só.
      for (final livro in culto.leituras.map((l) => l.livro).toSet()) {
        contagem.update(livro, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    return contagem;
  }

  int get livrosVisitados => cultosPorLivro.length;

  Set<DateTime> get _semanasComCulto =>
      _cultos.map((c) => _segunda(c.data)).toSet();

  /// A segunda-feira da semana de [data], à meia-noite. A conta é feita em
  /// dias de calendário, e não em `Duration`, para não escorregar em fusos.
  static DateTime _segunda(DateTime data) =>
      DateTime(data.year, data.month, data.day - (data.weekday - DateTime.monday));

  static DateTime _menosSemanas(DateTime segunda, int semanas) =>
      DateTime(segunda.year, segunda.month, segunda.day - 7 * semanas);

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
