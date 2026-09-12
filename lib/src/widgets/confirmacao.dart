import 'package:flutter/material.dart';

import '../theme/cores.dart';

/// Diálogo de confirmação padrão. Existe uma vez só para que toda decisão
/// destrutiva do app pergunte da mesma forma.
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  required String acao,
  String manter = 'Manter',
  bool destrutiva = false,
}) async {
  final cores = context.cores;

  final resposta = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(false),
          style: TextButton.styleFrom(foregroundColor: cores.textoSuave),
          child: Text(manter),
        ),
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: destrutiva ? cores.perigo.cor : cores.marcaTom.cor,
          ),
          child: Text(acao),
        ),
      ],
    ),
  );
  return resposta ?? false;
}
