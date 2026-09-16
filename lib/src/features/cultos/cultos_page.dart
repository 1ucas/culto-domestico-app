import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/formato.dart';
import '../../models/culto.dart';
import '../../state/cultos_store.dart';
import '../../theme/cores.dart';
import '../../theme/imagens.dart';
import '../../theme/tipografia.dart';
import '../../widgets/animacoes.dart';
import '../../widgets/cartao.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/rotulos.dart';
import 'culto_detalhe_page.dart';
import 'novo_culto_page.dart';
import 'widgets/cartao_culto.dart';
import 'widgets/jornada.dart';
import 'widgets/ritmo.dart';

class CultosPage extends StatelessWidget {
  const CultosPage({super.key});

  Future<void> _novoCultinho(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NovoCultoPage()),
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
              Formato.saudacao(),
              style: Tipo.apoio.copyWith(color: cores.textoSuave),
            ),
            const SizedBox(height: 1),
            const Text('Cultinhos'),
          ],
        ),
        actions: [
          BotaoBarra(
            icone: Icons.add_rounded,
            rotulo: 'Registrar cultinho',
            onTap: () => _novoCultinho(context),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<CultosStore>(
        builder: (context, store, _) {
          if (store.carregando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (store.vazio) {
            return EstadoVazio(
              icone: Icons.menu_book_rounded,
              imagem: Imagens.vazioCultos,
              titulo: 'Nenhum cultinho ainda',
              descricao:
                  'Registre o primeiro e o histórico começa: a data, a leitura '
                  'e quem orou naquela noite.',
              rotuloAcao: 'Registrar cultinho',
              onAcao: () => _novoCultinho(context),
            );
          }
          return _Historico(store: store);
        },
      ),
    );
  }
}

class _Historico extends StatelessWidget {
  const _Historico({required this.store});

  final CultosStore store;

  void _abrir(BuildContext context, Culto culto) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CultoDetalhePage(culto: culto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return RefreshIndicator(
      onRefresh: store.carregar,
      color: cores.marcaTom.cor,
      backgroundColor: cores.superficie,
      // Slivers, e não uma lista de filhos: o histórico cresce a cada semana e
      // os meses antigos não precisam ser construídos para a tela abrir.
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            sliver: SliverList.list(
              children: [
                _Destaque(
                  ultimo: store.cultos.first,
                  store: store,
                  onTap: () => _abrir(context, store.cultos.first),
                ),
                const SizedBox(height: 12),
                CartaoRitmo(
                  semanas: store.ritmo,
                  seguidas: store.semanasSeguidas,
                ),
                const SizedBox(height: 12),
                CartaoJornada(cultosPorLivro: store.cultosPorLivro),
              ],
            ),
          ),
          for (final mes in store.porMes) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: TituloSecao(
                  Formato.mesAno(mes.mes),
                  acao: Micro(
                    Formato.plural(mes.cultos.length, 'cultinho', 'cultinhos'),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
              sliver: SliverList.builder(
                itemCount: mes.cultos.length,
                itemBuilder: (context, i) => Padding(
                  padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
                  child: EntradaEscalonada(
                    indice: i,
                    child: CartaoCulto(
                      culto: mes.cultos[i],
                      onTap: () => _abrir(context, mes.cultos[i]),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Espaço para a barra flutuante não cobrir o último cartão.
          const SliverToBoxAdapter(child: SizedBox(height: 84)),
        ],
      ),
    );
  }
}

/// O bloco de marca: o cultinho mais recente, sob a pintura da sala à noite.
class _Destaque extends StatelessWidget {
  const _Destaque({
    required this.ultimo,
    required this.store,
    required this.onTap,
  });

  final Culto ultimo;
  final CultosStore store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final sobreMarca = cores.marcaConteudo;
    final leitura = ultimo.leitura;

    return CartaoDestaque(
      onTap: onTap,
      imagem: Imagens.heroCultos,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Micro('Último cultinho', cor: sobreMarca.withValues(alpha: 0.65)),
          const SizedBox(height: 10),
          Text(
            leitura?.referencia ?? 'Sem leitura anotada',
            style: Tipo.display.copyWith(color: sobreMarca),
          ),
          const SizedBox(height: 8),
          Text(
            [
              Formato.diaEMes(ultimo.data),
              if (ultimo.quemOrou.trim().isNotEmpty)
                'orou ${ultimo.quemOrou.trim()}',
            ].join(' · '),
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
                  rotulo: 'No histórico',
                  valor: Formato.plural(
                    store.cultos.length,
                    'cultinho',
                    'cultinhos',
                  ),
                ),
              ),
              Expanded(
                child: _Estatistica(
                  rotulo: 'Neste mês',
                  valor: Formato.plural(store.totalNoMes, 'vez', 'vezes'),
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
