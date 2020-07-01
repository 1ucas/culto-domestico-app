import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/ui/nova_oracao_page.dart';
import 'package:culto_domestico_app/app/utils/icons/pedido_oracao_icons.dart';
import 'package:flutter/material.dart';

class PedidosOracaoPage extends StatefulWidget {
  final List<PedidoOracao> itens;

  const PedidosOracaoPage({Key key, @required this.itens}) : super(key: key);

  @override
  _PedidosOracaoPageState createState() => _PedidosOracaoPageState();
}

class _PedidosOracaoPageState extends State<PedidosOracaoPage> {
  List<PedidoOracao> listaOracoes;

  void _removerPedidoOracao(int oracaoId) {
    setState(() {
      listaOracoes.removeWhere((element) => element.hashCode == oracaoId);
      PedidosOracaoService().removerOracao(oracaoId);
    });
  }

  Widget _buildItem(BuildContext context, PedidoOracao pedido) {
    return Dismissible(
      key: Key("oracao-${pedido.hashCode}"),
      onDismissed: (direction) => _removerPedidoOracao(pedido.hashCode),
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(pedido.texto),
        ),
        onTap: () {},
        trailing: IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Colors.red[400],
          ),
          onPressed: () => _removerPedidoOracao(pedido.hashCode),
        ),
        leading: PedidoOracaoIcons.categoria(pedido),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return _buildItem(context, widget.itens[index]);
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        thickness: 1,
      ),
      itemCount: widget.itens.length,
    );
  }

  void _navegarParaNovaOracao(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => NovaOracaoPage()))
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    listaOracoes = widget.itens;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () => _navegarParaNovaOracao(context)),
        ],
        title: Text("Pedidos de Oração"),
      ),
      body: _buildBody(),
    );
  }
}
