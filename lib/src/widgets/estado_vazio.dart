import 'package:flutter/material.dart';

import '../theme/cores.dart';
import '../theme/tipografia.dart';
import 'animacoes.dart';

/// Tela vazia como convite: uma pintura da cena que ainda não aconteceu, o que
/// essa página guarda e o botão que a preenche.
class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.imagem,
    this.rotuloAcao,
    this.onAcao,
  });

  final IconData icone;
  final String titulo;
  final String descricao;

  /// A pintura da tela vazia. Sem ela, ou se ela falhar, sobra o [icone] num
  /// quadrado tonal.
  final String? imagem;

  final String? rotuloAcao;
  final VoidCallback? onAcao;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagem != null)
              SurgirSuave(child: _Pintura(imagem!, icone: icone))
            else
              _Glifo(icone),
            const SizedBox(height: 26),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Tipo.displayMedio.copyWith(color: cores.texto),
            ),
            const SizedBox(height: 10),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: Tipo.corpo.copyWith(color: cores.textoSuave),
            ),
            if (rotuloAcao != null && onAcao != null) ...[
              const SizedBox(height: 26),
              FilledButton(onPressed: onAcao, child: Text(rotuloAcao!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pintura extends StatelessWidget {
  const _Pintura(this.asset, {required this.icone});

  final String asset;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Container(
      width: 176,
      height: 176,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: cores.marca.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cores.marca.withValues(alpha: 0.12)),
      ),
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _Glifo(icone),
      ),
    );
  }
}

class _Glifo extends StatelessWidget {
  const _Glifo(this.icone);

  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: cores.marcaTom.fundo,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(icone, size: 32, color: cores.marcaTom.cor),
    );
  }
}
