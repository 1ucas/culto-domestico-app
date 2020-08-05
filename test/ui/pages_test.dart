import 'package:culto_domestico_app/app/local/data/pedidos_oracao_mock_data.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/ui/nova_oracao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  Widget widget;
  Widget testApp;
  MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();

    testApp = Provider<PedidosOracaoRepository>(
      create: (context) => PedidosOracaoMockData(),
      child: MaterialApp(
        home: Scaffold(
          body: widget,
        ),
        navigatorObservers: [mockObserver],
      ),
    );
  });

  testeNovaOracaoPage() {
    widget = NovaOracaoPage();
    testWidgets("Inserir nova oração", (WidgetTester tester) async {
      await tester.pumpWidget(testApp);

      // Encontrou o Elemento Pagina
      expect(find.byType(NovaOracaoPage), findsOneWidget);

      // Encontra e preenche tela
      final categoriaField = find.byKey(Key('categoria-field'));
      expect(categoriaField, findsOneWidget);
      await tester.tap(categoriaField);
      await tester.pump();

      final categoriaListItem = find.byKey(Key('categoria-item-0'));
      expect(categoriaListItem, findsWidgets);
      await tester.tap(categoriaListItem.first);
      await tester.pump();

      final descricaoField = find.byKey(Key('descricao-field'));
      expect(descricaoField, findsOneWidget);
      await tester.tap(descricaoField);
      await tester.enterText(descricaoField, "descricao para sucesso");
      await tester.pump();

      // Ao clicar sai da tela
      final button = find.text("Salvar");
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump();

      verify(mockObserver.didPop(any, any));
    });
  }

  group("NovaOracaoPage", () {
    testeNovaOracaoPage();
  });
}
