import 'package:culto_domestico_app/app/local/data/pedidos_oracao_mock_data.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/services/pedidos_oracao_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRepo extends Mock implements PedidosOracaoRepository {}

void main() {
  PedidosOracaoRepository repo;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    repo = MockRepo();
  });

  testeListarSucesso() {
    test('Listar Todos - Sucesso', () async {
      final service = PedidosOracaoService(repositorio: PedidosOracaoMockData());
      final lista = await service.listarPedidosOracao();
      expect(lista.length, 5);
    });
  }

  testeMockitoListarSucesso() {
    test('Listar Todos - Sucesso', () async {
      final service = PedidosOracaoService(repositorio: repo);

      when(repo.listarTodosPedidosOracao()).thenAnswer((_) => Future.value(PedidosOracaoMockData.listaMockito));

      final lista = await service.listarPedidosOracao();
      expect(lista.length, 5);
      verify(repo.listarTodosPedidosOracao()); 
    });
  }

  testeMockitoListarErro() {
    test('Listar Todos - Erro', () async {
      final service = PedidosOracaoService(repositorio: repo);

      when(repo.listarTodosPedidosOracao()).thenThrow(Exception("Erro"));

      expect(() async => await service.listarPedidosOracao(), throwsException);
      
    });
  }

  group('Oracao Service - Hardcode Mocked', () {
    testeListarSucesso();
  });

  group('Oracao Service - Mockito Mocked', () {
    testeMockitoListarSucesso();
    testeMockitoListarErro();
  });
}
