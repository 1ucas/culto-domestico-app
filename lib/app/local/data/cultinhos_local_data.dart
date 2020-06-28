import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/cultinhos/models/participante.dart';
import 'package:culto_domestico_app/app/home/ui/models/passagem_biblica.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';

class CultinhoLocalData {
  static final cultinho1 = Cultinho(
    data: DateTime.now(),
    leituraFeita: [
      PassagemBiblica(livro: Livro.genesis, capitulo: 1, versiculos: [1, 2, 3]),
      PassagemBiblica(livro: Livro.exodo, capitulo: 5, versiculos: [12, 13]),
    ],
    pedidosOracao: [],
    participantes: [
      Participante(nome: "Lucas"),
      Participante(nome: "Jaspion", orou: true),
    ],
  );

  static final cultinho2 = Cultinho(
    data: DateTime.now().add(Duration(days: -5)),
    leituraFeita: [
      PassagemBiblica(livro: Livro.numeros, capitulo: 1, versiculos: [1, 2, 3]),
      PassagemBiblica(livro: Livro.numeros, capitulo: 5, versiculos: [12, 13]),
    ],
    pedidosOracao: [
      PedidoOracao(
          texto: "Pedido de oração 1",
          categoria: Categoria.pessoal,
          severidade: Serveridade.normal),
      PedidoOracao(
          texto:
              "Pedido de oração 2 com um texto maior para ter quebra de linha na página de cultinhos",
          categoria: Categoria.saude,
          severidade: Serveridade.urgente),
    ],
    participantes: [
      Participante(nome: "Jack"),
      Participante(nome: "Antonio", orou: true),
    ],
  );

  static final cultinho3 = Cultinho(
    data: DateTime.now().add(Duration(days: -8)),
    leituraFeita: [
      PassagemBiblica(livro: Livro.numeros, capitulo: 1, versiculos: [1, 2, 3]),
      PassagemBiblica(livro: Livro.numeros, capitulo: 5, versiculos: [12, 13]),
    ],
    pedidosOracao: [
      PedidoOracao(
          texto: "Pedido de oração 1",
          categoria: Categoria.pessoal,
          severidade: Serveridade.normal),
      PedidoOracao(
          texto:
              "Pedido de oração 2 com um texto maior para ter quebra de linha na página de cultinhos",
          categoria: Categoria.profissional,
          severidade: Serveridade.urgente),
      PedidoOracao(
          texto:
              "Pedido de oração 3 com um texto maior para ter quebra de linha na página de cultinhos",
          categoria: Categoria.pessoal,
          severidade: Serveridade.importante),
      PedidoOracao(
          texto:
              "Pedido de oração 4 com um texto maior para ter quebra de linha na página de cultinhos",
          categoria: Categoria.saude,
          severidade: Serveridade.normal),
    ],
    participantes: [
      Participante(nome: "Lucas", orou: true),
      Participante(nome: "Jaspion", orou: true),
      Participante(nome: "Pericleison", orou: true),
    ],
  );


  static List<Cultinho> listarCultinhosFeitos() {
    return [cultinho1, cultinho2, cultinho3];
  }
}
