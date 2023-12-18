
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

abstract class PedidosOracaoRepository {

    Future<List<PedidoOracao>> listarTodosPedidosOracao();
    Future<void> inserirPedidoOracao(PedidoOracao oracao);
    Future<void> removerOracao(int oracaoId);
    Future<void> atualizarOracaoRespondida(int oracaoId);
    Future<void> atualizarDadosOracao(
      {required Function(List<PedidoOracao>) atualizacao});
}