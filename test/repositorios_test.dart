import 'dart:convert';

import 'package:culto_domestico_app/src/data/cultos_repository.dart';
import 'package:culto_domestico_app/src/data/deposito.dart';
import 'package:culto_domestico_app/src/data/oracoes_repository.dart';
import 'package:culto_domestico_app/src/models/culto.dart';
import 'package:culto_domestico_app/src/models/livro.dart';
import 'package:culto_domestico_app/src/models/passagem.dart';
import 'package:culto_domestico_app/src/models/pedido_oracao.dart';
import 'package:flutter_test/flutter_test.dart';

PedidoOracao umPedido({
  String texto = 'pedido',
  Severidade severidade = Severidade.normal,
  Categoria categoria = Categoria.casa,
  DateTime? respondidaEm,
}) {
  return PedidoOracao(
    id: gerarId(),
    texto: texto,
    severidade: severidade,
    categoria: categoria,
    respondidaEm: respondidaEm,
  );
}

void main() {
  group('CultosRepository', () {
    test('devolve lista vazia quando nunca se gravou nada', () async {
      final repo = CultosRepository(DepositoMemoria());
      expect(await repo.listar(), isEmpty);
    });

    test('grava, lista do mais recente ao mais antigo e remove', () async {
      final repo = CultosRepository(DepositoMemoria());
      final antigo = Culto.novo(data: DateTime(2026, 1, 5), quemOrou: 'Cica');
      final recente =
          Culto.novo(data: DateTime(2026, 9, 11), quemOrou: 'Lucas');

      await repo.salvar(antigo);
      await repo.salvar(recente);

      expect((await repo.listar()).map((c) => c.quemOrou), ['Lucas', 'Cica']);

      await repo.remover(recente.id);
      expect((await repo.listar()).single.quemOrou, 'Cica');
    });

    test('salvar duas vezes o mesmo id atualiza em vez de duplicar', () async {
      final repo = CultosRepository(DepositoMemoria());
      final culto = Culto.novo(data: DateTime(2026, 9, 11), quemOrou: 'Lucas');

      await repo.salvar(culto);
      await repo.salvar(
        Culto(id: culto.id, data: culto.data, quemOrou: 'Antônio'),
      );

      final salvos = await repo.listar();
      expect(salvos, hasLength(1));
      expect(salvos.single.quemOrou, 'Antônio');
    });

    test('lê o histórico gravado pela v1 na mesma chave', () async {
      final deposito = DepositoMemoria({
        'cultinhos': json.encode([
          {
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
          },
        ]),
      });

      final culto = (await CultosRepository(deposito).listar()).single;
      expect(culto.quemOrou, 'Lucas');
      expect(culto.leitura!.referencia, 'Salmos 23:1-6');
    });

    test('ignora conteúdo corrompido em vez de quebrar', () async {
      final repo = CultosRepository(DepositoMemoria({'cultinhos': '{"a": 1}'}));
      expect(await repo.listar(), isEmpty);
    });

    test('preserva a leitura e os pedidos ao gravar', () async {
      final repo = CultosRepository(DepositoMemoria());
      await repo.salvar(
        Culto.novo(
          data: DateTime(2026, 9, 11),
          quemOrou: 'Lucas',
          leituras: [
            Passagem(
              livro: Livro.joao,
              capituloInicio: 3,
              versiculoInicio: 16,
            ),
          ],
          pedidosOracao: [umPedido(texto: 'Emprego novo')],
        ),
      );

      final culto = (await repo.listar()).single;
      expect(culto.leitura!.referencia, 'João 3:16');
      expect(culto.pedidosOracao.single.texto, 'Emprego novo');
    });
  });

  group('OracoesRepository', () {
    test('insere, atualiza e remove', () async {
      final repo = OracoesRepository(DepositoMemoria());
      final pedido = umPedido(texto: 'Saúde da vovó');

      await repo.inserir(pedido);
      expect((await repo.listar()).single.texto, 'Saúde da vovó');

      await repo.atualizar(pedido.copyWith(respondidaEm: DateTime(2026, 3, 4)));
      expect((await repo.listar()).single.respondida, isTrue);

      await repo.remover(pedido.id);
      expect(await repo.listar(), isEmpty);
    });

    test('atualizar um id inexistente não cria registro', () async {
      final repo = OracoesRepository(DepositoMemoria());
      await repo.atualizar(umPedido());
      expect(await repo.listar(), isEmpty);
    });

    test('lê pedidos gravados pela v1 e lhes dá id', () async {
      final deposito = DepositoMemoria({
        'oracoes': json.encode([
          {
            'texto': 'Emprego novo',
            'severidade': 3,
            'categoria': 1,
            'respondida': true,
          },
        ]),
      });

      final pedido = (await OracoesRepository(deposito).listar()).single;
      expect(pedido.texto, 'Emprego novo');
      expect(pedido.severidade, Severidade.urgente);
      expect(pedido.respondida, isTrue);
      expect(pedido.id, isNotEmpty);
    });
  });
}
