import 'package:culto_domestico_app/app/local/data/pedidos_oracao_local_data.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PedidosOracaoService {
  
  List<PedidoOracao> listarPedidosOracao() {
    return PedidosOracaoLocalData.listarTodosPedidosOracao();
  }

  void inserirPedidoOracao(PedidoOracao oracao) {
    PedidosOracaoLocalData.inserirPedidoOracao(oracao);
  }

  void removerOracao(int oracaoId){
    PedidosOracaoLocalData.removerOracao(oracaoId);
  }
}
