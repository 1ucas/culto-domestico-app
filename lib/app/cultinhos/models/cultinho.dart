
import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/utils/date/date_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class Cultinho {

  final String id = UniqueKey().toString();
  final DateTime data;
  final List<PedidoOracao> pedidosOracao;
  final List<PassagemBiblica> leituraFeita;
  final String quemOrou;

  Cultinho({@required this.quemOrou, @required this.data, this.pedidosOracao, this.leituraFeita});

  String get dia => DateUtils.toShortDateString(data);
}