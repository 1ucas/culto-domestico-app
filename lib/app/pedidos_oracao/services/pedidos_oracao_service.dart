import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PedidosOracaoService {

  final PedidosOracaoRepository repositorio;

  PedidosOracaoService({required this.repositorio});
  
  Future<List<PedidoOracao>> listarPedidosOracao() async {
    return await repositorio.listarTodosPedidosOracao();
  }

  Future<void> inserirPedidoOracao(PedidoOracao oracao) async {
    await repositorio.inserirPedidoOracao(oracao);
  }

  Future<void> removerOracao(int oracaoId) async {
    await repositorio.removerOracao(oracaoId);
  }

  Future<void> atualizarOracaoRespondida(int oracaoId) async {
    await repositorio.atualizarOracaoRespondida(oracaoId);
  }
}
