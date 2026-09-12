import 'package:culto_domestico_app/src/data/cultos_repository.dart';
import 'package:culto_domestico_app/src/data/deposito.dart';
import 'package:culto_domestico_app/src/data/oracoes_repository.dart';
import 'package:culto_domestico_app/src/models/culto.dart';
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
  });
}
