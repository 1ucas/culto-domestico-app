import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/models/participante.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/utils/icons/pedido_oracao_icons.dart';
import 'package:flutter/material.dart';

class CultinhoListTile extends StatelessWidget {
  final Cultinho cultinho;

  const CultinhoListTile({Key key, @required this.cultinho}) : super(key: key);

  Widget _buildParticipantes() {
    return Column(
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
    );
  }

  Widget _buildQuemOrou() {
    final quemOrou = cultinho.participantes
        .firstWhere((participante) => participante.orou, orElse: () => null);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quem orou: "),
        if (quemOrou == null) ...<Widget>[
          Text("Ninguém orou"),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(quemOrou.nome),
          ),
        ]
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuemOrou(),
          Text(
            "Data: ${cultinho.dia}",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[400],
                  offset: const Offset(4, 4),
                  blurRadius: 16),
            ]),
        padding: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [_buildTitle(), _buildPedidos()],
                )),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPedidos() {
    var pedidosTransformados = <PedidoOracao>[];
    cultinho.pedidosOracao.forEach((element) {
      pedidosTransformados.add(PedidoOracao(categoria: element.categoria, severidade: null, texto: ""));
    });
    var pedidosUnicos = pedidosTransformados.toSet().toList();
    var quantidades = pedidosUnicos.map((pedidoUnico) => pedidosTransformados.where((pedido) => pedido.categoria == pedidoUnico.categoria).length);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: [
            Text("Pedidos: "),
            for (var index = 0; index < pedidosUnicos.length; index++) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("${quantidades.elementAt(index)} x "),
              ),
              PedidoOracaoIcons.categoria(pedidosUnicos[index]),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
