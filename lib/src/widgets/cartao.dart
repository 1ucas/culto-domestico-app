import 'package:flutter/material.dart';

import '../theme/cores.dart';
import 'animacoes.dart';

/// A superfície padrão do app: branco, canto generoso, sombra quase invisível.
/// Tudo que é um item de lista ou um grupo de campos mora dentro de um.
class Cartao extends StatelessWidget {
  const Cartao({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(18),
    this.cor,
    this.contorno,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? cor;

  /// Contorno colorido, para marcar um cartão sem tingir o fundo inteiro.
  final Color? contorno;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final claro = Theme.of(context).brightness == Brightness.light;

    return Pressionavel(
      ativo: onTap != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Raio.cartao),
          boxShadow: claro
              ? const [
                  BoxShadow(
                    color: Color(0x0D1A1A1A),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: cor ?? cores.superficie,
          borderRadius: BorderRadius.circular(Raio.cartao),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: padding,
              decoration: contorno == null
                  ? null
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(Raio.cartao),
                      border: Border.all(color: contorno!, width: 1.5),
                    ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// O bloco que abre cada tela: uma pintura da casa à noite, escurecida do lado
/// do texto para que o conteúdo em branco continue legível por cima. Sem
/// [imagem] — ou se ela falhar ao carregar — sobra o degradê da marca, que
/// sozinho já sustenta o bloco.
class CartaoDestaque extends StatelessWidget {
  const CartaoDestaque({
    super.key,
    required this.child,
    this.onTap,
    this.imagem,
    this.alinhamentoImagem = Alignment.bottomRight,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? imagem;
  final Alignment alinhamentoImagem;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Pressionavel(
      ativo: onTap != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Raio.cartao + 2),
          boxShadow: [
            BoxShadow(
              color: cores.marca.withValues(alpha: 0.28),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(Raio.cartao + 2),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(gradient: cores.degradeMarca),
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  if (imagem != null) _Pintura(imagem!, alinhamentoImagem),
                  Padding(padding: const EdgeInsets.all(22), child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A pintura e o véu que a escurece. O véu é mais forte à esquerda e embaixo,
/// que é onde o texto do bloco mora.
class _Pintura extends StatelessWidget {
  const _Pintura(this.asset, this.alinhamento);

  final String asset;
  final Alignment alinhamento;

  @override
  Widget build(BuildContext context) {
    final marca = context.cores.marca;

    return Positioned.fill(
      child: SurgirSuave(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              alignment: alinhamento,
              // Sem a pintura o degradê da marca continua de pé sozinho.
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    marca.withValues(alpha: 0.93),
                    marca.withValues(alpha: 0.62),
                    marca.withValues(alpha: 0.16),
                  ],
                  stops: const [0, 0.55, 1],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    marca.withValues(alpha: 0.55),
                  ],
                  stops: const [0.45, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
