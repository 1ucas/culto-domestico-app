import 'package:culto_domestico_app/src/models/culto.dart';
import 'package:culto_domestico_app/src/models/livro.dart';
import 'package:culto_domestico_app/src/models/passagem.dart';
import 'package:culto_domestico_app/src/models/pedido_oracao.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Passagem', () {
    test('formata capítulo e versículo únicos', () {
      final passagem = Passagem(
        livro: Livro.salmos,
        capituloInicio: 23,
        versiculoInicio: 1,
      );
      expect(passagem.referencia, 'Salmos 23:1');
      expect(passagem.referenciaCurta, 'Sl 23:1');
    });

    test('formata intervalo de versículos com travessão', () {
      final passagem = Passagem(
        livro: Livro.salmos,
        capituloInicio: 23,
        versiculoInicio: 1,
        versiculoFim: 6,
      );
      expect(passagem.referencia, 'Salmos 23:1-6');
    });

    test('formata intervalo de capítulos', () {
      final passagem = Passagem(
        livro: Livro.joao,
        capituloInicio: 1,
        versiculoInicio: 1,
        capituloFim: 3,
        versiculoFim: 16,
      );
      expect(passagem.referencia, 'João 1:1 – 3:16');
    });

    test('sobrevive a uma ida e volta pelo JSON', () {
      final original = Passagem(
        livro: Livro.apocalipse,
        capituloInicio: 21,
        versiculoInicio: 1,
        versiculoFim: 4,
      );
      final volta = Passagem.fromJson(original.toJson());

      expect(volta.livro, original.livro);
      expect(volta.capituloInicio, 21);
      expect(volta.capituloFim, isNull);
      expect(volta.versiculoFim, 4);
    });

    test('lê o formato da v1, com listas de capítulos e versículos', () {
      final passagem = Passagem.fromJson({
        'livro': 18,
        'capitulos': [23],
        'versiculos': [1, 6],
      });

      expect(passagem.livro, Livro.salmos);
      expect(passagem.capituloInicio, 23);
      expect(passagem.capituloFim, isNull);
      expect(passagem.versiculoInicio, 1);
      expect(passagem.versiculoFim, 6);
    });
  });

  group('Livro', () {
    test('mantém os índices que a v1 gravou no aparelho', () {
      expect(Livro.values[0], Livro.genesis);
      expect(Livro.values[18], Livro.salmos);
      expect(Livro.values[42], Livro.joao);
      expect(Livro.values[65], Livro.apocalipse);
      expect(Livro.values.length, 66);
    });

    test('separa os testamentos em Malaquias', () {
      expect(Livro.malaquias.antigoTestamento, isTrue);
      expect(Livro.mateus.antigoTestamento, isFalse);
      expect(Livro.doTestamento(Testamento.antigo).length, 39);
      expect(Livro.doTestamento(Testamento.novo).length, 27);
    });
  });

  group('PedidoOracao', () {
    test('nasce aberto e fica respondido com a data', () {
      final pedido = PedidoOracao(
        id: 'a',
        texto: 'Saúde da vovó',
        severidade: Severidade.importante,
        categoria: Categoria.saude,
      );
      expect(pedido.respondida, isFalse);

      final respondido = pedido.copyWith(respondidaEm: DateTime(2026, 3, 4));
      expect(respondido.respondida, isTrue);
      expect(respondido.respondidaEm, DateTime(2026, 3, 4));
      expect(respondido.id, 'a');
    });

    test('copyWith com limparResposta reabre o pedido', () {
      final respondido = PedidoOracao(
        id: 'a',
        texto: 'Saúde da vovó',
        severidade: Severidade.importante,
        categoria: Categoria.saude,
        respondidaEm: DateTime(2026, 3, 4),
      );
      expect(respondido.copyWith(limparResposta: true).respondida, isFalse);
    });

    test('lê o formato da v1, sem id e com "respondida" booleano', () {
      final pedido = PedidoOracao.fromJson({
        'texto': 'Emprego novo',
        'severidade': 3,
        'categoria': 1,
        'respondida': true,
      });

      expect(pedido.texto, 'Emprego novo');
      expect(pedido.severidade, Severidade.urgente);
      expect(pedido.categoria, Categoria.profissional);
      expect(pedido.respondida, isTrue);
      expect(pedido.id, isNotEmpty);
    });

    test('índices de severidade e categoria seguem os da v1', () {
      expect(Severidade.values[0], Severidade.agradecimento);
      expect(Severidade.values[3], Severidade.urgente);
      expect(Categoria.values[0], Categoria.saude);
      expect(Categoria.values[5], Categoria.outro);
    });

    test('gerarId não repete', () {
      final ids = {for (var i = 0; i < 500; i++) gerarId()};
      expect(ids.length, 500);
    });
  });

  group('Culto', () {
    PedidoOracao pedido(Categoria categoria) => PedidoOracao(
          id: gerarId(),
          texto: 'pedido',
          severidade: Severidade.normal,
          categoria: categoria,
        );

    test('agrupa pedidos por categoria na ordem do enum', () {
      final culto = Culto.novo(
        data: DateTime(2026, 9, 11),
        quemOrou: 'Lucas',
        pedidosOracao: [
          pedido(Categoria.casa),
          pedido(Categoria.saude),
          pedido(Categoria.casa),
        ],
      );

      expect(culto.pedidosPorCategoria, {
        Categoria.saude: 1,
        Categoria.casa: 2,
      });
    });

    test('lê o formato da v1 inteiro', () {
      final culto = Culto.fromJson({
        'id': '[#12345]',
        'data': '2024-01-15T00:00:00.000',
        'quemOrou': 'Lucas',
        'leituraFeita': [
          {
            'livro': 18,
            'capitulos': [23],
            'versiculos': [1, 6],
          },
        ],
        'pedidosOracao': [
          {
            'texto': 'Saúde da vovó',
            'severidade': 2,
            'categoria': 0,
            'respondida': false,
          },
        ],
      });

      expect(culto.id, '[#12345]');
      expect(culto.quemOrou, 'Lucas');
      expect(culto.leitura!.referencia, 'Salmos 23:1-6');
      expect(culto.pedidosOracao.single.categoria, Categoria.saude);
    });

    test('tolera um registro sem leitura e sem pedidos', () {
      final culto = Culto.fromJson({
        'id': 'x',
        'data': '2024-01-15T00:00:00.000',
        'quemOrou': '',
      });

      expect(culto.leitura, isNull);
      expect(culto.pedidosOracao, isEmpty);
    });
  });
}
