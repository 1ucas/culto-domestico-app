import 'package:flutter/material.dart';

import '../theme/cores.dart';
import '../theme/tipografia.dart';

/// Ícone dentro de um quadrado tonal arredondado. A cor do tom diz o estado; o
/// ícone diz o assunto.
class ChipIcone extends StatelessWidget {
  const ChipIcone({
    super.key,
    required this.icone,
    required this.tom,
    this.tamanho = 44,
  });

  final IconData icone;
  final Tom tom;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        color: tom.fundo,
        borderRadius: BorderRadius.circular(Raio.chip),
      ),
      child: Icon(icone, size: tamanho * 0.46, color: tom.cor),
    );
  }
}

/// Etiqueta tonal: severidade, categoria, "Respondida".
class Pilula extends StatelessWidget {
  const Pilula({super.key, required this.texto, required this.tom, this.icone});

  final String texto;
  final Tom tom;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(icone == null ? 11 : 8, 5, 11, 6),
      decoration: BoxDecoration(
        color: tom.fundo,
        borderRadius: BorderRadius.circular(Raio.pilula),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 13, color: tom.cor),
            const SizedBox(width: 5),
          ],
          Text(texto, style: Tipo.pilula.copyWith(color: tom.cor)),
        ],
      ),
    );
  }
}

/// O quadrado com o dia e o mês, na frente de cada cultinho do histórico.
class ChipData extends StatelessWidget {
  const ChipData({super.key, required this.dia, required this.mes});

  final String dia;
  final String mes;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Container(
      width: 52,
      height: 56,
      decoration: BoxDecoration(
        color: cores.marcaTom.fundo,
        borderRadius: BorderRadius.circular(Raio.chip),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dia,
            style: Tipo.cartaoTitulo.copyWith(
              color: cores.marcaTom.cor,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            mes,
            style: Tipo.micro.copyWith(
              color: cores.marcaTom.cor.withValues(alpha: 0.75),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
