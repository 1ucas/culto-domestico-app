import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/formato.dart';
import '../../models/pedido_oracao.dart';
import '../../state/oracoes_store.dart';
import '../../theme/cores.dart';
import '../../theme/imagens.dart';
import '../../theme/tipografia.dart';
import '../../widgets/animacoes.dart';
import '../../widgets/campos.dart';
import '../../widgets/cartao.dart';
import '../../widgets/confirmacao.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/rotulos.dart';
import 'nova_oracao_page.dart';
import 'widgets/cartao_oracao.dart';
import 'widgets/celebracao.dart';

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

  /// A resposta não vira uma tarja: vira uma tela. Quem quiser voltar atrás
  /// desfaz de lá mesmo.
  Future<void> _marcarRespondida(
    OracoesStore store,
    PedidoOracao pedido,
  ) async {
    await store.marcarRespondida(pedido.id);
    if (!mounted) return;

    final desfez = await celebrarResposta(
      context,
      pedido.copyWith(respondidaEm: DateTime.now()),
    );
    if (desfez) await store.reabrir(pedido.id);
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
    final cores = context.cores;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 78,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'O que a família tem levado a Deus',
              style: Tipo.apoio.copyWith(color: cores.textoSuave),
            ),
            const SizedBox(height: 1),
            const Text('Orações'),
          ],
        ),
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
          if (store.vazio) {
            return EstadoVazio(
              icone: Icons.favorite_rounded,
              imagem: Imagens.vazioOracoes,
              titulo: 'Nenhum pedido ainda',
              descricao:
                  'Anote o que a família está levando a Deus. Os pedidos '
                  'abertos aparecem na hora de registrar um cultinho.',
              rotuloAcao: 'Novo pedido',
              onAcao: _novoPedido,
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                sliver: SliverList.list(
                  children: [
                    _Destaque(store: store),
                    const SizedBox(height: 20),
                    Alternador(
                      selecionado: _verRespondidas ? 1 : 0,
                      onSelecionar: (indice) =>
                          setState(() => _verRespondidas = indice == 1),
                      rotulos: [
                        'Em oração${store.abertos.isEmpty ? '' : '  ${store.abertos.length}'}',
                        'Respostas${store.respondidos.isEmpty ? '' : '  ${store.respondidos.length}'}',
                      ],
                    ),
                  ],
                ),
              ),
              if (_verRespondidas)
                ..._respostas(store)
              else
                ..._emOracao(store),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          );
        },
      ),
    );
  }

  /// Uma lista de pedidos como sliver, com o espaçamento entre cartões.
  Widget _lista(List<PedidoOracao> pedidos, OracoesStore store) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, i) => Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
          child: _Linha(
            indice: i,
            pedido: pedidos[i],
            store: store,
            pagina: this,
          ),
        ),
      ),
    );
  }

  List<Widget> _emOracao(OracoesStore store) {
    if (store.abertos.isEmpty) {
      return const [
        SliverToBoxAdapter(
          child: _AbaVazia(
            imagem: Imagens.vazioOracoes,
            titulo: 'Nada em aberto agora',
            descricao: 'Todos os pedidos foram respondidos. '
                'Quando surgir um novo, ele entra aqui.',
          ),
        ),
      ];
    }
    return [_lista(store.abertos, store)];
  }

  List<Widget> _respostas(OracoesStore store) {
    if (store.respondidos.isEmpty) {
      return const [
        SliverToBoxAdapter(
          child: _AbaVazia(
            imagem: Imagens.vazioRespostas,
            titulo: 'Nenhuma resposta ainda',
            descricao: 'Quando Deus responder um pedido, marque-o na lista de '
                'oração. Ele fica guardado aqui, com a data.',
          ),
        ),
      ];
    }

    return [
      for (final mes in store.respondidosPorMes) ...[
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: TituloSecao(
              mes.mes == null
                  ? 'Antes do registro de datas'
                  : Formato.mesAno(mes.mes!),
              acao: Micro(
                Formato.plural(mes.pedidos.length, 'resposta', 'respostas'),
              ),
            ),
          ),
        ),
        _lista(mes.pedidos, store),
        const SliverToBoxAdapter(child: SizedBox(height: 26)),
      ],
    ];
  }
}

/// Um pedido na lista, com os dois gestos: arrastar para a direita responde ou
/// reabre, para a esquerda exclui.
class _Linha extends StatelessWidget {
  const _Linha({
    required this.indice,
    required this.pedido,
    required this.store,
    required this.pagina,
  });

  final int indice;
  final PedidoOracao pedido;
  final OracoesStore store;
  final _OracoesPageState pagina;

  @override
  Widget build(BuildContext context) {
    return EntradaEscalonada(
      indice: indice,
      child: Dismissible(
        key: ValueKey(pedido.id),
        confirmDismiss: (direcao) async {
          if (direcao == DismissDirection.startToEnd) {
            pedido.respondida
                ? pagina._reabrir(store, pedido)
                : pagina._marcarRespondida(store, pedido);
            // A linha não some: ela muda de lista.
            return false;
          }
          return pagina._confirmarExclusao();
        },
        onDismissed: (_) => pagina._excluir(store, pedido),
        background: _FundoDeslize(
          tom: context.cores.sucesso,
          icone: pedido.respondida
              ? Icons.undo_rounded
              : Icons.check_circle_rounded,
          rotulo: pedido.respondida ? 'Reabrir' : 'Respondida',
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
          onTap: () => pagina._abrirAcoes(store, pedido),
        ),
      ),
    );
  }
}

/// O bloco de marca da tela: quantos pedidos estão de pé e quantas respostas
/// já chegaram.
class _Destaque extends StatelessWidget {
  const _Destaque({required this.store});

  final OracoesStore store;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final sobreMarca = cores.marcaConteudo;
    final abertos = store.abertos.length;

    return CartaoDestaque(
      imagem: Imagens.heroOracoes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Micro('Lista de oração', cor: sobreMarca.withValues(alpha: 0.65)),
          const SizedBox(height: 10),
          Text(
            abertos == 0
                ? 'Tudo respondido'
                : Formato.plural(abertos, 'pedido', 'pedidos'),
            style: Tipo.display.copyWith(color: sobreMarca),
          ),
          const SizedBox(height: 8),
          Text(
            abertos == 0
                ? 'Nenhum pedido em aberto por enquanto'
                : 'em oração agora',
            style:
                Tipo.corpo.copyWith(color: sobreMarca.withValues(alpha: 0.8)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: 1,
              color: sobreMarca.withValues(alpha: 0.18),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _Estatistica(
                  rotulo: 'Respondidas',
                  valor: '${store.respondidos.length}',
                ),
              ),
              Expanded(
                child: _Estatistica(
                  rotulo: 'Neste mês',
                  valor: '${store.respondidasNoMes}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Estatistica extends StatelessWidget {
  const _Estatistica({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final sobreMarca = context.cores.marcaConteudo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Micro(rotulo, cor: sobreMarca.withValues(alpha: 0.65)),
        const SizedBox(height: 6),
        Text(valor, style: Tipo.corpoForte.copyWith(color: sobreMarca)),
      ],
    );
  }
}

/// Aba sem itens quando a outra tem. Menor que o [EstadoVazio] de tela cheia,
/// porque aqui o bloco de destaque já deu o contexto.
class _AbaVazia extends StatelessWidget {
  const _AbaVazia({
    required this.imagem,
    required this.titulo,
    required this.descricao,
  });

  final String imagem;
  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        children: [
          SurgirSuave(
            child: Container(
              width: 128,
              height: 128,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: cores.marca.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                imagem,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: Tipo.secao.copyWith(color: cores.texto),
          ),
          const SizedBox(height: 8),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: Tipo.apoio.copyWith(color: cores.textoSuave),
          ),
        ],
      ),
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
