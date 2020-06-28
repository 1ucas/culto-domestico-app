import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/utils/icons/pedido_oracao_icons.dart';
import 'package:flutter/material.dart';

class PedidosOracaoPage extends StatelessWidget {
  final List<PedidoOracao> itens;

  const PedidosOracaoPage({Key key, @required this.itens}) : super(key: key);

  Widget _buildItem(BuildContext context, PedidoOracao pedido) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pedido.texto),
      ),
      trailing: Icon(Icons.edit),
      onTap: () {},
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(children: [PedidoOracaoIcons.categoria(pedido)]),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return _buildItem(context, itens[index]);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: 0.5,
              thickness: 1,
            ),
        itemCount: itens.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Pedidos de Oração"),
      ),
      body: _buildBody(),
    );
  }
}
