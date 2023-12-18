import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/ui/nova_oracao_page.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_alert_dialog.dart';
import 'package:culto_domestico_app/app/utils/icons/pedido_oracao_icons.dart';
import 'package:culto_domestico_app/app/utils/lists/empty_list_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PedidosOracaoPage extends StatefulWidget {
  @override
  _PedidosOracaoPageState createState() => _PedidosOracaoPageState();
}

class _PedidosOracaoPageState extends State<PedidosOracaoPage> {
  late List<PedidoOracao> listaOracoes;
  late PedidosOracaoRepository repo;

  @override
  void initState() {
    repo = Provider.of<PedidosOracaoRepository>(context, listen: false);
    super.initState();
  }

  final _filtrosLista = const <bool, Widget>{
    false: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Orações Ativas",
      ),
    ),
    true: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Respostas de Deus",
      ),
    ),
  };

  bool _filtrarRespondidas = false;

  Future<bool> _confirmarOracaoRespondida(int oracaoId) async {
    final respondida = await PlatformAlertDialog(
      content: _filtrarRespondidas
          ? "Deseja realmente apagar essa resposta de oração?"
          : "Deseja marcar como respondido por Deus, ou apenas excluir?",
      defaultActionText:
          _filtrarRespondidas ? "Cancelar" : "Marcar como respondido",
      cancelActionText: _filtrarRespondidas ? "Excluir" : "Apenas excluir",
      title: "Atenção",
    ).show(context);
    if (respondida == true) {
      await PedidosOracaoService(repositorio: repo).atualizarOracaoRespondida(oracaoId);
      return true;
    } else {
      await PedidosOracaoService(repositorio: repo).removerOracao(oracaoId);
      return true;
    }
  }

  Future<void> _atualizaListaOracoes(int oracaoId) async {
    setState(() {
      listaOracoes.removeWhere((element) => element.hashCode == oracaoId);
    });
  }


  Widget _buildItem(BuildContext context, PedidoOracao pedido) {
    return Dismissible(
      key: Key("oracao-${pedido.hashCode}"),
      confirmDismiss: (direction) async => await _confirmarOracaoRespondida(pedido.hashCode),
      onDismissed: (direction) async => await _atualizaListaOracoes(pedido.hashCode),
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
            color: AppStyle.DangerColor,
          ),
          onPressed: () async {
            await _confirmarOracaoRespondida(pedido.hashCode);
            await _atualizaListaOracoes(pedido.hashCode);
          },
        ),
        leading: PedidoOracaoIcons.categoria(pedido),
      ),
    );
  }

  Widget _buildList() {
    return FutureBuilder(
      future: PedidosOracaoService(repositorio: repo).listarPedidosOracao(),
      builder: (context, snapshot) {
        var snapshotData = snapshot.data;
        if (snapshotData != null) {
          listaOracoes = snapshotData;
          if (snapshotData.isEmpty) {
            return Center(child: EmptyListContent());
          } else {
            var listaRenderizar = listaOracoes
                .where((oracao) => oracao.respondida == _filtrarRespondidas)
                .toList();
            return ListView.separated(
              itemBuilder: (context, index) {
                return _buildItem(context, listaRenderizar[index]);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0.5,
                thickness: 1,
              ),
              itemCount: listaRenderizar.length,
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        CupertinoSegmentedControl<bool>(
          selectedColor: AppStyle.PrimaryColor,
          unselectedColor: Colors.white,
          borderColor: AppStyle.PrimaryColor,
          padding: EdgeInsets.all(16.0),
          children: _filtrosLista,
          groupValue: _filtrarRespondidas,
          onValueChanged: (bool valor) {
            setState(() {
              _filtrarRespondidas = valor;
            });
          },
        ),
        Expanded(child: _buildList())
      ],
    );
  }

  void _navegarParaNovaOracao(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => NovaOracaoPage()))
        .then((value) {
      PedidosOracaoService(repositorio: repo).listarPedidosOracao().then((value) {
        setState(() {
          listaOracoes = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.PrimaryColor,
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () => _navegarParaNovaOracao(context)),
        ],
        title: const Text("Pedidos de Oração", style: TextStyle(color: Colors.white)),
      ),
      body: _buildBody(),
    );
  }
}

class CupertinoSlidingSegmentedControl {}
