import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pedido_oracao.dart';
import '../../state/oracoes_store.dart';
import '../../theme/cores.dart';
import '../../theme/tipografia.dart';
import '../../widgets/campos.dart';
import '../../widgets/glifos.dart';
import '../../widgets/rotulos.dart';

class NovaOracaoPage extends StatefulWidget {
  const NovaOracaoPage({super.key});

  @override
  State<NovaOracaoPage> createState() => _NovaOracaoPageState();
}

class _NovaOracaoPageState extends State<NovaOracaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _texto = TextEditingController();
  Categoria _categoria = Categoria.casa;
  Severidade _severidade = Severidade.normal;
  bool _salvando = false;

  static const _minimoTexto = 10;
  static const _maximoTexto = 70;

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  String? _validarTexto(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Escreva o pedido';
    if (texto.length < _minimoTexto) {
      return 'Descreva um pouco mais — pelo menos $_minimoTexto letras';
    }
    return null;
  }

  Future<void> _guardar() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _salvando = true);
    final navegador = Navigator.of(context);
    await context.read<OracoesStore>().adicionar(
          PedidoOracao(
            id: gerarId(),
            texto: _texto.text.trim(),
            categoria: _categoria,
            severidade: _severidade,
          ),
        );
    navegador.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Scaffold(
      appBar: AppBar(title: const Text('Novo pedido')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          children: [
            const TituloSecao('O pedido'),
            TextFormField(
              controller: _texto,
              validator: _validarTexto,
              autofocus: true,
              maxLines: null,
              minLines: 3,
              maxLength: _maximoTexto,
              textCapitalization: TextCapitalization.sentences,
              style: Tipo.campo.copyWith(color: cores.texto),
              decoration: const InputDecoration(
                hintText: 'Ex.: saúde da vovó Maria depois da cirurgia',
              ),
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) =>
                  Padding(
                padding: const EdgeInsets.only(top: 6, right: 4),
                child: Text(
                  '$currentLength/$maxLength',
                  style: Tipo.apoio.copyWith(color: cores.textoSuave),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const TituloSecao('Categoria'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final categoria in Categoria.values)
                  OpcaoPilula(
                    rotulo: categoria.nome,
                    icone: Glifos.daCategoria(categoria),
                    selecionada: categoria == _categoria,
                    onTap: () => setState(() => _categoria = categoria),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            const TituloSecao('Tipo'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final severidade in Severidade.values)
                  OpcaoPilula(
                    rotulo: severidade.nome,
                    selecionada: severidade == _severidade,
                    tom: Glifos.daSeveridade(context, severidade),
                    onTap: () => setState(() => _severidade = severidade),
                  ),
              ],
            ),
            const SizedBox(height: 34),
            FilledButton(
              onPressed: _salvando ? null : _guardar,
              child: Text(_salvando ? 'Guardando…' : 'Guardar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
