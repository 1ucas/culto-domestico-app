import 'package:flutter/material.dart';

/// Entrada escalonada das linhas: cada uma sobe 8px e aparece, 40ms depois da
/// anterior. Some inteira quando o sistema pede menos movimento.
class EntradaEscalonada extends StatelessWidget {
  const EntradaEscalonada({
    super.key,
    required this.indice,
    required this.child,
  });

  final int indice;
  final Widget child;

  static const _maxEscalonado = 8;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    final atraso = Duration(milliseconds: 40 * indice.clamp(0, _maxEscalonado));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 340) + atraso,
      curve: Interval(
        atraso.inMilliseconds / (340 + atraso.inMilliseconds),
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, t, filho) => Opacity(
        opacity: t,
        child:
            Transform.translate(offset: Offset(0, 8 * (1 - t)), child: filho),
      ),
      child: child,
    );
  }
}
