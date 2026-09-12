import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pedido_oracao.dart';
import '../../state/oracoes_store.dart';
import '../../theme/cores.dart';
import '../../theme/tipografia.dart';
import '../../widgets/animacoes.dart';
import '../../widgets/campos.dart';
import '../../widgets/confirmacao.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/rotulos.dart';
import 'nova_oracao_page.dart';
import 'widgets/cartao_oracao.dart';

class OracoesPage extends StatefulWidget {
  const OracoesPage({super.key});

  @override
  State<OracoesPage> createState() => _OracoesPageState();
}

class _OracoesPageState extends State<OracoesPage> {
  bool _verRespondidas = false;

  Future<void> _novoPedido() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NovaOracaoPage()),
    );
  }

  void _avisar(String mensagem, {String? acao, VoidCallback? onAcao}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          action: acao != null && onAcao != null
              ? SnackBarAction(label: acao, onPressed: onAcao)
              : null,
        ),
      );
  }

  void _marcarRespondida(OracoesStore store, PedidoOracao pedido) {
    store.marcarRespondida(pedido.id);
    _avisar(
      'Guardado nas respostas',
      acao: 'Desfazer',
      onAcao: () => store.reabrir(pedido.id),
    );
  }

  void _reabrir(OracoesStore store, PedidoOracao pedido) {
    store.reabrir(pedido.id);
    _avisar('De volta à lista de oração');
  }

  void _excluir(OracoesStore store, PedidoOracao pedido) {
    store.remover(pedido.id);
    _avisar(
      'Pedido excluído',
      acao: 'Desfazer',
      onAcao: () => store.restaurar(pedido),
    );
  }

  Future<bool> _confirmarExclusao() => confirmar(
        context,
        titulo: 'Excluir pedido',
        mensagem: 'O pedido some da lista. Cultinhos já registrados continuam '
            'mostrando o que foi levado naquele dia.',
        acao: 'Excluir',
        destrutiva: true,
      );

  Future<void> _abrirAcoes(OracoesStore store, PedidoOracao pedido) async {
    final cores = context.cores;

    await showModalBottomSheet<void>(
      context: context,
      builder: (contexto) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 2, 24, 18),
              child: Text(
                pedido.texto,
                style: Tipo.secao.copyWith(color: cores.texto),
              ),
            ),
            if (pedido.respondida)
              _Acao(
                icone: Icons.undo_rounded,
                rotulo: 'Voltar para a lista de oração',
                tom: Tom(cores.textoSuave, cores.superficieAlt),
                onTap: () {
                  Navigator.of(contexto).pop();
                  _reabrir(store, pedido);
                },
              )
            else
              _Acao(
                icone: Icons.check_circle_rounded,
                rotulo: 'Marcar como respondida',
                tom: cores.sucesso,
                onTap: () {
                  Navigator.of(contexto).pop();
                  _marcarRespondida(store, pedido);
                },
              ),
            _Acao(
              icone: Icons.delete_outline_rounded,
              rotulo: 'Excluir pedido',
              tom: cores.perigo,
              onTap: () async {
                Navigator.of(contexto).pop();
                if (await _confirmarExclusao()) _excluir(store, pedido);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orações'),
        actions: [
          BotaoBarra(
            icone: Icons.add_rounded,
            rotulo: 'Novo pedido',
            onTap: _novoPedido,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<OracoesStore>(
        builder: (context, store, _) {
          if (store.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = _verRespondidas ? store.respondidos : store.abertos;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Alternador(
                  selecionado: _verRespondidas ? 1 : 0,
                  onSelecionar: (indice) =>
                      setState(() => _verRespondidas = indice == 1),
                  rotulos: [
                    'Em oração${store.abertos.isEmpty ? '' : '  ${store.abertos.length}'}',
                    'Respostas${store.respondidos.isEmpty ? '' : '  ${store.respondidos.length}'}',
                  ],
                ),
              ),
              Expanded(
                child: lista.isEmpty
                    ? _vazio()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, indice) {
                          final pedido = lista[indice];

                          return EntradaEscalonada(
                            indice: indice,
                            child: Dismissible(
                              key: ValueKey(pedido.id),
                              confirmDismiss: (direcao) async {
                                if (direcao == DismissDirection.startToEnd) {
                                  pedido.respondida
                                      ? _reabrir(store, pedido)
                                      : _marcarRespondida(store, pedido);
                                  // A linha não some: ela muda de lista.
                                  return false;
                                }
                                return _confirmarExclusao();
                              },
                              onDismissed: (_) => _excluir(store, pedido),
                              background: _FundoDeslize(
                                tom: context.cores.sucesso,
                                icone: pedido.respondida
                                    ? Icons.undo_rounded
                                    : Icons.check_circle_rounded,
                                rotulo: pedido.respondida
                                    ? 'Reabrir'
                                    : 'Respondida',
                                alinhamento: Alignment.centerLeft,
                              ),
                              secondaryBackground: _FundoDeslize(
                                tom: context.cores.perigo,
                                icone: Icons.delete_outline_rounded,
                                rotulo: 'Excluir',
                                alinhamento: Alignment.centerRight,
                              ),
                              child: CartaoOracao(
                                pedido: pedido,
                                onTap: () => _abrirAcoes(store, pedido),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _vazio() {
    if (_verRespondidas) {
      return const EstadoVazio(
        icone: Icons.auto_awesome_rounded,
        titulo: 'Nenhuma resposta ainda',
        descricao:
            'Quando Deus responder um pedido, marque-o na lista de oração. '
            'Ele fica guardado aqui, com a data.',
      );
    }
    return EstadoVazio(
      icone: Icons.favorite_rounded,
      titulo: 'Nenhum pedido aberto',
      descricao:
          'Anote o que a família está levando a Deus. Os pedidos abertos '
          'aparecem na hora de registrar um cultinho.',
      rotuloAcao: 'Novo pedido',
      onAcao: _novoPedido,
    );
  }
}

class _Acao extends StatelessWidget {
  const _Acao({
    required this.icone,
    required this.rotulo,
    required this.tom,
    required this.onTap,
  });

  final IconData icone;
  final String rotulo;
  final Tom tom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tom.fundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, size: 19, color: tom.cor),
            ),
            const SizedBox(width: 14),
            Text(
              rotulo,
              style: Tipo.corpoForte.copyWith(color: context.cores.texto),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundoDeslize extends StatelessWidget {
  const _FundoDeslize({
    required this.tom,
    required this.icone,
    required this.rotulo,
    required this.alinhamento,
  });

  final Tom tom;
  final IconData icone;
  final String rotulo;
  final Alignment alinhamento;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tom.fundo,
        borderRadius: BorderRadius.circular(Raio.cartao),
      ),
      alignment: alinhamento,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: tom.cor, size: 19),
          const SizedBox(width: 9),
          Text(rotulo, style: Tipo.apoioForte.copyWith(color: tom.cor)),
        ],
      ),
    );
  }
}
