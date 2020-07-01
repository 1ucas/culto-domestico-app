import 'dart:ui';

import 'package:meta/meta.dart';

enum Severidade { agradecimento, normal, importante, urgente } 
enum Categoria { saude, profissional, pessoal, casa, relacionamento, outro }

class PedidoOracao {

  final String texto;
  final Severidade severidade;
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