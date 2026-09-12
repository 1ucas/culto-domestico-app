import 'package:flutter/material.dart';

import '../theme/cores.dart';
import '../theme/tipografia.dart';

class ItemNav {
  const ItemNav(
      {required this.icone, required this.iconeAtivo, required this.rotulo});

  final IconData icone;
  final IconData iconeAtivo;
  final String rotulo;
}

/// Barra flutuante: uma pílula branca por cima do conteúdo, com a aba ativa
/// destacada por uma pílula tonal.
class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({
    super.key,
    required this.itens,
    required this.selecionado,
    required this.onSelecionar,
  });

  final List<ItemNav> itens;
  final int selecionado;
  final ValueChanged<int> onSelecionar;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final claro = Theme.of(context).brightness == Brightness.light;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: cores.superficie,
          borderRadius: BorderRadius.circular(Raio.pilula),
          border: claro ? null : Border.all(color: cores.borda),
          boxShadow: claro
              ? const [
                  BoxShadow(
                    color: Color(0x1A1A1A1A),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            for (var i = 0; i < itens.length; i++)
              Expanded(
                child: _Item(
                  item: itens[i],
                  ativo: i == selecionado,
                  onTap: () => onSelecionar(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.item, required this.ativo, required this.onTap});

  final ItemNav item;
  final bool ativo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final cor = ativo ? cores.marcaTom.cor : cores.textoSuave;

    return Semantics(
      button: true,
      selected: ativo,
      label: item.rotulo,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Raio.pilula),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: ativo ? cores.marcaTom.fundo : Colors.transparent,
            borderRadius: BorderRadius.circular(Raio.pilula),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ativo ? item.iconeAtivo : item.icone, size: 20, color: cor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  item.rotulo,
                  overflow: TextOverflow.ellipsis,
                  style: Tipo.apoioForte.copyWith(color: cor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
