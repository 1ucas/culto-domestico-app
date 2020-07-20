import 'dart:ui';

import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:meta/meta.dart';

enum Severidade { agradecimento, normal, importante, urgente }

extension SeveridadeColor on Severidade {
  Color getColor() {
    switch (this) {
      case Severidade.urgente:
        return AppStyle.DangerColor;
        break;
      case Severidade.importante:
        return AppStyle.AccentColor;
        break;
      case Severidade.normal:
        return AppStyle.WarningColor;
        break;
      case Severidade.agradecimento:
        return AppStyle.SecondaryColor;
        break;
      default:
        return AppStyle.InactiveColor;
    }
  }
}

enum Categoria { saude, profissional, pessoal, casa, relacionamento, outro }

class PedidoOracao {
  final String texto;
  final Severidade severidade;
  final Categoria categoria;
  bool respondida;

  PedidoOracao(
      {@required this.texto,
      @required this.severidade,
      @required this.categoria,
      this.respondida = false});

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

  PedidoOracao.fromJson(Map<String, dynamic> json)
      : texto = json['texto'] as String,
        severidade = Severidade.values[json['severidade'] as int],
        categoria = Categoria.values[json['categoria'] as int],
        respondida = json['respondida'] as bool;

  Map<String, dynamic> toJson() => {
        'texto': texto,
        'severidade': severidade.index,
        'categoria': categoria.index,
        'respondida': respondida,
      };
}
