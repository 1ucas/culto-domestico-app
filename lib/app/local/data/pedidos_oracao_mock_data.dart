import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class PedidosOracaoMockData extends PedidosOracaoRepository {
  static final _pedidoOracao1 = PedidoOracao(
    categoria: Categoria.pessoal,
    severidade: Severidade.normal,
    texto:
        "O Lucas precisa de pilhas para o mouse. Texto grande para testar quebra de linha. Segunda quebra de linha.",
  );
  static final _pedidoOracao2 = PedidoOracao(
    categoria: Categoria.saude,
    severidade: Severidade.normal,
    texto: "Segunda oração para testes rapidos.",
  );

  static final _pedidoOracao3 = PedidoOracao(
    categoria: Categoria.casa,
    severidade: Severidade.importante,
    texto: "Pedido sobre a casa nova.",
  );

  static final _pedidoOracao4 = PedidoOracao(
    categoria: Categoria.profissional,
    severidade: Severidade.urgente,
    texto: "Começando um emprego novo na empresa ABC.",
  );

  static final _pedidoOracao5 = PedidoOracao(
    categoria: Categoria.relacionamento,
    severidade: Severidade.importante,
    texto: "O cartão do supermercado acaba muito rapido com compras de pizza.",
  );

  static var _listaPedidos = List.of(<PedidoOracao>[
    _pedidoOracao1,
    _pedidoOracao2,
    _pedidoOracao3,
    _pedidoOracao4,
    _pedidoOracao5
  ]);

  static get listaMockito => _listaPedidos;

  Future<List<PedidoOracao>> listarTodosPedidosOracao() async {
    return _listaPedidos;
  }

  Future<void> inserirPedidoOracao(PedidoOracao oracao) async {
    _listaPedidos.add(oracao);
  }

  Future<void> removerOracao(int oracaoId) async {
    _listaPedidos.removeWhere((element) => element.hashCode == oracaoId);
  }

  Future<void> atualizarOracaoRespondida(int oracaoId) async {
    _listaPedidos.forEach((element) {
      if (element.hashCode == oracaoId) element.respondida = true;
    });
  }

  Future<void> atualizarDadosOracao({
    Function(List<PedidoOracao>) atualizacao,
  }) async {
    atualizacao(_listaPedidos);
  }
}
