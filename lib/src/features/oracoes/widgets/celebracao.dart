import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/formato.dart';
import '../../../models/pedido_oracao.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';

/// Marcar um pedido como respondido é o momento mais importante do app. Em vez
/// de uma tarja que some em três segundos, a tela inteira para: o pedido volta
/// a ser lido, com a data, sob luzinhas subindo.
///
/// Devolve `true` se a pessoa pediu para desfazer.
Future<bool> celebrarResposta(
  BuildContext context,
  PedidoOracao pedido,
) async {
  final desfez = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fechar',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => _Celebracao(pedido: pedido),
    transitionBuilder: (context, animacao, _, filho) => FadeTransition(
      opacity: CurvedAnimation(parent: animacao, curve: Curves.easeOut),
      child: filho,
    ),
  );
  return desfez ?? false;
}

class _Celebracao extends StatefulWidget {
  const _Celebracao({required this.pedido});

  final PedidoOracao pedido;

  @override
  State<_Celebracao> createState() => _CelebracaoState();
}

class _CelebracaoState extends State<_Celebracao>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  )..repeat();

  /// Sorteadas uma vez: repintar não pode reembaralhar as luzes.
  late final List<_Luz> _luzes = _Luz.sortear(28);

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    final sobreMarca = cores.marcaConteudo;
    final parado = MediaQuery.disableAnimationsOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: cores.marca,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Material(
        color: cores.marca,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.15),
                  radius: 1.1,
                  colors: [
                    Color.lerp(cores.marca, cores.acento.cor, 0.22)!,
                    cores.marca,
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controle,
              builder: (context, _) => CustomPaint(
                painter: _PinturaDeLuzes(
                  avanco: parado ? 0.5 : _controle.value,
                  cor: cores.acento.cor,
                  luzes: _luzes,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Selo(cor: cores.acento.cor, parado: parado),
                    const SizedBox(height: 28),
                    Text(
                      'Deus respondeu',
                      textAlign: TextAlign.center,
                      style: Tipo.display.copyWith(color: sobreMarca),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      widget.pedido.texto,
                      textAlign: TextAlign.center,
                      style: Tipo.corpo.copyWith(
                        color: sobreMarca.withValues(alpha: 0.85),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      Formato.completa(
                        widget.pedido.respondidaEm ?? DateTime.now(),
                      ),
                      style: Tipo.micro.copyWith(
                        color: sobreMarca.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 44),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: sobreMarca,
                        foregroundColor: cores.marca,
                        minimumSize: const Size(190, 54),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Amém'),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: sobreMarca.withValues(alpha: 0.7),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Ainda não — desfazer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// O círculo com o visto, que cresce uma vez quando a tela abre.
class _Selo extends StatelessWidget {
  const _Selo({required this.cor, required this.parado});

  final Color cor;
  final bool parado;

  @override
  Widget build(BuildContext context) {
    final selo = Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cor.withValues(alpha: 0.18),
        border: Border.all(color: cor.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Icon(Icons.check_rounded, size: 40, color: cor),
    );

    if (parado) return selo;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutBack,
      builder: (context, t, filho) =>
          Transform.scale(scale: t.clamp(0, 1.3), child: filho),
      child: selo,
    );
  }
}

/// Uma luzinha subindo: onde nasce, quanto mede, quão rápido sobe e o quanto
/// vagueia para os lados no caminho.
class _Luz {
  const _Luz({
    required this.x,
    required this.raio,
    required this.velocidade,
    required this.fase,
    required this.deriva,
  });

  final double x;
  final double raio;
  final double velocidade;
  final double fase;
  final double deriva;

  static List<_Luz> sortear(int quantidade) {
    final sorte = math.Random(7);
    return [
      for (var i = 0; i < quantidade; i++)
        _Luz(
          x: sorte.nextDouble(),
          raio: 1.1 + sorte.nextDouble() * 2.6,
          velocidade: 0.45 + sorte.nextDouble() * 0.85,
          fase: sorte.nextDouble(),
          deriva: 0.015 + sorte.nextDouble() * 0.05,
        ),
    ];
  }
}

class _PinturaDeLuzes extends CustomPainter {
  _PinturaDeLuzes({
    required this.avanco,
    required this.cor,
    required this.luzes,
  });

  final double avanco;
  final Color cor;
  final List<_Luz> luzes;

  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()..style = PaintingStyle.fill;

    for (final luz in luzes) {
      // Cada luz percorre o seu próprio ciclo, deslocado pela fase.
      final subida = (avanco * luz.velocidade + luz.fase) % 1;
      final y = size.height * (1.05 - subida * 1.1);
      final x = size.width *
          (luz.x + math.sin(subida * math.pi * 2 + luz.fase * 6) * luz.deriva);

      // Nasce e morre sem piscar: opacidade em meia onda.
      pincel.color = cor.withValues(alpha: math.sin(subida * math.pi) * 0.75);
      canvas.drawCircle(Offset(x, y), luz.raio, pincel);
    }
  }

  @override
  bool shouldRepaint(_PinturaDeLuzes anterior) =>
      anterior.avanco != avanco || anterior.cor != cor;
}
