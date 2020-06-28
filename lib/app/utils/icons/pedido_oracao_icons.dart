
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
      default:
        icone = Icons.home;
    }
    Icon iconeFinal;
    switch (pedido.severidade) {
      case Serveridade.urgente:
        iconeFinal = Icon(icone, color: Colors.red);
        break;
      case Serveridade.importante:
        iconeFinal = Icon(icone, color: Colors.yellow);
        break;
      default:
        iconeFinal = Icon(icone, color: Colors.black38);
    }
    return iconeFinal;
  }

}