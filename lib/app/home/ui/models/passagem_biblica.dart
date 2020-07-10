import 'package:meta/meta.dart';

enum Livro { genesis, exodo, levitico, numeros, deuteronomio, josue, juizes, rute, samuel, samuel2, reis, reis2, cronicas, cronicas2, esdras, nemias, ester, jo }

extension DetalhesLivros on Livro {

  String get nome => const {
    Livro.genesis: "Gênesis",
    Livro.exodo: "Êxodo",
    Livro.levitico: "levítico",
    Livro.numeros: "Números",
    Livro.deuteronomio: "Deuteronômio",
    Livro.josue: "Josué",
    Livro.juizes: "Juízes",
    Livro.rute: "Rute",
    Livro.samuel: "I Samuel",
    Livro.samuel2: "II Samuel",
    Livro.reis: "I Reis",
    Livro.reis2: "II Reis",
    Livro.cronicas: "I Crônicas",
    Livro.cronicas2: "II Crônicas",
    Livro.esdras: "Esdras",
    Livro.nemias: "Neemias",
    Livro.ester: "Ester",
    Livro.jo: "Jó",
  }[this];

  int get numCapitulos => const {
    Livro.genesis: 1,
    Livro.exodo: 2,
    Livro.levitico: 3,
    Livro.numeros: 4,
    Livro.deuteronomio: 5,
    Livro.josue: 6,
    Livro.juizes: 7,
    Livro.rute: 8,
    Livro.samuel: 9,
    Livro.samuel2: 10,
    Livro.reis: 11,
    Livro.reis2: 12,
    Livro.cronicas: 13,
    Livro.cronicas2: 14,
    Livro.esdras: 15,
    Livro.nemias: 16,
    Livro.ester: 17,
    Livro.jo: 18,
  }[this];

  List<int> get numVersiculos => const {
    Livro.genesis: [1],
    Livro.exodo: [2, 2],
    Livro.levitico: [2, 2],
    Livro.numeros: [2, 2],
    Livro.deuteronomio: [2, 2],
    Livro.josue: [2, 2],
    Livro.juizes: [2, 2],
    Livro.rute: [2, 2],
    Livro.samuel: [2, 2],
    Livro.samuel2: [2, 2],
    Livro.reis: [2, 2],
    Livro.reis2: [2, 2],
    Livro.cronicas: [2, 2],
    Livro.cronicas2: [2, 2],
    Livro.esdras: [2, 2],
    Livro.nemias: [2, 2],
    Livro.ester: [2, 2],
    Livro.jo: [2, 2],
  }[this];

}

class PassagemBiblica {

  final Livro livro;
  final List<int> capitulos;
  final List<int> versiculos;

  PassagemBiblica({@required this.livro, @required this.capitulos, @required this.versiculos});

  @override
  String toString() 
  {
    final livro = this.livro.nome.substring(0, 2);
    var capitulos = "${this.capitulos[0].toString()}";
    if(this.capitulos.length == 2) {
      capitulos += " - ${this.capitulos[1].toString()}";
    }
    var versiculos = "${this.versiculos[0].toString()}";
    if(this.versiculos.length == 2) {
      versiculos += " - ${this.versiculos[1].toString()}";
    }

    return "$livro. $capitulos : $versiculos";
  }

}