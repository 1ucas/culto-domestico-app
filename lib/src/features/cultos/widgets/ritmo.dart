import 'package:flutter/material.dart';

import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/cartao.dart';
import '../../../widgets/chips.dart';

/// As últimas semanas como barrinhas: acesa a semana em que houve cultinho,
/// apagada a que passou em branco.
///
/// O texto embaixo nunca cobra. A semana em curso não conta contra ninguém, e
/// quando o ritmo se perdeu o cartão convida de volta em vez de acusar.
class CartaoRitmo extends StatelessWidget {
  const CartaoRitmo({
    super.key,
    required this.semanas,
    required this.seguidas,
  });

  /// Da semana mais antiga para a atual.
  final List<bool> semanas;
  final int seguidas;

  String get _legenda {
    if (seguidas >= 2) return '$seguidas semanas seguidas de cultinho.';
    if (seguidas == 1) return 'Uma semana com cultinho. Bom recomeço.';
    return 'Faz um tempo desde o último. Um recomeço cabe hoje.';
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ritmo da família',
                  style: Tipo.cartaoTitulo.copyWith(color: cores.texto),
                ),
              ),
              if (seguidas >= 2)
                Pilula(
                  icone: Icons.local_fire_department_rounded,
                  texto: '$seguidas semanas',
                  tom: cores.acento,
                ),
            ],
          ),
          const SizedBox(height: 18),
          Semantics(
            label: 'Últimas ${semanas.length} semanas, '
                '${semanas.where((s) => s).length} com cultinho',
            child: ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < semanas.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: _Semana(
                        acesa: semanas[i],
                        atual: i == semanas.length - 1,
                        indice: i,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${semanas.length} semanas atrás',
                style: Tipo.micro.copyWith(color: cores.textoSuave),
              ),
              Text(
                'ESTA SEMANA',
                style: Tipo.micro.copyWith(color: cores.textoSuave),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(_legenda, style: Tipo.apoio.copyWith(color: cores.textoSuave)),
        ],
      ),
    );
  }
}

class _Semana extends StatelessWidget {
  const _Semana({
    required this.acesa,
    required this.atual,
    required this.indice,
  });

  final bool acesa;
  final bool atual;
  final int indice;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final parada = MediaQuery.disableAnimationsOf(context);

    final barra = Container(
      height: 38,
      decoration: BoxDecoration(
        color: acesa ? cores.acento.cor : cores.vago,
        borderRadius: BorderRadius.circular(9),
        border: atual && !acesa
            ? Border.all(color: cores.acento.cor.withValues(alpha: 0.45))
            : null,
      ),
    );

    if (parada) return barra;

    // Cada semana sobe depois da anterior, da mais antiga para a atual.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + 60 * indice),
      curve: Curves.easeOutBack,
      builder: (context, t, filho) => Align(
        alignment: Alignment.bottomCenter,
        child: Transform.scale(scaleY: t.clamp(0.08, 1), child: filho),
      ),
      child: barra,
    );
  }
}
