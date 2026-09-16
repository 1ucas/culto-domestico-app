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

/// Encolhe de leve enquanto o dedo está em cima. É o retorno tátil que o
/// `InkWell` sozinho não dá num cartão grande.
class Pressionavel extends StatefulWidget {
  const Pressionavel({super.key, required this.child, this.ativo = true});

  final Widget child;

  /// Falso quando o cartão não é tocável — aí não há o que responder.
  final bool ativo;

  @override
  State<Pressionavel> createState() => _PressionavelState();
}

class _PressionavelState extends State<Pressionavel> {
  bool _pressionado = false;

  void _marcar(bool valor) {
    if (_pressionado != valor) setState(() => _pressionado = valor);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.ativo || MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return Listener(
      onPointerDown: (_) => _marcar(true),
      onPointerUp: (_) => _marcar(false),
      onPointerCancel: (_) => _marcar(false),
      child: AnimatedScale(
        scale: _pressionado ? 0.978 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Aparece com um leve zoom de dentro para fora. Usado nas pinturas dos blocos
/// de destaque, para a tela não nascer estática.
class SurgirSuave extends StatelessWidget {
  const SurgirSuave({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, filho) => Opacity(
        opacity: t,
        child: Transform.scale(scale: 1.06 - 0.06 * t, child: filho),
      ),
      child: child,
    );
  }
}
