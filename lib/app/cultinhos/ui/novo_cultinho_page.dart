import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:culto_domestico_app/app/utils/dialogs/platform_list_dialog.dart';
import 'package:flutter/material.dart';

class NovoCultinho extends StatefulWidget {
  @override
  _NovoCultinhoState createState() => _NovoCultinhoState();
}

class _NovoCultinhoState extends State<NovoCultinho> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _pedidosController = TextEditingController();
  String livro;
  int capituloLido;
  List<int> versiculosLidos;
  String _pedidoOracao;
  String quemOrou;

  @override
  void dispose() {
    _dateController.dispose();
    _pedidosController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return ListView(
      children: [
        Form(
          key: Key("123"),
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
        )
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.tryParse('2019-06-10T00:00:00'),
        lastDate: DateTime.now());
    setState(() {
      if (date != null) {
        _dateController.text =
            "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      }
    });
    print(date);
  }

  Future<void> _selectPedidos() async {
    final pedidos = PedidosOracaoService().listarPedidosOracao();
    showDialog(context: context, builder: (_) { return PlatformListDialog(
      content: pedidos,
      defaultActionText: "Escolher",
      title: "Orações Hoje",
    ); });
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
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
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

  Widget _buildLivroLido() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Passagem Lida",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
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

  Widget _buildPassagemLida() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: _buildLivroLido()),
          //Expanded(flex: 2, child: _buildCapituloLido()),
          //Expanded(flex: 2, child: _buildVersiculosLidos()),
          //Expanded(flex: 2, child: _buildVersiculosLidos()),
        ],
      ),
    );
  }

  Widget _buildPedidosOracao() {
    return GestureDetector(
      onTap: () async => await _selectPedidos(),
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextFormField(
            enabled: false,
            controller: _pedidosController,
            decoration: InputDecoration(
              labelText: "Pedidos",
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
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
        decoration: InputDecoration(
          labelText: "Quem orou",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.8),
          ),
        ),
        maxLength: 15,
        initialValue: quemOrou,
      ),
    );
  }

  Widget _buildContents() {
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
              child: _buildForm(),
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
        backgroundColor: AppStyle.PrimaryColor,
        title: Text("Novo Cultinho"),
      ),
      body: _buildContents(),
    );
  }
}
