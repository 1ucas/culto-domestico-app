import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/formato.dart';
import '../../models/culto.dart';
import '../../state/cultos_store.dart';
import '../../theme/cores.dart';
import '../../theme/tipografia.dart';
import '../../widgets/animacoes.dart';
import '../../widgets/cartao.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/rotulos.dart';
import 'culto_detalhe_page.dart';
import 'novo_culto_page.dart';
import 'widgets/cartao_culto.dart';

class CultosPage extends StatelessWidget {
  const CultosPage({super.key});

  Future<void> _novoCultinho(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NovoCultoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultinhos'),
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
              titulo: 'Nenhum cultinho ainda',
              descricao:
                  'Registre o primeiro e o histórico começa: a data, a leitura '
                  'e quem orou naquela noite.',
              rotuloAcao: 'Registrar cultinho',
              onAcao: () => _novoCultinho(context),
            );
          }
          return _Historico(cultos: store.cultos, store: store);
        },
      ),
    );
  }
}

class _Historico extends StatelessWidget {
  const _Historico({required this.cultos, required this.store});

  final List<Culto> cultos;
  final CultosStore store;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return RefreshIndicator(
      onRefresh: store.carregar,
      color: cores.marcaTom.cor,
      backgroundColor: cores.superficie,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
        itemCount: cultos.length + 2,
        separatorBuilder: (_, indice) =>
            SizedBox(height: indice == 0 ? 26 : 10),
        itemBuilder: (context, indice) {
          if (indice == 0) {
            return _Destaque(ultimo: cultos.first, store: store);
          }
          if (indice == 1) return const TituloSecao('Histórico');

          final culto = cultos[indice - 2];
          return EntradaEscalonada(
            indice: indice - 2,
            child: CartaoCulto(
              culto: culto,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CultoDetalhePage(culto: culto),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// O bloco de marca: o cultinho mais recente e o quanto a família tem se
/// reunido.
class _Destaque extends StatelessWidget {
  const _Destaque({required this.ultimo, required this.store});

  final Culto ultimo;
  final CultosStore store;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final sobreMarca = cores.marcaConteudo;
    final leitura = ultimo.leitura;

    return CartaoDestaque(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CultoDetalhePage(culto: ultimo),
        ),
      ),
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
