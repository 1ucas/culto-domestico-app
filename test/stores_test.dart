import 'package:culto_domestico_app/src/data/cultos_repository.dart';
import 'package:culto_domestico_app/src/data/deposito.dart';
import 'package:culto_domestico_app/src/data/oracoes_repository.dart';
import 'package:culto_domestico_app/src/models/culto.dart';
import 'package:culto_domestico_app/src/models/livro.dart';
import 'package:culto_domestico_app/src/models/passagem.dart';
import 'package:culto_domestico_app/src/models/pedido_oracao.dart';
import 'package:culto_domestico_app/src/state/cultos_store.dart';
import 'package:culto_domestico_app/src/state/oracoes_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'repositorios_test.dart' show umPedido;

void main() {
  group('CultosStore', () {
    late CultosStore store;

    setUp(() => store = CultosStore(CultosRepository(DepositoMemoria())));

    test('começa carregando e esvazia depois de carregar', () async {
      expect(store.carregando, isTrue);
      await store.carregar();
      expect(store.carregando, isFalse);
      expect(store.vazio, isTrue);
    });

    test('conta quantos cultinhos aconteceram no mês corrente', () async {
      final agora = DateTime.now();
      await store.salvar(Culto.novo(data: agora, quemOrou: 'Lucas'));
      await store.salvar(
        Culto.novo(
          data: DateTime(agora.year - 1, agora.month, 1),
          quemOrou: 'Cica',
        ),
      );

      expect(store.cultos, hasLength(2));
      expect(store.totalNoMes, 1);
    });

    /// Uma segunda-feira [semanas] semanas atrás, para montar o ritmo sem
    /// depender do dia em que o teste roda.
    DateTime segundaAtras(int semanas) {
      final hoje = DateTime.now();
      final segunda = DateTime(
        hoje.year,
        hoje.month,
        hoje.day - (hoje.weekday - DateTime.monday),
      );
      return DateTime(segunda.year, segunda.month, segunda.day - 7 * semanas);
    }

    test('o ritmo acende só as semanas que tiveram cultinho', () async {
      await store.salvar(Culto.novo(data: segundaAtras(0), quemOrou: 'Lucas'));
      await store.salvar(Culto.novo(data: segundaAtras(2), quemOrou: 'Cica'));

      final ritmo = store.ritmo;
      expect(ritmo, hasLength(CultosStore.semanasNoRitmo));
      // A lista vai da mais antiga para a atual: a última é esta semana.
      expect(ritmo.last, isTrue);
      expect(ritmo[ritmo.length - 2], isFalse);
      expect(ritmo[ritmo.length - 3], isTrue);
    });

    test('conta as semanas seguidas até a atual', () async {
      for (var atras = 0; atras < 3; atras++) {
        await store.salvar(
          Culto.novo(data: segundaAtras(atras), quemOrou: 'Lucas'),
        );
      }
      expect(store.semanasSeguidas, 3);
    });

    test('a semana em curso sem cultinho não quebra a sequência', () async {
      await store.salvar(Culto.novo(data: segundaAtras(1), quemOrou: 'Lucas'));
      await store.salvar(Culto.novo(data: segundaAtras(2), quemOrou: 'Cica'));

      // Nada nesta semana ainda, e mesmo assim as duas anteriores contam.
      expect(store.semanasSeguidas, 2);
    });

    test('sem nenhum cultinho não há sequência', () async {
      await store.carregar();
      expect(store.semanasSeguidas, 0);
      expect(store.ritmo.any((s) => s), isFalse);
    });

    test('conta em quantos cultinhos cada livro foi lido', () async {
      Passagem passagem(Livro livro) =>
          Passagem(livro: livro, capituloInicio: 1, versiculoInicio: 1);

      await store.salvar(Culto.novo(
        data: DateTime(2026, 9, 1),
        quemOrou: 'Lucas',
        leituras: [passagem(Livro.salmos)],
      ));
      await store.salvar(Culto.novo(
        data: DateTime(2026, 9, 8),
        quemOrou: 'Cica',
        // O mesmo livro duas vezes no mesmo cultinho conta uma vez só.
        leituras: [passagem(Livro.salmos), passagem(Livro.salmos)],
      ));
      await store.salvar(Culto.novo(
        data: DateTime(2026, 9, 15),
        quemOrou: 'Lucas',
        leituras: [passagem(Livro.joao)],
      ));

      expect(store.cultosPorLivro, {Livro.salmos: 2, Livro.joao: 1});
      expect(store.livrosVisitados, 2);
    });

    test('agrupa o histórico por mês, do mais recente para o mais antigo',
        () async {
      await store.salvar(Culto.novo(data: DateTime(2026, 8, 3), quemOrou: 'A'));
      await store.salvar(Culto.novo(data: DateTime(2026, 9, 1), quemOrou: 'B'));
      await store.salvar(Culto.novo(data: DateTime(2026, 9, 15), quemOrou: 'C'));

      final meses = store.porMes;
      expect(meses.map((m) => m.mes), [DateTime(2026, 9), DateTime(2026, 8)]);
      expect(meses.first.cultos.map((c) => c.quemOrou), ['C', 'B']);
      expect(meses.last.cultos.single.quemOrou, 'A');
    });

    test('restaurar devolve um cultinho excluído', () async {
      final culto = Culto.novo(data: DateTime(2026, 9, 11), quemOrou: 'Lucas');
      await store.salvar(culto);
      await store.remover(culto.id);
      expect(store.cultos, isEmpty);

      await store.restaurar(culto);
      expect(store.cultos.single.id, culto.id);
    });
  });

  group('OracoesStore', () {
    late OracoesStore store;

    setUp(() => store = OracoesStore(OracoesRepository(DepositoMemoria())));

    test('ordena os abertos pelos mais pesados primeiro', () async {
      await store.adicionar(umPedido(
        texto: 'normal',
        severidade: Severidade.normal,
      ));
      await store.adicionar(umPedido(
        texto: 'urgente',
        severidade: Severidade.urgente,
      ));
      await store.adicionar(umPedido(
        texto: 'agradecimento',
        severidade: Severidade.agradecimento,
      ));

      expect(
        store.abertos.map((p) => p.texto),
        ['urgente', 'normal', 'agradecimento'],
      );
    });

    test('marcar como respondida move o pedido entre as listas', () async {
      final pedido = umPedido(texto: 'Emprego novo');
      await store.adicionar(pedido);
      expect(store.abertos, hasLength(1));
      expect(store.respondidos, isEmpty);

      await store.marcarRespondida(pedido.id);
      expect(store.abertos, isEmpty);
      expect(store.respondidos.single.texto, 'Emprego novo');
      expect(store.respondidos.single.respondidaEm, isNotNull);
    });

    test('reabrir traz o pedido de volta para a lista de oração', () async {
      final pedido = umPedido();
      await store.adicionar(pedido);
      await store.marcarRespondida(pedido.id);
      await store.reabrir(pedido.id);

      expect(store.abertos, hasLength(1));
      expect(store.respondidos, isEmpty);
    });

    test('marcar um id inexistente não faz nada', () async {
      await store.carregar();
      await store.marcarRespondida('nao-existe');
      expect(store.abertos, isEmpty);
    });

    test('restaurar devolve um pedido excluído', () async {
      final pedido = umPedido();
      await store.adicionar(pedido);
      await store.remover(pedido.id);
      expect(store.abertos, isEmpty);

      await store.restaurar(pedido);
      expect(store.abertos.single.id, pedido.id);
    });

    test('respondidos vêm da resposta mais recente para a mais antiga',
        () async {
      final antigo =
          umPedido(texto: 'antigo', respondidaEm: DateTime(2025, 1, 1));
      final novo = umPedido(texto: 'novo', respondidaEm: DateTime(2026, 1, 1));
      await store.adicionar(antigo);
      await store.adicionar(novo);

      expect(store.respondidos.map((p) => p.texto), ['novo', 'antigo']);
    });

    test('agrupa as respostas por mês e joga as sem data no fim', () async {
      await store.adicionar(
        umPedido(texto: 'setembro', respondidaEm: DateTime(2026, 9, 2)),
      );
      await store.adicionar(
        umPedido(texto: 'agosto', respondidaEm: DateTime(2026, 8, 20)),
      );
      // Pedido migrado da v1: marcado como respondido, mas sem data guardada.
      await store.adicionar(
        umPedido(
          texto: 'sem data',
          respondidaEm: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      );

      final meses = store.respondidosPorMes;
      expect(
        meses.map((m) => m.mes),
        [DateTime(2026, 9), DateTime(2026, 8), null],
      );
      expect(meses.last.pedidos.single.texto, 'sem data');
    });

    test('conta as respostas do mês corrente e ignora as sem data', () async {
      final agora = DateTime.now();
      await store.adicionar(umPedido(texto: 'deste mês', respondidaEm: agora));
      await store.adicionar(
        umPedido(texto: 'ano passado', respondidaEm: DateTime(agora.year - 1, agora.month, 1)),
      );
      await store.adicionar(
        umPedido(
          texto: 'sem data',
          respondidaEm: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      );

      expect(store.respondidasNoMes, 1);
    });
  });
}
