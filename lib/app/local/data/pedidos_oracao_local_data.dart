import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PedidosOracaoLocalData {

  static final pedidoOracao1 = PedidoOracao(
    categoria: Categoria.pessoal,
    severidade: Serveridade.importante,
    texto:
        "O Lucas precisa de pilhas para o mouse. Texto grande para testar quebra de linha. Segunda quebra de linha.",
  );
  static final pedidoOracao2 = PedidoOracao(
    categoria: Categoria.saude,
    severidade: Serveridade.normal,
    texto:
        "Segunda oração para testes rapidos.",
  );

  static List<PedidoOracao> listarTodosPedidosOracao() {
    return [pedidoOracao1, pedidoOracao2];
  }
}
