import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/services/cultinho_service.dart';
import 'package:culto_domestico_app/app/cultinhos/ui/passagem_biblica_dialog.dart';
import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:culto_domestico_app/app/utils/dialogs/pedido_oracao_list_dialog_item.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NovoCultinho extends StatefulWidget {
  @override
  _NovoCultinhoState createState() => _NovoCultinhoState();
}

class _NovoCultinhoState extends State<NovoCultinho> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _pedidosController = TextEditingController();
  final TextEditingController _passagemLidaController = TextEditingController();
  final TextEditingController _quemOrouController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();
  List<PedidoOracao> _pedidosOracao = [];
  List<PassagemBiblica> _passagensLidas  = [];
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
        firstDate: DateTime.utc(2023),
        lastDate: DateTime.now());
    setState(() {
      if (date != null) {
        _dataSelecionada = date;
        _dateController.text =
            "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      }
    });
  }

  Future<void> _selectPedidos() async {
    final repo = Provider.of<PedidosOracaoRepository>(context, listen: false);
    _pedidosOracao = await PedidosOracaoService(repositorio: repo).listarPedidosOracao();

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
      List<PedidoOracao> pedidosFiltrados = [];
      if (listaSelecao != null && listaSelecao.isNotEmpty) {
        _pedidosController.text =
            "Pedidos Escolhidos: ${listaSelecao.where((escolhido) => escolhido).length}";
        for (var i = 0; i < listaSelecao.length; i++) {
          if (listaSelecao[i]) {
            pedidosFiltrados.add(_pedidosOracao[i]);
          }
        }
      } else {
        _pedidosController.text = "";
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
        if(value != null) {
          _passagensLidas = value;
          _passagemLidaController.text = value[0].toString() ?? "";
        }
      });
    });
  }

  _salvarCultinho() {
    if (_formKey.currentState?.validate() == true) {
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
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppStyle.PrimaryColor,
        actions: [
          TextButton(
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
        title: const Text("Novo Cultinho", style: TextStyle(color: Colors.white)),
      ),
      body: _buildContents(),
    );
  }
}
