import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/models/participante.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/detalhes_cultinho_page.dart';
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
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [_buildTitle(), _buildPedidos()],
        )),
        Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildPedidos() {
    var pedidosTransformados = <PedidoOracao>[];
    cultinho.pedidosOracao.forEach((element) {
      pedidosTransformados.add(PedidoOracao(
          categoria: element.categoria, severidade: null, texto: ""));
    });
    var pedidosUnicos = pedidosTransformados.toSet().toList();
    var quantidades = pedidosUnicos.map((pedidoUnico) => pedidosTransformados
        .where((pedido) => pedido.categoria == pedidoUnico.categoria)
        .length);
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

  void _navegarParaDetalhesCultinho(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesCultinhoPage(cultinho: cultinho)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      shadowColor: Colors.black45,
      elevation: 12.0,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => _navegarParaDetalhesCultinho(context),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: _buildContent(),
        ),
      ),
    );
  }
}
