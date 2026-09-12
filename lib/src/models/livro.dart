/// Os 66 livros, na ordem canônica.
///
/// A ordem é also a chave de persistência: `Livro.values[index]` é o que está
/// gravado no aparelho desde a primeira versão do app. Nunca reordene nem
/// remova membros — só acrescente no fim, se um dia fizer sentido.
enum Livro {
  genesis('Gênesis', 'Gn', 50),
  exodo('Êxodo', 'Êx', 40),
  levitico('Levítico', 'Lv', 27),
  numeros('Números', 'Nm', 36),
  deuteronomio('Deuteronômio', 'Dt', 34),
  josue('Josué', 'Js', 24),
  juizes('Juízes', 'Jz', 21),
  rute('Rute', 'Rt', 4),
  samuel('I Samuel', '1Sm', 31),
  samuel2('II Samuel', '2Sm', 24),
  reis('I Reis', '1Rs', 22),
  reis2('II Reis', '2Rs', 25),
  cronicas('I Crônicas', '1Cr', 29),
  cronicas2('II Crônicas', '2Cr', 36),
  esdras('Esdras', 'Ed', 10),
  nemias('Neemias', 'Ne', 13),
  ester('Ester', 'Et', 10),
  jo('Jó', 'Jó', 42),
  salmos('Salmos', 'Sl', 150),
  proverbios('Provérbios', 'Pv', 31),
  eclesiastes('Eclesiastes', 'Ec', 12),
  cantares('Cantares', 'Ct', 8),
  isaias('Isaías', 'Is', 66),
  jeremias('Jeremias', 'Jr', 52),
  lamentacoes('Lamentações', 'Lm', 5),
  ezequiel('Ezequiel', 'Ez', 48),
  daniel('Daniel', 'Dn', 12),
  oseias('Oseias', 'Os', 14),
  joel('Joel', 'Jl', 3),
  amos('Amós', 'Am', 9),
  obadias('Obadias', 'Ob', 1),
  jonas('Jonas', 'Jn', 4),
  miqueias('Miqueias', 'Mq', 7),
  naum('Naum', 'Na', 3),
  habacuque('Habacuque', 'Hc', 3),
  sofonias('Sofonias', 'Sf', 3),
  ageu('Ageu', 'Ag', 2),
  zacarias('Zacarias', 'Zc', 14),
  malaquias('Malaquias', 'Ml', 4),
  mateus('Mateus', 'Mt', 28),
  marcos('Marcos', 'Mc', 16),
  lucas('Lucas', 'Lc', 24),
  joao('João', 'Jo', 21),
  atos('Atos', 'At', 28),
  romanos('Romanos', 'Rm', 16),
  corintios('I Coríntios', '1Co', 16),
  corintios2('II Coríntios', '2Co', 13),
  galatas('Gálatas', 'Gl', 6),
  efesios('Efésios', 'Ef', 6),
  filipenses('Filipenses', 'Fp', 4),
  colossenses('Colossenses', 'Cl', 4),
  tessalonicenses('I Tessalonicenses', '1Ts', 5),
  tessalonicenses2('II Tessalonicenses', '2Ts', 3),
  timoteo('I Timóteo', '1Tm', 6),
  timoteo2('II Timóteo', '2Tm', 4),
  tito('Tito', 'Tt', 3),
  filemom('Filemom', 'Fm', 1),
  hebreus('Hebreus', 'Hb', 13),
  tiago('Tiago', 'Tg', 5),
  pedro('I Pedro', '1Pe', 5),
  pedro2('II Pedro', '2Pe', 3),
  joao1('I João', '1Jo', 5),
  joao2('II João', '2Jo', 1),
  joao3('III João', '3Jo', 1),
  judas('Judas', 'Jd', 1),
  apocalipse('Apocalipse', 'Ap', 22);

  const Livro(this.nome, this.abreviacao, this.numCapitulos);

  final String nome;
  final String abreviacao;
  final int numCapitulos;

  /// Malaquias fecha o Antigo Testamento.
  bool get antigoTestamento => index <= Livro.malaquias.index;

  Testamento get testamento =>
      antigoTestamento ? Testamento.antigo : Testamento.novo;

  static List<Livro> doTestamento(Testamento testamento) =>
      Livro.values.where((l) => l.testamento == testamento).toList();
}

enum Testamento {
  antigo('Antigo Testamento'),
  novo('Novo Testamento');

  const Testamento(this.nome);
  final String nome;
}
