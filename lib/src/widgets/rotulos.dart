import 'package:flutter/material.dart';

import '../theme/cores.dart';
import '../theme/tipografia.dart';

/// Rótulo miúdo em caixa alta, sempre logo acima do valor que ele nomeia.
class Micro extends StatelessWidget {
  const Micro(this.texto, {super.key, this.cor});

  final String texto;
  final Color? cor;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: Tipo.micro.copyWith(color: cor ?? context.cores.textoSuave),
    );
  }
}

/// Cabeçalho entre blocos da página.
class TituloSecao extends StatelessWidget {
  const TituloSecao(this.texto, {super.key, this.acao});

  final String texto;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: Tipo.secao.copyWith(color: context.cores.texto),
            ),
          ),
          if (acao != null) acao!,
        ],
      ),
    );
  }
}

/// Botão redondo da barra de título — o `+` das listas.
class BotaoBarra extends StatelessWidget {
  const BotaoBarra({
    super.key,
    required this.icone,
    required this.onTap,
    required this.rotulo,
  });

  final IconData icone;
  final VoidCallback onTap;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Semantics(
      button: true,
      label: rotulo,
      child: Tooltip(
        message: rotulo,
        child: Material(
          color: cores.marca,
          borderRadius: BorderRadius.circular(Raio.chip),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(icone, size: 22, color: cores.marcaConteudo),
            ),
          ),
        ),
      ),
    );
  }
}
