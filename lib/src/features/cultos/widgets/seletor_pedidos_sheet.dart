import 'package:flutter/material.dart';

import '../../../models/pedido_oracao.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/cartao.dart';
import '../../../widgets/chips.dart';
import '../../../widgets/glifos.dart';

/// Marca quais pedidos abertos a família levou neste cultinho.
Future<List<PedidoOracao>?> escolherPedidos(
  BuildContext context, {
  required List<PedidoOracao> disponiveis,
  required List<PedidoOracao> jaEscolhidos,
}) {
  return showModalBottomSheet<List<PedidoOracao>>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
    ),
    builder: (_) => _SeletorPedidos(
      disponiveis: disponiveis,
      jaEscolhidos: jaEscolhidos,
    ),
  );
}

class _SeletorPedidos extends StatefulWidget {
  const _SeletorPedidos(
      {required this.disponiveis, required this.jaEscolhidos});

  final List<PedidoOracao> disponiveis;
  final List<PedidoOracao> jaEscolhidos;

  @override
  State<_SeletorPedidos> createState() => _SeletorPedidosState();
}

class _SeletorPedidosState extends State<_SeletorPedidos> {
  late final Set<String> _marcados = {
    for (final pedido in widget.jaEscolhidos) pedido.id,
  };

  bool get _todosMarcados =>
      widget.disponiveis.isNotEmpty &&
      _marcados.length == widget.disponiveis.length;

  void _alternar(PedidoOracao pedido) {
    setState(() {
      _marcados.contains(pedido.id)
          ? _marcados.remove(pedido.id)
          : _marcados.add(pedido.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pedidos de hoje',
                    style: Tipo.secao.copyWith(color: cores.texto),
                  ),
                ),
                if (widget.disponiveis.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() {
                      if (_todosMarcados) {
                        _marcados.clear();
                      } else {
                        _marcados
                          ..clear()
                          ..addAll(widget.disponiveis.map((p) => p.id));
                      }
                    }),
                    child: Text(_todosMarcados ? 'Limpar' : 'Marcar todos'),
                  ),
              ],
            ),
          ),
          if (widget.disponiveis.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              child: Text(
                'Nenhum pedido aberto no momento. Anote pedidos na aba Orações '
                'para levá-los ao próximo cultinho.',
                style: Tipo.corpo.copyWith(color: cores.textoSuave),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: widget.disponiveis.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, indice) {
                  final pedido = widget.disponiveis[indice];
                  final marcado = _marcados.contains(pedido.id);
                  final tom = Glifos.daSeveridade(context, pedido.severidade);

                  return Cartao(
                    onTap: () => _alternar(pedido),
                    contorno: marcado ? cores.marcaTom.cor : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChipIcone(
                          icone: Glifos.daCategoria(pedido.categoria),
                          tom: tom,
                          tamanho: 40,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pedido.texto,
                                style: Tipo.corpoForte.copyWith(
                                  color: cores.texto,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Pilula(texto: pedido.severidade.nome, tom: tom),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          marcado
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 24,
                          color:
                              marcado ? cores.marcaTom.cor : cores.textoSuave,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(
                widget.disponiveis
                    .where((pedido) => _marcados.contains(pedido.id))
                    .toList(),
              ),
              child: Text(
                _marcados.isEmpty
                    ? 'Seguir sem pedidos'
                    : 'Levar ${_marcados.length} '
                        '${_marcados.length == 1 ? 'pedido' : 'pedidos'}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
