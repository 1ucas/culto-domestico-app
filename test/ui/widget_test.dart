import 'package:culto_domestico_app/app/utils/dropdown/app_numeric_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget widget;
  MaterialApp testApp;

  setUp(() {
    testApp = MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  });

  testeAppNumericFormField() {
    widget = AppNumericFormField(titulo: "Test-Title");
    testWidgets("Load", (WidgetTester tester) async {

      await tester.pumpWidget(testApp);

      // Encontrou o Elemento
      expect(find.byType(AppNumericFormField), findsOneWidget);
      expect(find.byType(FormField), findsNothing);
      expect(find.text("Test-Title"), findsOneWidget);

      // Verifica se o campo está habilitado
      final finder = find.byType(AppNumericFormField);
      final field = finder.evaluate().single.widget as AppNumericFormField;
      expect(field.enabled, true);
      expect(field.titulo, "Test-Title");
    });
  }

  group("AppNumericFormField", () {
    testeAppNumericFormField();
  });
}
