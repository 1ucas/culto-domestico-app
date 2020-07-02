import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PedidosOracaoLocalData {

  static final _pedidoOracao1 = PedidoOracao(
    categoria: Categoria.pessoal,
    severidade: Severidade.importante,
    texto:
        "O Lucas precisa de pilhas para o mouse. Texto grande para testar quebra de linha. Segunda quebra de linha.",
  );
  static final _pedidoOracao2 = PedidoOracao(
    categoria: Categoria.saude,
    severidade: Severidade.normal,
    texto:
        "Segunda oração para testes rapidos.",
  );

  static var _listaPedidos = List.of([_pedidoOracao1, _pedidoOracao2]);

  static List<PedidoOracao> listarTodosPedidosOracao() {
    return _listaPedidos;
  }

  static void inserirPedidoOracao(PedidoOracao oracao) {
    _listaPedidos.add(oracao);
  }

  static void removerOracao(int oracaoId) {
    _listaPedidos.removeWhere((element) => element.hashCode == oracaoId);
  }

  static void atualizarOracaoRespondida(int oracaoId) {
    _listaPedidos.forEach((element) {
      if(element.hashCode == oracaoId)
        element.respondida = true;
    });
  }
}
