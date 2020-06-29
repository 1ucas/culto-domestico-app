import 'dart:ui';

import 'package:meta/meta.dart';

enum Serveridade { normal, importante, urgente }
enum Categoria { saude, profissional, pessoal }


class PedidoOracao {

  final String texto;
  final Serveridade severidade;
  final Categoria categoria;

  PedidoOracao({@required this.texto, @required this.severidade, @required this.categoria});

  @override
  int get hashCode => hashValues(texto, severidade, categoria);

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return texto == other.texto &&
        severidade == other.severidade &&
        categoria == other.categoria;
  }
}