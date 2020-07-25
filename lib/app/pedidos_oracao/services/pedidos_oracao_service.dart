import 'package:culto_domestico_app/app/local/data/pedidos_oracao_local_data.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PedidosOracaoService {
  
  Future<List<PedidoOracao>> listarPedidosOracao() async {
    return PedidosOracaoLocalData.listarTodosPedidosOracao();
  }

  Future<void> inserirPedidoOracao(PedidoOracao oracao) async {
    PedidosOracaoLocalData.inserirPedidoOracao(oracao);
  }

  Future<void> removerOracao(int oracaoId) async {
    PedidosOracaoLocalData.removerOracao(oracaoId);
  }

  Future<void> atualizarOracaoRespondida(int oracaoId) async {
    PedidosOracaoLocalData.atualizarOracaoRespondida(oracaoId);
  }
}
