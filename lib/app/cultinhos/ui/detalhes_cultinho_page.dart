import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:flutter/material.dart';

class DetalhesCultinhoPage extends StatefulWidget {
  final Cultinho cultinho;

  DetalhesCultinhoPage({Key key, this.cultinho})
      : super(key: key);

  @override
  _DetalhesCultinhoPageState createState() => _DetalhesCultinhoPageState();
}

class _DetalhesCultinhoPageState extends State<DetalhesCultinhoPage> {
  TextEditingController _dateController = TextEditingController();
  String livro;
  int capituloLido;
  List<int> versiculosLidos;
  String _pedidoOracao;
  String quemOrou;

  @override
  void initState() {
    if(widget.cultinho != null) {
      var date = widget.cultinho.data;
      _dateController.text = "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      quemOrou = widget.cultinho.participantes.where((element) => element.orou).first.nome;
    }
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: Key("123"),
          child: Column(
            children: [
              _buildData(context),
              _buildPassagemLida(),
              _buildPedidosOracao(),
              _buildQuemOrou(),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.tryParse('2019-06-10T00:00:00'),
        lastDate: DateTime.now());
    setState(() {
      if (date != null) {
        _dateController.text = "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      }
    });
    print(date);
  }

  Widget _buildData(BuildContext context) {
    return GestureDetector(
      onTap: () async => await _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateController,
          decoration: InputDecoration(labelText: 'Data'),
          autofocus: false,
        ),
      ),
    );
  }

  Widget _buildVersiculosLidos() {
    return DropdownButtonFormField<int>(
      hint: Text("Versiculo"),
      elevation: 16,
      style: TextStyle(color: Colors.indigo),
      onChanged: (int newValue) {
        setState(() {
          versiculosLidos.clear();
          versiculosLidos.add(newValue);
        });
      },
      validator: (int value) {
        if (value == null) {
          return 'Please enter a valid type of business';
        } else {
          return null;
        }
      },
      items: <int>[1, 2].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildLivroLido() {
    return DropdownButtonFormField<String>(
      hint: Text("Passagem Lida"),
      elevation: 16,
      style: TextStyle(color: Colors.indigo),
      onChanged: (String newValue) {
        setState(() {
          livro = newValue;
        });
      },
      validator: (String value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter a valid type of business';
        } else {
          return null;
        }
      },
      items: <String>['Genesis', 'Exodo']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildCapituloLido() {
    return DropdownButtonFormField<int>(
      hint: Text("Capitulo"),
      elevation: 16,
      style: TextStyle(color: Colors.indigo),
      onChanged: (int newValue) {
        setState(() {
          capituloLido = newValue;
        });
      },
      validator: (int value) {
        if (value == null) {
          return 'Please enter a valid type of business';
        } else {
          return null;
        }
      },
      items: <int>[1, 2].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildPassagemLida() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildLivroLido()),
        Expanded(flex: 2, child: _buildCapituloLido()),
        Expanded(flex: 2, child: _buildVersiculosLidos()),
        Expanded(flex: 2, child: _buildVersiculosLidos()),
      ],
    );
  }

  Widget _buildPedidosOracao() {
    final pedidos = PedidosOracaoService().listarPedidosOracao();
    return Column(children: [
      for (var pedido in pedidos) ...<Widget>[
        RadioListTile<String>(
          title: Text(pedido.texto),
          value: pedido.texto,
          groupValue: _pedidoOracao,
          onChanged: (String value) {
            setState(() {
              _pedidoOracao = value;
            });
          },
        ),
      ],
    ]);
  }

  Widget _buildQuemOrou() {
    return TextFormField(
      maxLength: 15,
      initialValue: quemOrou,
      decoration: InputDecoration(labelText: 'Quem orou'),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/familiaorando.png'),
          Expanded(
            flex: 1,
            child: Card(
              shadowColor: Colors.black38,
              elevation: 8.0,
              child: _buildForm(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cultinho != null ? "Editar Cultinho" : "Novo Cultinho"),
      ),
      body: _buildContents(context),
    );
  }
}
