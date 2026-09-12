import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/livro.dart';
import '../../../models/passagem.dart';
import '../../../theme/cores.dart';
import '../../../theme/tipografia.dart';
import '../../../widgets/campos.dart';
import '../../../widgets/cartao.dart';
import '../../../widgets/rotulos.dart';
import 'seletor_livro_page.dart';

/// Monta a referência. O bloco do topo mostra a citação se formando conforme os
/// campos são preenchidos — é o mesmo texto que vai para o registro.
class SeletorPassagemPage extends StatefulWidget {
  const SeletorPassagemPage({super.key, this.inicial});

  final Passagem? inicial;

  @override
  State<SeletorPassagemPage> createState() => _SeletorPassagemPageState();
}

class _SeletorPassagemPageState extends State<SeletorPassagemPage> {
  final _formKey = GlobalKey<FormState>();
  late Livro _livro = widget.inicial?.livro ?? Livro.salmos;

  late final _capituloInicio = TextEditingController(
    text: widget.inicial?.capituloInicio.toString() ?? '1',
  );
  late final _capituloFim = TextEditingController(
    text: widget.inicial?.capituloFim?.toString() ?? '',
  );
  late final _versiculoInicio = TextEditingController(
    text: widget.inicial?.versiculoInicio.toString() ?? '1',
  );
  late final _versiculoFim = TextEditingController(
    text: widget.inicial?.versiculoFim?.toString() ?? '',
  );

  @override
  void dispose() {
    _capituloInicio.dispose();
    _capituloFim.dispose();
    _versiculoInicio.dispose();
    _versiculoFim.dispose();
    super.dispose();
  }

  int? _n(TextEditingController controlador) =>
      int.tryParse(controlador.text.trim());

  /// A referência do preview, tolerante a campos ainda pela metade.
  Passagem get _previa => Passagem(
        livro: _livro,
        capituloInicio: _n(_capituloInicio) ?? 1,
        capituloFim: _n(_capituloFim),
        versiculoInicio: _n(_versiculoInicio) ?? 1,
        versiculoFim: _n(_versiculoFim),
      );

  Future<void> _escolherLivro() async {
    final escolhido = await Navigator.of(context).push<Livro>(
      MaterialPageRoute(builder: (_) => SeletorLivroPage(selecionado: _livro)),
    );
    if (escolhido == null) return;
    setState(() {
      _livro = escolhido;
      // Um capítulo válido em Salmos pode não existir em Obadias.
      if ((_n(_capituloInicio) ?? 1) > escolhido.numCapitulos) {
        _capituloInicio.text = '1';
      }
      if ((_n(_capituloFim) ?? 0) > escolhido.numCapitulos) {
        _capituloFim.clear();
      }
    });
  }

  void _confirmar() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pop(_previa);
  }

  String? _validarCapituloInicio(String? valor) {
    final numero = int.tryParse((valor ?? '').trim());
    if (numero == null || numero < 1) return 'Obrigatório';
    if (numero > _livro.numCapitulos) {
      return '${_livro.nome} vai até ${_livro.numCapitulos}';
    }
    return null;
  }

  String? _validarCapituloFim(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return null;
    final numero = int.tryParse(texto);
    final inicio = _n(_capituloInicio);
    if (numero == null) return 'Número inválido';
    if (numero > _livro.numCapitulos) {
      return '${_livro.nome} vai até ${_livro.numCapitulos}';
    }
    if (inicio != null && numero <= inicio) return 'Depois de $inicio';
    return null;
  }

  String? _validarVersiculoInicio(String? valor) {
    final numero = int.tryParse((valor ?? '').trim());
    if (numero == null || numero < 1) return 'Obrigatório';
    return null;
  }

  String? _validarVersiculoFim(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return null;
    final numero = int.tryParse(texto);
    if (numero == null || numero < 1) return 'Número inválido';
    // Num intervalo de capítulos o versículo final é do último capítulo, então
    // ele pode ser menor que o inicial.
    final inicio = _n(_versiculoInicio);
    final capituloUnico = _n(_capituloFim) == null;
    if (capituloUnico && inicio != null && numero <= inicio) {
      return 'Depois de $inicio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Scaffold(
      appBar: AppBar(title: const Text('Leitura')),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          children: [
            CartaoDestaque(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Micro(
                    'Passagem',
                    cor: cores.marcaConteudo.withValues(alpha: 0.65),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _previa.referencia,
                    style: Tipo.display.copyWith(color: cores.marcaConteudo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const TituloSecao('Livro'),
            GrupoCampos(
              linhas: [
                LinhaSeletor(
                  rotulo: '',
                  valor: _livro.nome,
                  onTap: _escolherLivro,
                ),
              ],
            ),
            const SizedBox(height: 26),
            const TituloSecao('Capítulos'),
            _ParDeCampos(
              inicio: _CampoNumero(
                controlador: _capituloInicio,
                dica: 'Do',
                validator: _validarCapituloInicio,
              ),
              fim: _CampoNumero(
                controlador: _capituloFim,
                dica: 'Até (opcional)',
                validator: _validarCapituloFim,
              ),
            ),
            const SizedBox(height: 26),
            const TituloSecao('Versículos'),
            _ParDeCampos(
              inicio: _CampoNumero(
                controlador: _versiculoInicio,
                dica: 'Do',
                validator: _validarVersiculoInicio,
              ),
              fim: _CampoNumero(
                controlador: _versiculoFim,
                dica: 'Até (opcional)',
                validator: _validarVersiculoFim,
              ),
            ),
            const SizedBox(height: 34),
            FilledButton(
              onPressed: _confirmar,
              child: const Text('Usar esta leitura'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParDeCampos extends StatelessWidget {
  const _ParDeCampos({required this.inicio, required this.fim});

  final Widget inicio;
  final Widget fim;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: inicio),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '–',
            style: Tipo.secao.copyWith(color: context.cores.textoSuave),
          ),
        ),
        Expanded(child: fim),
      ],
    );
  }
}

class _CampoNumero extends StatelessWidget {
  const _CampoNumero({
    required this.controlador,
    required this.dica,
    required this.validator,
  });

  final TextEditingController controlador;
  final String dica;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      style: Tipo.campo.copyWith(color: context.cores.texto),
      textAlign: TextAlign.center,
      decoration: InputDecoration(hintText: dica),
    );
  }
}
