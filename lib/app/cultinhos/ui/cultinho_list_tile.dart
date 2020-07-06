import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_alert_dialog.dart';
import 'package:culto_domestico_app/app/utils/icons/pedido_oracao_icons.dart';
import 'package:flutter/material.dart';

class CultinhoListTile extends StatelessWidget {
  final Cultinho cultinho;
  final void Function(String id)onDelete;

  const CultinhoListTile({Key key, @required this.cultinho, @required this.onDelete}) : super(key: key);

  Widget _buildQuemOrou() {
    final quemOrou = cultinho.quemOrou;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quem orou: "),
        if (quemOrou == null) ...<Widget>[
          Text("Ninguém orou"),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(quemOrou),
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

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildPedidos(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: IconButton(
              icon: Icon(Icons.delete_forever, color: AppStyle.DangerColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => PlatformAlertDialog(
                    title: "Confirmação",
                    content: "Deseja excluir esse cultinho?",
                    defaultActionText: "Sim",
                    cancelActionText: "Não",
                  ),
                ).then((apagou) {
                  if (apagou) {
                    onDelete(cultinho.id);
                  }
                });
              }),
        ),
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
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text("Pedidos: "),
          ),
          for (var index = 0; index < pedidosUnicos.length; index++) ...[
            SizedBox(
              width: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("${quantidades.elementAt(index)} x "),
                  ),
                  PedidoOracaoIcons.categoria(pedidosUnicos[index])
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _navegarParaDetalhesCultinho(BuildContext context) {}

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
          child: _buildContent(context),
        ),
      ),
    );
  }
}
