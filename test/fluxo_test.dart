import 'package:culto_domestico_app/src/app.dart';
import 'package:culto_domestico_app/src/data/deposito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR', null));

  Future<void> abrirApp(WidgetTester tester, [Deposito? deposito]) async {
    await tester.pumpWidget(
      CultoDomesticoApp(deposito: deposito ?? DepositoMemoria()),
    );
    await tester.pumpAndSettle();
  }

  /// A aba fica na barra flutuante, depois do `IndexedStack` na árvore.
  Future<void> irParaOracoes(WidgetTester tester) async {
    await tester.tap(find.text('Orações').last);
    await tester.pumpAndSettle();
  }

  /// Marca o pedido aberto na folha de ações e fecha a tela de celebração.
  Future<void> responderPedido(WidgetTester tester, String texto) async {
    await tester.tap(find.text(texto));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar como respondida'));

    // A celebração anima em laço: aqui ela é bombeada à mão, não assentada.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Deus respondeu'), findsOneWidget);

    await tester.tap(find.text('Amém'));
    await tester.pumpAndSettle();
  }

  Future<void> criarPedido(WidgetTester tester, String texto) async {
    await tester.tap(find.text('Novo pedido').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), texto);
    await tester.tap(find.text('Guardar pedido'));
    await tester.pumpAndSettle();
  }

  testWidgets('abre nas duas listas vazias', (tester) async {
    await abrirApp(tester);

    expect(find.text('Nenhum cultinho ainda'), findsOneWidget);

    await irParaOracoes(tester);
    expect(find.text('Nenhum pedido ainda'), findsOneWidget);
  });

  testWidgets('registra um pedido de oração e ele aparece na lista',
      (tester) async {
    await abrirApp(tester);
    await irParaOracoes(tester);

    await tester.tap(find.text('Novo pedido').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Saúde da vovó Maria');
    await tester.tap(find.text('Saúde'));
    await tester.tap(find.text('Urgente'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar pedido'));
    await tester.pumpAndSettle();

    expect(find.text('Saúde da vovó Maria'), findsOneWidget);
    // Severidade e categoria viram etiquetas separadas no cartão.
    expect(find.text('Urgente'), findsOneWidget);
    expect(find.text('Saúde'), findsOneWidget);
  });

  testWidgets('recusa um pedido curto demais', (tester) async {
    await abrirApp(tester);
    await irParaOracoes(tester);

    await tester.tap(find.text('Novo pedido').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'curto');
    await tester.tap(find.text('Guardar pedido'));
    await tester.pumpAndSettle();

    expect(
      find.text('Descreva um pouco mais — pelo menos 10 letras'),
      findsOneWidget,
    );
  });

  testWidgets('marca um pedido como respondido e ele vai para Respostas',
      (tester) async {
    await abrirApp(tester);
    await irParaOracoes(tester);
    await criarPedido(tester, 'Emprego novo para o Zé');
    await responderPedido(tester, 'Emprego novo para o Zé');

    expect(find.text('Emprego novo para o Zé'), findsNothing);
    expect(find.text('Nada em aberto agora'), findsOneWidget);

    await tester.tap(find.textContaining('Respostas'));
    await tester.pumpAndSettle();
    expect(find.text('Emprego novo para o Zé'), findsOneWidget);
  });

  testWidgets('reabrir devolve o pedido para a lista de oração',
      (tester) async {
    await abrirApp(tester);
    await irParaOracoes(tester);
    await criarPedido(tester, 'Emprego novo para o Zé');
    await responderPedido(tester, 'Emprego novo para o Zé');

    await tester.tap(find.textContaining('Respostas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Emprego novo para o Zé'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voltar para a lista de oração'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Em oração'));
    await tester.pumpAndSettle();
    expect(find.text('Emprego novo para o Zé'), findsOneWidget);
  });

  testWidgets('registra um cultinho com leitura e ele entra no histórico',
      (tester) async {
    await abrirApp(tester);

    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Novo cultinho'), findsOneWidget);

    // 'Escolher' aparece em Leitura e em Pedidos; a leitura vem primeiro.
    await tester.tap(find.text('Escolher').first);
    await tester.pumpAndSettle();

    // Salmos 1 : 1 é o estado inicial do seletor.
    expect(find.text('Salmos 1:1'), findsOneWidget);

    await tester.tap(find.text('Salmos'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'joao');
    await tester.pumpAndSettle();
    await tester.tap(find.text('João'));
    await tester.pumpAndSettle();

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), '3');
    await tester.enterText(campos.at(2), '16');
    await tester.pumpAndSettle();
    expect(find.text('João 3:16'), findsOneWidget);

    await tester.tap(find.text('Usar esta leitura'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Lucas');
    await tester.tap(find.text('Guardar cultinho'));
    await tester.pumpAndSettle();

    // O bloco de destaque, no topo da tela.
    expect(find.text('João 3:16'), findsOneWidget);
    expect(find.text('1 cultinho'), findsOneWidget);
    expect(find.text('1 vez'), findsOneWidget);

    // E o cartão do histórico, abaixo do ritmo e da jornada.
    await tester.scrollUntilVisible(find.text('Orou Lucas'), 250);
    await tester.pumpAndSettle();
    expect(find.text('Orou Lucas'), findsOneWidget);
  });

  testWidgets('impede um capítulo que não existe no livro escolhido',
      (tester) async {
    await abrirApp(tester);

    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Escolher').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '200');
    await tester.tap(find.text('Usar esta leitura'));
    await tester.pumpAndSettle();

    expect(find.text('Salmos vai até 150'), findsOneWidget);
  });

  testWidgets('leva pedidos abertos para um cultinho novo', (tester) async {
    await abrirApp(tester);
    await irParaOracoes(tester);
    await criarPedido(tester, 'Saúde da vovó Maria');

    await tester.tap(find.text('Cultinhos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Escolher').last);
    await tester.pumpAndSettle();
    expect(find.text('Pedidos de hoje'), findsOneWidget);

    await tester.tap(find.text('Saúde da vovó Maria'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Levar 1 pedido'));
    await tester.pumpAndSettle();

    expect(find.text('1 pedido'), findsOneWidget);

    await tester.tap(find.text('Guardar cultinho'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sem leitura anotada').last);
    await tester.pumpAndSettle();
    expect(find.text('Pedidos levados · 1'), findsOneWidget);
    expect(find.text('Saúde da vovó Maria'), findsOneWidget);
  });
}
