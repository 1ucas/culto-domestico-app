
import 'package:culto_domestico_app/app/cultinhos/models/participante.dart';
import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/utils/date/date_utils.dart';
import 'package:meta/meta.dart';

class Cultinho {

  final DateTime data;
  final List<PedidoOracao> pedidosOracao;
  final List<PassagemBiblica> leituraFeita;
  final List<Participante> participantes;

  Cultinho({@required this.participantes, @required this.data, this.pedidosOracao, this.leituraFeita});

  String get dia => DateUtils.toShortDateString(data);
}