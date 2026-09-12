import 'package:flutter/material.dart';

import '../../../data/formato.dart';
import '../../../models/culto.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/cartao.dart';
import '../../../widgets/chips.dart';
import '../../../widgets/glifos.dart';

/// Um cultinho na lista do histórico.
class CartaoCulto extends StatelessWidget {
  const CartaoCulto({super.key, required this.culto, this.onTap});

  final Culto culto;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final leitura = culto.leitura;
    final pedidos = culto.pedidosPorCategoria;
    final neutro = Tom(cores.textoSuave, cores.superficieAlt);

    return Cartao(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChipData(dia: Formato.dia(culto.data), mes: Formato.mes(culto.data)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leitura?.referencia ?? 'Sem leitura anotada',
                  style: Tipo.cartaoTitulo.copyWith(
                    color: leitura != null ? cores.texto : cores.textoSuave,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  culto.quemOrou.trim().isEmpty
                      ? 'Sem registro de quem orou'
                      : 'Orou ${culto.quemOrou.trim()}',
                  style: Tipo.apoio.copyWith(color: cores.textoSuave),
                ),
                if (pedidos.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final entrada in pedidos.entries)
                        Pilula(
                          icone: Glifos.daCategoria(entrada.key),
                          texto: '${entrada.value}',
                          tom: neutro,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 6),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: cores.textoSuave,
            ),
          ),
        ],
      ),
    );
  }
}
