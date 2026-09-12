import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/formato.dart';
import '../../models/culto.dart';
import '../../models/passagem.dart';
import '../../models/pedido_oracao.dart';
import '../../state/cultos_store.dart';
import '../../state/oracoes_store.dart';
import '../../theme/cores.dart';
import '../../theme/tipografia.dart';
import '../../widgets/campos.dart';
import '../../widgets/rotulos.dart';
import 'widgets/seletor_passagem_page.dart';
import 'widgets/seletor_pedidos_sheet.dart';

class NovoCultoPage extends StatefulWidget {
  const NovoCultoPage({super.key});

  @override
  State<NovoCultoPage> createState() => _NovoCultoPageState();
}

class _NovoCultoPageState extends State<NovoCultoPage> {
  final _quemOrou = TextEditingController();
  DateTime _data = DateTime.now();
  Passagem? _leitura;
  List<PedidoOracao> _pedidos = const [];
  bool _salvando = false;

  @override
  void dispose() {
    _quemOrou.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      helpText: 'Data do cultinho',
      cancelText: 'Cancelar',
      confirmText: 'Usar',
    );
    if (escolhida != null) setState(() => _data = escolhida);
  }

  Future<void> _escolherLeitura() async {
    final passagem = await Navigator.of(context).push<Passagem>(
      MaterialPageRoute(builder: (_) => SeletorPassagemPage(inicial: _leitura)),
    );
    if (passagem != null) setState(() => _leitura = passagem);
  }

  Future<void> _escolherPedidos() async {
    final escolhidos = await escolherPedidos(
      context,
      disponiveis: context.read<OracoesStore>().abertos,
      jaEscolhidos: _pedidos,
    );
    if (escolhidos != null) setState(() => _pedidos = escolhidos);
  }

  Future<void> _guardar() async {
    setState(() => _salvando = true);
    final navegador = Navigator.of(context);
    await context.read<CultosStore>().salvar(
          Culto.novo(
            data: _data,
            quemOrou: _quemOrou.text.trim(),
            leituras: [if (_leitura != null) _leitura!],
            pedidosOracao: _pedidos,
          ),
        );
    navegador.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;

    return Scaffold(
      appBar: AppBar(title: const Text('Novo cultinho')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          const TituloSecao('O encontro'),
          GrupoCampos(
            linhas: [
              LinhaSeletor(
                rotulo: 'Data',
                valor: Formato.completa(_data),
                onTap: _escolherData,
              ),
              LinhaSeletor(
                rotulo: 'Leitura',
                valor: _leitura?.referencia,
                vazio: 'Escolher',
                onTap: _escolherLeitura,
              ),
              LinhaSeletor(
                rotulo: 'Pedidos',
                valor: _pedidos.isEmpty
                    ? null
                    : Formato.plural(_pedidos.length, 'pedido', 'pedidos'),
                vazio: 'Escolher',
                onTap: _escolherPedidos,
              ),
            ],
          ),
          const SizedBox(height: 26),
          const TituloSecao('Quem orou'),
          TextField(
            controller: _quemOrou,
            textCapitalization: TextCapitalization.words,
            maxLength: 20,
            style: Tipo.campo.copyWith(color: cores.texto),
            decoration: const InputDecoration(
              hintText: 'Nome de quem fez a oração',
              counterText: '',
            ),
          ),
          const SizedBox(height: 34),
          FilledButton(
            onPressed: _salvando ? null : _guardar,
            child: Text(_salvando ? 'Guardando…' : 'Guardar cultinho'),
          ),
        ],
      ),
    );
  }
}
