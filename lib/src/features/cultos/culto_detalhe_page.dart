import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/formato.dart';
import '../../models/culto.dart';
import '../../state/cultos_store.dart';
import '../../theme/cores.dart';
import '../../theme/tipografia.dart';
import '../../widgets/cartao.dart';
import '../../widgets/chips.dart';
import '../../widgets/confirmacao.dart';
import '../../widgets/glifos.dart';
import '../../widgets/rotulos.dart';

class CultoDetalhePage extends StatelessWidget {
  const CultoDetalhePage({super.key, required this.culto});

  final Culto culto;

  Future<void> _excluir(BuildContext context) async {
    final confirmou = await confirmar(
      context,
      titulo: 'Excluir cultinho',
      mensagem:
          'O registro de ${Formato.completa(culto.data)} sai do histórico.',
      acao: 'Excluir',
      destrutiva: true,
    );
    if (!confirmou || !context.mounted) return;

    final store = context.read<CultosStore>();
    final mensageiro = ScaffoldMessenger.of(context);
    final navegador = Navigator.of(context);

    await store.remover(culto.id);
    navegador.pop();
    mensageiro
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Cultinho excluído'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => store.restaurar(culto),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final leitura = culto.leitura;
    final quemOrou = culto.quemOrou.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultinho'),
        actions: [
          IconButton(
            onPressed: () => _excluir(context),
            icon: const Icon(Icons.delete_outline_rounded),
            color: cores.perigo.cor,
            tooltip: 'Excluir cultinho',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
        children: [
          Cartao(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ChipData(
                      dia: Formato.dia(culto.data),
                      mes: Formato.mes(culto.data),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Micro('Cultinho de'),
                          const SizedBox(height: 5),
                          Text(
                            Formato.completa(culto.data),
                            style:
                                Tipo.cartaoTitulo.copyWith(color: cores.texto),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _Separador(cor: cores.borda),
                const Micro('Leitura'),
                const SizedBox(height: 8),
                Text(
                  leitura?.referencia ?? 'Sem leitura anotada',
                  style: Tipo.displayMedio.copyWith(
                    color: leitura != null ? cores.texto : cores.textoSuave,
                  ),
                ),
                for (final extra in culto.leituras.skip(1))
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      extra.referencia,
                      style: Tipo.corpoForte.copyWith(color: cores.textoSuave),
                    ),
                  ),
                _Separador(cor: cores.borda),
                const Micro('Quem orou'),
                const SizedBox(height: 6),
                Text(
                  quemOrou.isEmpty ? 'Não anotado' : quemOrou,
                  style: Tipo.corpoForte.copyWith(
                    color: quemOrou.isEmpty ? cores.textoSuave : cores.texto,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          TituloSecao(
            culto.pedidosOracao.isEmpty
                ? 'Pedidos levados'
                : 'Pedidos levados · ${culto.pedidosOracao.length}',
          ),
          if (culto.pedidosOracao.isEmpty)
            Cartao(
              child: Text(
                'Nenhum pedido foi anexado a este cultinho.',
                style: Tipo.corpo.copyWith(color: cores.textoSuave),
              ),
            )
          else
            for (final pedido in culto.pedidosOracao)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Cartao(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChipIcone(
                        icone: Glifos.daCategoria(pedido.categoria),
                        tom: Glifos.daSeveridade(context, pedido.severidade),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pedido.texto,
                              style:
                                  Tipo.corpoForte.copyWith(color: cores.texto),
                            ),
                            const SizedBox(height: 9),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                Pilula(
                                  texto: pedido.severidade.nome,
                                  tom: Glifos.daSeveridade(
                                    context,
                                    pedido.severidade,
                                  ),
                                ),
                                Pilula(
                                  texto: pedido.categoria.nome,
                                  tom: Tom(
                                    cores.textoSuave,
                                    cores.superficieAlt,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador({required this.cor});

  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(height: 1, color: cor),
    );
  }
}
