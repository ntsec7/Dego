import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:dego/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register', (tester) async {
    
    app.main();
    await tester.pumpAndSettle();

    // await tester.enterText(find.byKey(const Key('nameField')), 'prueba@gmail.com');
    // await tester.enterText(find.byKey(const Key('passwordField')), 'Prueba_1234');

    // await tester.testTextInput.receiveAction(TextInputAction.done);
    // await tester.pump();

    await tester.tap(find.text('Registrarse'));

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Nombre de usuario').evaluate().isNotEmpty) {
        break;
      }
    }

    await tester.enterText(find.byKey(const Key('usernameField')), 'usuario_prueba');
    await tester.enterText(find.byKey(const Key('nameField')), 'Usuario Prueba');
    await tester.enterText(find.byKey(const Key('emailField')), 'usuarioprueba@gmail.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'Prueba_1234');
    await tester.enterText(find.byKey(const Key('password2Field')), 'Prueba_1234');

    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 200));

      if (find.text('Diríjase a su correo electrónico para confirmar su cuenta.').evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.text('Diríjase a su correo electrónico para confirmar su cuenta.'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

  });

  

}