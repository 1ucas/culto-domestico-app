import 'package:flutter/material.dart';

import '../theme/cores.dart';

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

    return DecoratedBox(
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
    );
  }
}

/// O bloco de marca que abre cada tela: fundo azul-noite, conteúdo em branco.
/// É onde mora o fato mais importante da página.
class CartaoDestaque extends StatelessWidget {
  const CartaoDestaque({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Material(
      color: cores.marca,
      borderRadius: BorderRadius.circular(Raio.cartao + 2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(22), child: child),
      ),
    );
  }
}
