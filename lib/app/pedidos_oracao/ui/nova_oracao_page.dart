import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NovaOracaoPage extends StatefulWidget {
  @override
  _NovaOracaoPageState createState() => _NovaOracaoPageState();
}

class _NovaOracaoPageState extends State<NovaOracaoPage> {
  Categoria _categoria;
  int _severidade = 0;
  TextEditingController _textoOracaoController = TextEditingController();
  final _textoFormKey = GlobalKey<FormState>();

  get _severidadeOracao => Severidade.values[_severidade];

  void dispose() {
    _textoOracaoController.dispose();
    super.dispose();
  }

  Widget _buildCategoria() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppStyle.titulo("Categoria"),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: FormField<Categoria>(
              builder: (FormFieldState<Categoria> categoria) {
            return InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                labelStyle: TextStyle(fontSize: 16.0),
                hintText: "",
              ),
              isEmpty: _categoria == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Categoria>(
                  value: _categoria,
                  autofocus: true,
                  isDense: true,
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
                          style: TextStyle(
                              fontSize: 14, color: AppStyle.PrimaryColor),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
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
                child: AppStyle.titulo("Tipo"),
              ),
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
                    AppStyle.SecondaryColor,
                    AppStyle.WarningColor,
                    AppStyle.AccentColor,
                    AppStyle.DangerColor
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
                style: TextStyle(
                    fontSize: 13,
                    color: Severidade.values[_severidade].getColor()),
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
        AppStyle.titulo("Informações"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Form(
            key: _textoFormKey,
            child: TextFormField(
              maxLines: null,
              decoration: new InputDecoration(
                focusColor: AppStyle.PrimaryColor,
                labelText: "",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                      color: AppStyle.SecondaryColor, style: BorderStyle.solid),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                      color: AppStyle.SecondaryColor, style: BorderStyle.solid),
                ),
              ),
              maxLength: 70,
              validator: (texto) {
                if (texto == null || texto.isEmpty) {
                  return "Informação é um campo obrigatório";
                } else if (texto.length < 10) {
                  return "Descreva melhor seu pedido de oração";
                } else {
                  return null;
                }
              },
              controller: _textoOracaoController,
            ),
          ),
        )
      ],
    );
  }

  void _salvarOracao() {
    if (_textoFormKey.currentState.validate()) {
      final oracao = PedidoOracao(
          categoria: _categoria,
          severidade: _severidadeOracao,
          texto: _textoOracaoController.text);
      PedidosOracaoService().inserirPedidoOracao(oracao);
      Navigator.pop(context);
    }
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCategoria(),
            SizedBox(
              height: 20,
            ),
            _buildTexto(),
            SizedBox(
              height: 5,
            ),
            _buildSeveridade(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.PrimaryColor,
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
