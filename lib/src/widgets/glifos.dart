import 'package:flutter/material.dart';

import '../models/pedido_oracao.dart';
import '../theme/cores.dart';

/// Um ícone por categoria e um tom por severidade: o ícone diz o assunto, o tom
/// diz o peso.
abstract final class Glifos {
  static IconData daCategoria(Categoria categoria) => switch (categoria) {
        Categoria.saude => Icons.healing_rounded,
        Categoria.profissional => Icons.work_rounded,
        Categoria.pessoal => Icons.person_rounded,
        Categoria.casa => Icons.home_rounded,
        Categoria.relacionamento => Icons.favorite_rounded,
        Categoria.outro => Icons.auto_awesome_rounded,
      };

  static Tom daSeveridade(BuildContext context, Severidade severidade) {
    final cores = context.cores;
    return switch (severidade) {
      Severidade.agradecimento => cores.agradecimento,
      Severidade.normal => cores.normal,
      Severidade.importante => cores.importante,
      Severidade.urgente => cores.urgente,
    };
  }
}
