import 'package:culto_domestico_app/app/local/data/pedidos_oracao_mock_data.dart';
import 'package:culto_domestico_app/app/local/data/pedidos_oracao_repository.dart';
import 'package:culto_domestico_app/app/pedidos_oracao/ui/nova_oracao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  Widget widget;
  Widget testApp;

  setUp(() {
    testApp = Provider<PedidosOracaoRepository>(
      create: (context) => PedidosOracaoMockData(),
      child: MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );
  });

  testeNovaOracaoPage() {
    widget = NovaOracaoPage();
    testWidgets("Load", (WidgetTester tester) async {
      await tester.pumpWidget(testApp);

      // Encontrou o Elemento
      expect(find.byType(NovaOracaoPage), findsOneWidget);

      // Ao clicar sai da tela
      final button = find.byType(FlatButton);
      await tester.tap(button);

      //expect(find.byType(NovaOracaoPage), findsNothing);
    });
  }

  group("NovaOracaoPage", () {
    testeNovaOracaoPage();
  });
}
