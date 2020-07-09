import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/utils/dropdown/app_dropdown_field.dart';
import 'package:culto_domestico_app/app/utils/dropdown/app_numeric_field.dart';
import 'package:flutter/material.dart';

class PassagemSelector extends StatefulWidget {

  final state = _PassagemSelectorState();

  List<PassagemBiblica> validate() {
    return state.validate();
  }

  @override
  _PassagemSelectorState createState() => state;
}

class _PassagemSelectorState extends State<PassagemSelector> {
  var _capituloInicioTextController;
  var _capituloFimTextController;
  var _versiculoInicioTextController;
  var _versiculoFimTextController;
  var _livroEscolhido = Livro.genesis;

  @override
  void initState() {
    _capituloInicioTextController = TextEditingController(text: "1");
    _capituloFimTextController = TextEditingController();
    _versiculoInicioTextController = TextEditingController(text: "1");
    _versiculoFimTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _capituloInicioTextController.dispose();
    _capituloFimTextController.dispose();
    _versiculoInicioTextController.dispose();
    _versiculoFimTextController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  List<PassagemBiblica> validate() {
    var valid = _formKey.currentState.validate();
    if (valid) {
      var capitulos = <int>[];
      var versiculos = <int>[];
      return [
        PassagemBiblica(
            livro: _livroEscolhido,
            capitulos: capitulos,
            versiculos: versiculos)
      ];
    } else {
      return null;
    }
  }

  Widget _buildLivro() {
    return AppDropdownField<Livro>(
      titulo: "Livro",
      value: _livroEscolhido,
      onChanged: (Livro newValue) {
        setState(() {
          _livroEscolhido = newValue;
        });
      },
      validator: (Livro value) {
        if (value == null) {
          return 'Campo Obrigatório';
        } else {
          return null;
        }
      },
      items: Livro.values.map((Livro value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value.nome),
        );
      }).toList(),
    );
  }

  Widget _buildCapitulos() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 100,
              child: AppNumericFormField(
                  titulo: "Capítulos",
                  controller: _capituloInicioTextController,
                  validator: (String value) {
                    int valor = int.tryParse(value);
                    if (valor == null || valor <= 0) {
                      return "Obrigatório";
                    } else if (valor > _livroEscolhido.numCapitulos) {
                      return "Incorreto";
                    } else {
                      setState(() {
                        _capituloInicioTextController.text = value;
                      });
                      return null;
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 100,
              child: AppNumericFormField(
                controller: _capituloFimTextController,
                titulo: "Fim",
                validator: (String value) {
                  int valorInicial =
                      int.tryParse(_capituloInicioTextController.text);
                  int valorFinal = int.tryParse(value);
                  if (valorInicial != null) {
                    if (valorFinal != null &&
                        (valorFinal <= valorInicial ||
                            valorFinal > _livroEscolhido.numCapitulos)) {
                      return "Incorreto";
                    }
                  } else if (valorFinal != null) {
                    return "Incorreto";
                  }
                  setState(() {
                    _capituloFimTextController.text = value;
                  });
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersiculos() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 100,
              child: AppNumericFormField(
                  titulo: "Versículos",
                  controller: _versiculoInicioTextController,
                  validator: (String value) {
                    int valor = int.tryParse(value);
                    if (valor == null || valor <= 0) {
                      return "Obrigatório";
                    } else {
                      setState(() {
                        _versiculoInicioTextController.text = value;
                      });
                      return null;
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 100,
              child: AppNumericFormField(
                  controller: _versiculoFimTextController,
                  titulo: "Fim",
                  validator: (String value) {
                    int valorInicial =
                        int.tryParse(_versiculoInicioTextController.text);
                    int valorFinal = int.tryParse(value);
                    if (valorInicial != null) {
                      if (valorFinal != null && valorFinal <= 0) {
                        return "Incorreto";
                      }
                    } else if (valorFinal != null) {
                      return "Incorreto";
                    }
                    setState(() {
                      _versiculoFimTextController.text = value;
                    });
                    return null;
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLivro(),
          _buildCapitulos(),
          _buildVersiculos(),
        ],
      ),
    );
  }
}
