import 'package:culto_domestico_app/app/pedidos_oracao/usecases/validate_oracao_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UseCase', () {
    testeStringNula();
    testeStringVazia();
    testeDescricaoPequena();
    testeDescricaoValida();
  });
}

testeStringNula() {
  test('String nula', () {
    final useCase = ValidateOracaoUseCase();
    expect(useCase.validarDescricao(null), "Informação é um campo obrigatório");
  });
}

testeStringVazia() {
  test('String Vazia', () {
    final useCase = ValidateOracaoUseCase();
    expect(useCase.validarDescricao(""), "Informação é um campo obrigatório");
  });
}

testeDescricaoPequena() {
  test('Descricao pequena', () {
    final useCase = ValidateOracaoUseCase();
    expect(useCase.validarDescricao("Teste"),
        "Descreva melhor seu pedido de oração");
  });
}

testeDescricaoValida() {
  test('Descricao Válida', () {
    final useCase = ValidateOracaoUseCase();
    expect(useCase.validarDescricao("Descrição Grande"), null);
  });
}
