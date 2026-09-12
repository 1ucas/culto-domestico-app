import 'package:flutter/material.dart';

import '../../../data/formato.dart';
import '../../../models/pedido_oracao.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/cartao.dart';
import '../../../widgets/chips.dart';
import '../../../widgets/glifos.dart';

/// Um pedido na lista. Aberto, o ícone vem no tom da severidade e as etiquetas
/// dizem peso e assunto; respondido, tudo passa para o verde e a etiqueta
/// carrega a data da resposta.
class CartaoOracao extends StatelessWidget {
  const CartaoOracao({super.key, required this.pedido, this.onTap});

  final PedidoOracao pedido;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final respondida = pedido.respondida;
    final tom = respondida
        ? cores.sucesso
        : Glifos.daSeveridade(context, pedido.severidade);

    return Cartao(
      onTap: onTap,
      contorno: respondida ? cores.sucesso.cor.withValues(alpha: 0.3) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChipIcone(icone: Glifos.daCategoria(pedido.categoria), tom: tom),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pedido.texto,
                  style: Tipo.corpoForte.copyWith(color: cores.texto),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: respondida
                      ? [
                          Pilula(
                            texto: _textoResposta(),
                            tom: cores.sucesso,
                            icone: Icons.check_circle_rounded,
                          ),
                          Pilula(
                            texto: pedido.categoria.nome,
                            tom: Tom(cores.textoSuave, cores.superficieAlt),
                          ),
                        ]
                      : [
                          Pilula(texto: pedido.severidade.nome, tom: tom),
                          Pilula(
                            texto: pedido.categoria.nome,
                            tom: Tom(cores.textoSuave, cores.superficieAlt),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _textoResposta() {
    final quando = pedido.respondidaEm!;
    // Pedidos migrados da v1 não guardaram a data da resposta.
    if (quando.millisecondsSinceEpoch == 0) return 'Respondida';
    return 'Respondida em ${Formato.compacta(quando)}';
  }
}
