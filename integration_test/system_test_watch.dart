import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:dego/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Create decision watch', (tester) async {
    
    app.main();
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('nameField')), 'prueba@gmail.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'Prueba_1234');

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.tap(find.text('Iniciar sesión'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Grupo de Prueba').evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.text('Grupo de Prueba'), findsOneWidget);

    await tester.tap(find.text('Grupo de Prueba'));
    await tester.pumpAndSettle();

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.byIcon(Icons.add).evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Sugerir películas o series').evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.text('Sugerir películas o series'), findsOneWidget);

    await tester.tap(find.text('Sugerir películas o series'));
    await tester.pumpAndSettle();

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Título').evaluate().isNotEmpty) {
        break;
      }
    }

    await tester.enterText(find.byKey(const Key('nameField')), 'Prueba de decision watch');

    await tester.tap(find.text('Peli'));

    await tester.tap(find.text('Netflix'));

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Fantasía').evaluate().isNotEmpty) {
        break;
      }
    }

    await tester.tap(find.text('Fantasía'));

    await tester.ensureVisible(find.text('Empezar'));
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Prueba de decision watch').evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.text('Prueba de decision watch'), findsOneWidget);

  });

  

}