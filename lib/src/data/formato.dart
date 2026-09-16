import 'package:intl/intl.dart';

/// Formatação de data em pt_BR. Centralizada porque a data aparece em três
/// larguras diferentes: numeral da margem, linha do registro e cabeçalho.
abstract final class Formato {
  static final _dia = DateFormat('dd', 'pt_BR');
  static final _mesCurto = DateFormat('MMM', 'pt_BR');
  static final _completa = DateFormat("d 'de' MMMM 'de' y", 'pt_BR');
  static final _curta = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final _compacta = DateFormat('d/M/yy', 'pt_BR');
  static final _mesAno = DateFormat("MMMM 'de' y", 'pt_BR');
  static final _diaEMes = DateFormat("d 'de' MMMM", 'pt_BR');

  static String dia(DateTime data) => _dia.format(data);

  /// `SET` — vai em versalete, na margem.
  static String mes(DateTime data) =>
      _mesCurto.format(data).replaceAll('.', '').toUpperCase();

  static String completa(DateTime data) => _completa.format(data);

  /// `10 de setembro` — quando o ano já está claro pelo contexto.
  static String diaEMes(DateTime data) => _diaEMes.format(data);

  static String curta(DateTime data) => _curta.format(data);

  /// `9/9/26` — para caber dentro de uma etiqueta.
  static String compacta(DateTime data) => _compacta.format(data);

  static String mesAno(DateTime data) {
    final texto = _mesAno.format(data);
    return texto[0].toUpperCase() + texto.substring(1);
  }

  static String plural(int quantidade, String singular, String plural) =>
      quantidade == 1 ? '$quantidade $singular' : '$quantidade $plural';

  /// A saudação da hora. O cultinho quase sempre é de noite, e abrir o app
  /// com um "boa noite" faz a tela parecer da casa.
  static String saudacao([DateTime? agora]) {
    final hora = (agora ?? DateTime.now()).hour;
    // Quem abre o app de madrugada ainda está na noite anterior.
    if (hora < 5) return 'Boa noite';
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }
}
