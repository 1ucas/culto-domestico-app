import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/services/cultinho_service.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/passagem_biblica_dialog.dart';
import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:culto_domestico_app/app/utils/dialogs/pedido_oracao_list_dialog_item.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_list_dialog.dart';
import 'package:flutter/material.dart';

class NovoCultinho extends StatefulWidget {
  @override
  _NovoCultinhoState createState() => _NovoCultinhoState();
}

class _NovoCultinhoState extends State<NovoCultinho> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _pedidosController = TextEditingController();
  TextEditingController _passagemLidaController = TextEditingController();
  TextEditingController _quemOrouController = TextEditingController();
  DateTime _dataSelecionada;
  List<PedidoOracao> _pedidosOracao;
  List<PassagemBiblica> _passagensLidas;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dateController.dispose();
    _pedidosController.dispose();
    _quemOrouController.dispose();
    _passagemLidaController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildData(),
            _buildPassagemLida(),
            _buildPedidosOracao(),
            _buildQuemOrou(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.tryParse('2019-06-10T00:00:00'),
        lastDate: DateTime.now());
    setState(() {
      _dataSelecionada = date;
      if (date != null) {
        _dateController.text =
            "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      }
    });
  }

  Future<void> _selectPedidos() async {
    _pedidosOracao = await PedidosOracaoService().listarPedidosOracao();

    var pedidos = _pedidosOracao
        .where((e) => e.respondida == false)
        .map((e) => PedidoOracaoListDialogItem(pedidoOracao: e))
        .toList();

    showDialog<List<bool>>(
      context: context,
      builder: (_) {
        return PlatformListDialog(
          content: pedidos,
          defaultActionText: "Escolher",
          title: "Orações Hoje",
        );
      },
    ).then((listaSelecao) {
      var pedidosFiltrados = List<PedidoOracao>();
      if (listaSelecao != null && listaSelecao.length > 0) {
        _pedidosController.text =
            "Pedidos Escolhidos: ${listaSelecao.where((escolhido) => escolhido).length}";
        for (var i = 0; i < listaSelecao.length; i++) {
          if (listaSelecao[i]) {
            pedidosFiltrados.add(_pedidosOracao[i]);
          }
        }
      } else {
        _pedidosController.text = null;
      }

      _pedidosOracao = pedidosFiltrados;
    });
  }

  Future<void> _selectPassagem() async {
    showDialog<List<PassagemBiblica>>(
      context: context,
      builder: (_) {
        return PassagemBiblicaDialog();
      },
    ).then((value) {
      setState(() {
        _passagensLidas = value;
        _passagemLidaController.text =
            value != null ? "${value.first.toString()}" : null;
      });
    });
  }

  _salvarCultinho() {
    if (_formKey.currentState.validate()) {
      final novoCultinho = Cultinho(
          data: _dataSelecionada,
          quemOrou: _quemOrouController.text,
          leituraFeita: _passagensLidas,
          pedidosOracao: _pedidosOracao);
      CultinhoService()
          .salvarCultinho(cultinho: novoCultinho)
          .then((_) => Navigator.pop(context));
    }
  }

  Widget _buildData() {
    return GestureDetector(
      onTap: () async => await _selectDate(),
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextFormField(
            enabled: false,
            controller: _dateController,
            decoration: InputDecoration(
              labelText: "Data",
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.black38),
              ),
            ),
            autofocus: false,
          ),
        ),
      ),
    );
  }

  Widget _buildPassagemLida() {
    return GestureDetector(
      onTap: () async => await _selectPassagem(),
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextFormField(
            enabled: false,
            controller: _passagemLidaController,
            decoration: InputDecoration(
              labelText: "Passagem Bíblica",
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.black38),
              ),
            ),
            autofocus: false,
          ),
        ),
      ),
    );
  }

  Widget _buildPedidosOracao() {
    return GestureDetector(
      onTap: () async => await _selectPedidos(),
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextFormField(
            enabled: false,
            controller: _pedidosController,
            decoration: InputDecoration(
              labelText: "Pedidos de Oração",
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.black38),
              ),
            ),
            autofocus: false,
          ),
        ),
      ),
    );
  }

  Widget _buildQuemOrou() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24.0),
      child: TextFormField(
        controller: _quemOrouController,
        decoration: InputDecoration(
          labelText: "Quem orou",
          labelStyle: TextStyle(color: Colors.black38),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.circular(5.8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.circular(5.8),
          ),
        ),
        maxLength: 15,
      ),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/familiaorando.png'),
          _buildForm(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.PrimaryColor,
        actions: [
          FlatButton(
            child: Text(
              "Salvar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              _salvarCultinho();
            },
          )
        ],
        title: Text("Novo Cultinho"),
      ),
      body: _buildContents(),
    );
  }
}
