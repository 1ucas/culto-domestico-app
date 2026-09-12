import 'package:flutter/material.dart';

import '../theme/cores.dart';
import '../theme/tipografia.dart';

/// Tela vazia como convite: o que essa página guarda e o botão que a preenche.
class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.rotuloAcao,
    this.onAcao,
  });

  final IconData icone;
  final String titulo;
  final String descricao;
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
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cores.marcaTom.fundo,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icone, size: 32, color: cores.marcaTom.cor),
            ),
            const SizedBox(height: 22),
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
