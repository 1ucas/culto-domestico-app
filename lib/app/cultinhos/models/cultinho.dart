import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/utils/date/date_utils.dart';
import 'package:flutter/widgets.dart';

class Cultinho {
  String _identifier = UniqueKey().toString();
  final DateTime data;
  final List<PedidoOracao> pedidosOracao;
  final List<PassagemBiblica> leituraFeita;
  final String quemOrou;

  String get id => _identifier;

  Cultinho({
    required this.quemOrou,
    required this.data,
    this.pedidosOracao = const [],
    this.leituraFeita = const []
  });

  String get dia => DateUtils.toShortDateString(data);

  Cultinho.fromJson(Map<String, dynamic> json)
      : _identifier = json['id'],
        data = DateTime.parse(json['data']),
        pedidosOracao = json['pedidosOracao']
            .map<PedidoOracao>((item) => PedidoOracao.fromJson(item))
            .toList(),
        leituraFeita = json['leituraFeita']
            .map<PassagemBiblica>((item) => PassagemBiblica.fromJson(item))
            .toList(),
        quemOrou = json['quemOrou'];

  Map<String, dynamic> toJson() => {
        'id': _identifier,
        'data': data.toIso8601String(),
        'pedidosOracao':
            pedidosOracao == null ? [] : pedidosOracao.map((pedido) => pedido.toJson()).toList(),
        'leituraFeita':
            leituraFeita  == null ? [] : leituraFeita.map((leitura) => leitura.toJson()).toList(),
        'quemOrou': quemOrou ?? "",
      };
}
