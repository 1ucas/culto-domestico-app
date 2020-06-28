import 'package:meta/meta.dart';

enum Serveridade { normal, importante, urgente }
enum Categoria { saude, profissional, pessoal }


class PedidoOracao {

  final String texto;
  final Serveridade severidade;
  final Categoria categoria;

  PedidoOracao({@required this.texto, @required this.severidade, @required this.categoria});

}