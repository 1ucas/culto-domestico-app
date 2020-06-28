import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/models/participante.dart';
import 'package:culto_domestico_app/app/utils/icons/pedido_oracao_icons.dart';
import 'package:flutter/material.dart';

class CultinhoListTile extends StatelessWidget {
  final Cultinho cultinho;

  const CultinhoListTile({Key key, @required this.cultinho}) : super(key: key);

  Widget _buildParticipantes() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (Participante participante in cultinho.participantes) ...[
                  Row(
                    children: [
                      if (participante.orou) ...<Widget>[
                        Icon(Icons.star, color: Colors.yellow),
                      ] else ...[
                          Icon(Icons.remove, color: Colors.indigo),
                      ],
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(participante.nome),
                      ),
                    ],
                  ),
                ],
              ],
            )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Data: ${cultinho.dia}"),
          _buildParticipantes(),
        ],
      ),
    );
  }

  Widget _buildSubTitle() {
    var icones = cultinho.pedidosOracao
        .map((pedido) => PedidoOracaoIcons.categoria(pedido));
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Text("Orações: "),
          for (Icon icone in icones) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icone,
            )
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: Colors.lightGreen[50],
      title: _buildTitle(),
      subtitle: _buildSubTitle(),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
