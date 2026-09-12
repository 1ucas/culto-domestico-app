import 'package:flutter/material.dart';

import '../theme/cores.dart';
import '../theme/tipografia.dart';
import 'cartao.dart';

/// Linha de formulário que abre um seletor em vez de aceitar digitação:
/// rótulo à esquerda, valor à direita, seta indicando que há mais. Com
/// [rotulo] vazio o valor ocupa a linha toda — para quando o título da seção
/// já nomeia o campo.
class LinhaSeletor extends StatelessWidget {
  const LinhaSeletor({
    super.key,
    required this.rotulo,
    required this.onTap,
    this.valor,
    this.vazio,
  });

  final String rotulo;
  final VoidCallback onTap;
  final String? valor;
  final String? vazio;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final preenchido = valor != null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: [
            if (rotulo.isNotEmpty) ...[
              Text(rotulo, style: Tipo.corpo.copyWith(color: cores.textoSuave)),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                preenchido ? valor! : (vazio ?? ''),
                textAlign: rotulo.isEmpty ? TextAlign.left : TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: Tipo.corpoForte.copyWith(
                  color: preenchido ? cores.texto : cores.textoSuave,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: cores.textoSuave,
            ),
          ],
        ),
      ),
    );
  }
}

/// Agrupa linhas de formulário num único cartão, separadas por filetes.
class GrupoCampos extends StatelessWidget {
  const GrupoCampos({super.key, required this.linhas});

  final List<Widget> linhas;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Cartao(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < linhas.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Container(height: 1, color: cores.borda),
              ),
            linhas[i],
          ],
        ],
      ),
    );
  }
}

/// Opção selecionável em forma de pílula, com ícone opcional.
class OpcaoPilula extends StatelessWidget {
  const OpcaoPilula({
    super.key,
    required this.rotulo,
    required this.selecionada,
    required this.onTap,
    this.icone,
    this.tom,
  });

  final String rotulo;
  final bool selecionada;
  final VoidCallback onTap;
  final IconData? icone;

  /// Quando presente, a opção selecionada usa este tom em vez do da marca.
  final Tom? tom;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final ativo = tom ?? cores.marcaTom;
    final cor = selecionada ? ativo.cor : cores.textoSuave;

    return Material(
      color: selecionada ? ativo.fundo : cores.superficie,
      borderRadius: BorderRadius.circular(Raio.pilula),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(icone == null ? 16 : 13, 11, 16, 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Raio.pilula),
            border: Border.all(
              color:
                  selecionada ? ativo.cor.withValues(alpha: 0.35) : cores.borda,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icone != null) ...[
                Icon(icone, size: 16, color: cor),
                const SizedBox(width: 7),
              ],
              Text(rotulo, style: Tipo.apoioForte.copyWith(color: cor)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alternador de duas listas: pílula branca com o lado ativo pintado da marca.
class Alternador extends StatelessWidget {
  const Alternador({
    super.key,
    required this.rotulos,
    required this.selecionado,
    required this.onSelecionar,
  });

  final List<String> rotulos;
  final int selecionado;
  final ValueChanged<int> onSelecionar;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: cores.superficie,
        borderRadius: BorderRadius.circular(Raio.pilula),
        border: Border.all(color: cores.borda),
      ),
      child: Row(
        children: [
          for (var i = 0; i < rotulos.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onSelecionar(i),
                borderRadius: BorderRadius.circular(Raio.pilula),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: i == selecionado ? cores.marca : Colors.transparent,
                    borderRadius: BorderRadius.circular(Raio.pilula),
                  ),
                  child: Text(
                    rotulos[i],
                    textAlign: TextAlign.center,
                    style: Tipo.apoioForte.copyWith(
                      color: i == selecionado
                          ? cores.marcaConteudo
                          : cores.textoSuave,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
