import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosOracaoLocalData {
  static Future<List<PedidoOracao>> listarTodosPedidosOracao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.get("oracoes");

    if (data != null) {
      var parsed = json.decode(data).cast<Map<String, dynamic>>();
      if (parsed != null) {
        var pedidos = parsed
            .map<PedidoOracao>((json) => PedidoOracao.fromJson(json))
            .toList();
        return pedidos;
      }
    }
    return [];
  }

  static Future<void> inserirPedidoOracao(PedidoOracao oracao) async {
    await atualizarDadosOracao(atualizacao: (pedidos) {
      pedidos.add(oracao);
    });
  }

  static Future<void> removerOracao(int oracaoId) async {
    await atualizarDadosOracao(atualizacao: (pedidos) {
      pedidos.removeWhere((element) => element.hashCode == oracaoId);
    });
  }

  static Future<void> atualizarOracaoRespondida(int oracaoId) async {
    await atualizarDadosOracao(atualizacao: (pedidos) {
      pedidos.forEach((element) {
        if (element.hashCode == oracaoId) element.respondida = true;
      });
    });
  }

  static Future<void> atualizarDadosOracao(
      {Function(List<PedidoOracao>) atualizacao}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pedidos = await listarTodosPedidosOracao();
    atualizacao(pedidos);
    var encoded = json.encode(pedidos);
    prefs.setString("oracoes", encoded);
  }
}
