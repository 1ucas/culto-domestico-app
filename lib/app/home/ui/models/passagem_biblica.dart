import 'package:meta/meta.dart';

enum Livro { genesis, exodo, levitico, numeros }

class PassagemBiblica {

  final Livro livro;
  final int capitulo;
  final List<int> versiculos;

  PassagemBiblica({@required this.livro, @required this.capitulo, @required this.versiculos});

}