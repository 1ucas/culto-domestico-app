import 'package:shared_preferences/shared_preferences.dart';

/// Armazenamento chave/valor. Existe para que os repositórios possam ser
/// testados sem `SharedPreferences` e sem canal de plataforma.
abstract interface class Deposito {
  Future<String?> ler(String chave);
  Future<void> escrever(String chave, String valor);
}

class DepositoPreferencias implements Deposito {
  DepositoPreferencias([this._prefs]);

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instancia async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<String?> ler(String chave) async =>
      (await _instancia).getString(chave);

  @override
  Future<void> escrever(String chave, String valor) async =>
      (await _instancia).setString(chave, valor);
}

class DepositoMemoria implements Deposito {
  DepositoMemoria([Map<String, String>? inicial]) : _dados = {...?inicial};

  final Map<String, String> _dados;

  @override
  Future<String?> ler(String chave) async => _dados[chave];

  @override
  Future<void> escrever(String chave, String valor) async =>
      _dados[chave] = valor;
}
