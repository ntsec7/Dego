import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:dego/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login successfully', (tester) async {
    
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

      if (find.text('Votacion').evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.text('Votacion'), findsOneWidget);

    await tester.tap(find.text('Votacion'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.radio_button_unchecked).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Votar'));
    await tester.pumpAndSettle();

  });

  

}