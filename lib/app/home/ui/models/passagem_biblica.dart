import 'package:meta/meta.dart';

enum Livro {
  genesis("Gênesis", 50),
  exodo("Êxodo", 40),
  levitico("Levítico", 27),
  numeros("Números", 36),
  deuteronomio("Deuteronômio", 34),
  josue("Josué", 24),
  juizes("Juízes", 21),
  rute("Rute", 4),
  samuel("I Samuel", 31),
  samuel2("II Samuel", 24),
  reis("I Reis", 22),
  reis2("II Reis", 25),
  cronicas("I Crônicas", 29),
  cronicas2("II Crônicas", 36),
  esdras("Esdras", 10),
  nemias("Neemias", 13),
  ester("Ester", 10),
  jo("Jó", 42),
  salmos("Salmos", 150),
  proverbios("Provérbios", 31),
  eclesiastes("Eclesiastes", 12),
  cantares("Cantares", 8),
  isaias("Isaías", 66),
  jeremias("Jeremias", 52),
  lamentacoes("Lamentações", 5),
  ezequiel("Ezequiel", 48),
  daniel("Daniel", 12),
  oseias("Oseias", 14),
  joel("Joel", 3),
  amos("Amós", 9),
  obadias("Obadias", 1),
  jonas("Jonas", 4),
  miqueias("Miqueias", 7),
  naum("Naum", 3),
  habacuque("Habacuque", 3),
  sofonias("Sofonias", 3),
  ageu("Ageu", 2),
  zacarias("Zacarias", 14),
  malaquias("Malaquias", 4),
  mateus("Mateus", 28),
  marcos("Marcos", 16),
  lucas("Lucas", 24),
  joao("João", 21),
  atos("Atos", 28),
  romanos("Romanos", 16),
  corintios("I Coríntios", 16),
  corintios2("II Coríntios", 13),
  galatas("Gálatas", 6),
  efesios("Efésios", 6),
  filipenses("Filipenses", 4),
  colossenses("Colessenses", 4),
  tessalonicenses("I Tessalonicenses", 5),
  tessalonicenses2("II Tessalonicenses", 3),
  timoteo("I Timóteo", 6),
  timoteo2("II Timóteo", 4),
  tito("Tito", 3),
  filemom("Filemom", 1),
  hebreus("Hebreus", 13),
  tiago("Tiago", 5),
  pedro("I Pedro", 5),
  pedro2("II Pedro", 3),
  joao1("I João", 5),
  joao2("II João", 1),
  joao3("III João", 1),
  judas("Judas", 1),
  apocalipse("Apocalipse", 22);

  final String nome;
  final int numCapitulos;

  const Livro(this.nome, this.numCapitulos);
}

class PassagemBiblica {
  final Livro livro;
  final List<int> capitulos;
  final List<int> versiculos;

  PassagemBiblica(
      {required this.livro,
      required this.capitulos,
      required this.versiculos});

  @override
  String toString() {
    final livro = this.livro.nome;
    var capitulos = "${this.capitulos[0].toString()}";
    if (this.capitulos.length == 2) {
      capitulos += " - ${this.capitulos[1].toString()}";
    }
    var versiculos = "${this.versiculos[0].toString()}";
    if (this.versiculos.length == 2) {
      versiculos += " - ${this.versiculos[1].toString()}";
    }

    return "$livro. $capitulos : $versiculos";
  }

  PassagemBiblica.fromJson(Map<String, dynamic> json)
      : livro = Livro.values[json['livro'] as int],
        capitulos = json['capitulos'].cast<int>(),
        versiculos = json['versiculos'].cast<int>();

  Map<String, dynamic> toJson() => {
        'livro': livro.index,
        'capitulos': capitulos,
        'versiculos': versiculos,
      };
}
