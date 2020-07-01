import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NovaOracaoPage extends StatefulWidget {
  @override
  _NovaOracaoPageState createState() => _NovaOracaoPageState();
}

class _NovaOracaoPageState extends State<NovaOracaoPage> {
  Categoria _categoria = Categoria.pessoal;
  int _severidade = 0;
  TextEditingController _textoOracaoController = TextEditingController();
  final _textoFormKey = GlobalKey<FormState>();

  get _severidadeOracao => Severidade.values[_severidade];

  void dispose() {
    _textoOracaoController.dispose();
    super.dispose();
  }

  Widget _buildCategoriaGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Categoria",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 110,
          child: GridView.count(
            childAspectRatio: 3,
            crossAxisCount: 3,
            children: [
              for (var categoriaOracao in Categoria.values) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio<Categoria>(
                      value: categoriaOracao,
                      groupValue: _categoria,
                      onChanged: (Categoria value) {
                        setState(() {
                          _categoria = value;
                        });
                      },
                    ),
                    Expanded(child: Text(describeEnum(categoriaOracao))),
                  ],
                ),
              ],
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCategoria() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Categoria",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        DropdownButton<Categoria>(
          value: _categoria,
          onChanged: (Categoria newValue) {
            setState(() {
              _categoria = newValue;
            });
          },
          items: [
            for (var categoria in Categoria.values) ...[
              DropdownMenuItem<Categoria>(
                value: categoria,
                child: Text(
                  describeEnum(categoria).toUpperCase(),
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSeveridade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Tipo",
                style: TextStyle(fontSize: 16),
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 66.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                inactiveTrackColor: Colors.transparent,
                activeTrackColor: Colors.transparent,
                activeTickMarkColor: Colors.black12,
                inactiveTickMarkColor: Colors.black12,
                tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 5),
                thumbColor: Colors.indigoAccent,
                showValueIndicator: ShowValueIndicator.never),
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red
                  ],
                ),
              ),
              child: Slider(
                divisions: Severidade.values.length - 1,
                max: Severidade.values.length.toDouble() - 1,
                value: _severidade.toDouble(),
                label: describeEnum(Severidade.values[_severidade]),
                onChanged: (value) {
                  setState(() {
                    _severidade = value.toInt();
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 66.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                describeEnum(Severidade.values[_severidade]).toUpperCase(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTexto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informação",
          style: TextStyle(fontSize: 16),
        ),
        Form(
          key: _textoFormKey,
          child: TextFormField(
            maxLength: 70,
            validator: (texto) {
              if (texto == null || texto.isEmpty) {
                return "Informação é um campo obrigatório";
              } else {
                return null;
              }
            },
            controller: _textoOracaoController,
          ),
        )
      ],
    );
  }

  void _salvarOracao() {
    if(_textoFormKey.currentState.validate()){
      final oracao = PedidoOracao(categoria: _categoria, severidade: _severidadeOracao, texto: _textoOracaoController.text);
      PedidosOracaoService().inserirPedidoOracao(oracao);
      Navigator.pop(context);
    }
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildCategoria(),
          SizedBox(
            height: 5,
          ),
          _buildSeveridade(),
          SizedBox(
            height: 20,
          ),
          _buildTexto()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Oração"),
        actions: [
          FlatButton(
            onPressed: _salvarOracao,
            child: Text(
              "Salvar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContent(),
    );
  }
}
