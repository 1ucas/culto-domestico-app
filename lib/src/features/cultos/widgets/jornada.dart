import 'package:flutter/material.dart';

import '../../../models/livro.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/cartao.dart';
import '../../../widgets/chips.dart';

/// Os 66 livros como um mapa: cada quadradinho é um livro, e ele acende quando
/// a família passa por ali. Quanto mais vezes lido, mais forte o âmbar.
///
/// É o cartão que dá a sensação de caminho — o histórico conta o que já houve,
/// este conta o quanto ainda há pela frente.
class CartaoJornada extends StatelessWidget {
  const CartaoJornada({super.key, required this.cultosPorLivro});

  final Map<Livro, int> cultosPorLivro;

  static const _colunas = 13;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final visitados = cultosPorLivro.length;

    return Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Jornada pela Bíblia',
                  style: Tipo.cartaoTitulo.copyWith(color: cores.texto),
                ),
              ),
              Pilula(
                texto: '$visitados de ${Livro.values.length}',
                tom: visitados == 0
                    ? Tom(cores.textoSuave, cores.superficieAlt)
                    : cores.acento,
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (final testamento in Testamento.values) ...[
            Text(
              testamento.nome.toUpperCase(),
              style: Tipo.micro.copyWith(color: cores.textoSuave),
            ),
            const SizedBox(height: 9),
            _Mapa(
              livros: Livro.doTestamento(testamento),
              cultosPorLivro: cultosPorLivro,
            ),
            if (testamento != Testamento.values.last)
              const SizedBox(height: 16),
          ],
          const SizedBox(height: 16),
          Text(
            visitados == 0
                ? 'Cada leitura anotada acende um livro aqui.'
                : 'Toque num livro para ver quantas vezes ele já foi lido.',
            style: Tipo.apoio.copyWith(color: cores.textoSuave),
          ),
        ],
      ),
    );
  }
}

class _Mapa extends StatelessWidget {
  const _Mapa({required this.livros, required this.cultosPorLivro});

  final List<Livro> livros;
  final Map<Livro, int> cultosPorLivro;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricoes) {
        const vao = 5.0;
        const colunas = CartaoJornada._colunas;
        final lado =
            (restricoes.maxWidth - vao * (colunas - 1)) / colunas;

        return Wrap(
          spacing: vao,
          runSpacing: vao,
          children: [
            for (final livro in livros)
              _Quadrado(
                livro: livro,
                leituras: cultosPorLivro[livro] ?? 0,
                lado: lado,
              ),
          ],
        );
      },
    );
  }
}

class _Quadrado extends StatelessWidget {
  const _Quadrado({
    required this.livro,
    required this.leituras,
    required this.lado,
  });

  final Livro livro;
  final int leituras;
  final double lado;

  /// Três degraus de intensidade: visitado, revisitado, de casa. O primeiro
  /// degrau já é âmbar cheio o bastante para não se confundir com o vago.
  double get _forca => switch (leituras) {
        0 => 0,
        1 => 0.62,
        2 => 0.82,
        _ => 1,
      };

  String get _descricao => switch (leituras) {
        0 => '${livro.nome} · ainda não lido',
        1 => '${livro.nome} · lido em 1 cultinho',
        _ => '${livro.nome} · lido em $leituras cultinhos',
      };

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Semantics(
      button: true,
      label: _descricao,
      child: Tooltip(
        message: _descricao,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(_descricao))),
          child: Container(
            width: lado,
            height: lado,
            decoration: BoxDecoration(
              color: leituras == 0
                  ? cores.vago
                  : cores.acento.cor.withValues(alpha: _forca),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
