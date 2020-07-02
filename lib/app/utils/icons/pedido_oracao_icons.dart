import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:flutter/material.dart';

class PedidoOracaoIcons {
  static Icon categoria(PedidoOracao pedido) {
    IconData icone;
    switch (pedido.categoria) {
      case Categoria.saude:
        icone = Icons.local_hospital;
        break;
      case Categoria.pessoal:
        icone = Icons.person;
        break;
      case Categoria.profissional:
        icone = Icons.work;
        break;
      case Categoria.casa:
        icone = Icons.home;
        break;
      case Categoria.relacionamento:
        icone = Icons.favorite;
        break;
      default:
        icone = Icons.home;
    }
    return Icon(icone, color: pedido.severidade.getColor());
  }
}
