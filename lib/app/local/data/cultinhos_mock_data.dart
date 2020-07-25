import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';

class CultinhoMockData {

  // static get _cultinho1 => Cultinho(
  //   data: DateTime.now(),
  //   leituraFeita: [
  //     PassagemBiblica(livro: Livro.genesis, capitulos: [1], versiculos: [1, 2, 3]),
  //     PassagemBiblica(livro: Livro.exodo, capitulos: [5], versiculos: [12, 13]),
  //   ],
  //   pedidosOracao: [],
  //   quemOrou: "Lucas",
  // );

  // static get _cultinho2 => Cultinho(
  //   data: DateTime.now().add(Duration(days: -5)),
  //   leituraFeita: [
  //     PassagemBiblica(livro: Livro.numeros, capitulos: [1], versiculos: [1, 2, 3]),
  //     PassagemBiblica(livro: Livro.numeros, capitulos: [5], versiculos: [12, 13]),
  //   ],
  //   pedidosOracao: PedidosOracaoService().listarPedidosOracao().where((element) => element.severidade == Severidade.importante && !element.respondida).toList(),
  //   quemOrou: "Antonio",
  // );

  // static get _cultinho3 => Cultinho(
  //   data: DateTime.now().add(Duration(days: -8)),
  //   leituraFeita: [
  //     PassagemBiblica(livro: Livro.numeros, capitulos: [1], versiculos: [1, 2, 3]),
  //     PassagemBiblica(livro: Livro.numeros, capitulos: [5], versiculos: [12, 13]),
  //   ],
  //   pedidosOracao: PedidosOracaoService().listarPedidosOracao().where((element) => element.severidade == Severidade.urgente && !element.respondida).toList(),
  //   quemOrou: "Lucas 2",
  // );

  // static get _cultinho4 => Cultinho(
  //   data: DateTime.now().add(Duration(days: -8)),
  //   leituraFeita: [
  //     PassagemBiblica(livro: Livro.numeros, capitulos: [1], versiculos: [1, 2, 3]),
  //     PassagemBiblica(livro: Livro.numeros, capitulos: [5], versiculos: [12, 13]),
  //   ],
  //   pedidosOracao: PedidosOracaoService().listarPedidosOracao().where((element) => !element.respondida).toList(),
  //   quemOrou: "Jack",
  // );

  // static var _listaCultinhos = <Cultinho>[_cultinho1, _cultinho2, _cultinho3, _cultinho4].toList();

  // static List<Cultinho> listarCultinhosFeitos() {
  //   return _listaCultinhos;
  // }

  // static void removerCultinho({String id}) {
  //   _listaCultinhos.removeWhere((element) => element.id == id);
  // }

  // static void salvarNovoCultinho({Cultinho cultinho}) {
  //   _listaCultinhos.add(cultinho);
  // }

}
