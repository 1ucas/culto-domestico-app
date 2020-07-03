import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:flutter/material.dart';

class NovoCultinho extends StatefulWidget {

  @override
  _NovoCultinhoState createState() => _NovoCultinhoState();
}

class _NovoCultinhoState extends State<NovoCultinho> {
  TextEditingController _dateController = TextEditingController();
  String livro;
  int capituloLido;
  List<int> versiculosLidos;
  String _pedidoOracao;
  String quemOrou;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return ListView(
      children: [
        Form(
          key: Key("123"),
          child: Column(
            children: [
              _buildData(),
              _buildPassagemLida(),
              _buildPedidosOracao(),
              _buildQuemOrou(),
            ],
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

  Widget _buildData() {
    return GestureDetector(
      onTap: () async => await _selectDate(),
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: TextFormField(
            controller: _dateController,
            decoration: InputDecoration(labelText: 'Data'),
            autofocus: false,
          ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
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
    final pedidos = PedidosOracaoService().listarPedidosOracao();
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
          color: AppStyle.SecondaryColor,
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AppStyle.subTitulo("Pedidos"),
              SizedBox(
                child: ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                        value: false,
                        title: Text(
                          pedidos[index].texto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onChanged: (selected) {
                          // TODO: MARCAR ORACOES Escolhidas
                        });
                  },
                ),
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuemOrou() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        maxLength: 15,
        initialValue: quemOrou,
        decoration: InputDecoration(labelText: 'Quem orou'),
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
        title:
            Text("Novo Cultinho"),
      ),
      body: _buildContents(),
    );
  }
}
