import 'package:dego/providers/decision_provider.dart';
import 'package:dego/screens/simple_vote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dego/screens/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dego/l10n/app_localizations.dart';
import 'package:dego/screens/register.dart';
import 'package:dego/models/decision.dart';
import 'package:dego/models/option.dart';
import 'package:dego/models/usuario.dart';
import 'package:dego/providers/usuario_provider.dart';

void main() {

  Widget createTestApp(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
        ],
        locale: const Locale('es'),
        home: child,
      ),
    );
  }

  Widget createSimpleVoteTestApp({
    required Decision decision,
    required List<Option> options,
    required Usuario usuario,
  }) {
    return ProviderScope(
      overrides: [
        decisionByIdProvider.overrideWith(
          (ref, id) => Stream.value(decision),
        ),

        optionsByDecisionProvider.overrideWith(
          (ref, id) => Stream.value(options),
        ),

        usuarioProvider.overrideWith(
          (ref) async => usuario,
        ),
      ],
      child: createTestApp(
        SimpleVote(id: decision.id),
      ),
    );
  }

  //LOGIN SCREEN
  group('Login screen', () {

    testWidgets( 'The screen has the main elements' ,(tester) async{
      
      await tester.pumpWidget(
        createTestApp(const Login()),
      );

      expect(find.byKey(const Key('nameField')), findsOneWidget);

      expect(find.byKey(const Key('passwordField')), findsOneWidget);

      expect(find.text('DEGO'), findsOneWidget);
    });

    testWidgets( 'Empty form returns two errors' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Login()),
      );
      
      await tester.tap(find.text('Iniciar sesión'));

      await tester.pump();

      expect(find.text('Campo obligatorio'), findsNWidgets(2));

    });

    testWidgets( 'You can write username and password' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Login()),
      ); 

      await tester.enterText(find.byKey(const Key('nameField')),'juan');    

      expect(find.text('juan'), findsOneWidget); 

    });

    testWidgets( 'The eye icon changes the visibility of the password' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Login()),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
 
    });

    testWidgets( ' "He olvidado mi contraseña" open the dialog, which has "Enviar" and "Cancelar" ' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Login()),
      );

      await tester.tap(find.text('He olvidado mi contraseña'));

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      expect(find.text('Enviar'), findsOneWidget);

      expect(find.text('Cancelar'), findsOneWidget);

    });

  });


  //REGISTER
  group('Register screen', (){

    testWidgets( 'The screen has the main elements' ,(tester) async{
      
      await tester.pumpWidget(
        createTestApp(const Register()),
      );

      expect(find.byKey(const Key('usernameField')), findsOneWidget);
      expect(find.byKey(const Key('nameField')), findsOneWidget);
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('password2Field')), findsOneWidget);
      expect(find.text('Registrarse'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

    });

    testWidgets( 'Empty form returns five errors' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Register()),
      );

      await tester.ensureVisible(find.text('Registrarse'));
      
      await tester.tap(find.text('Registrarse'));
      
      await tester.pump();

      expect(find.text('Campo obligatorio'), findsNWidgets(5));

    });

    testWidgets( 'You can write in all form fields' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Register()),
      ); 

      await tester.enterText(find.byKey(const Key('usernameField')),'juan_');
      await tester.enterText( find.byKey(const Key('nameField')), 'juan');  
      await tester.enterText(find.byKey(const Key('emailField')),'juan@gmail.com');  
      await tester.enterText(find.byKey(const Key('passwordField')), 'password');
      await tester.enterText(find.byKey(const Key('password2Field')), 'password2');

      expect(find.text('juan_'), findsOneWidget);
      expect(find.text('juan'), findsOneWidget);
      expect(find.text('juan@gmail.com'), findsOneWidget);
      expect(find.text('password'), findsOneWidget);
      expect(find.text('password2'), findsOneWidget);

    });

    testWidgets( 'The first eye icon changes the visibility of the password' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Register()),
      );

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
 
    });

    testWidgets( 'The second eye icon changes the visibility of the password' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Register()),
      );

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_off).last);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
 
    });

    testWidgets( 'Different passwords return an error' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(const Register()),
      );

      await tester.enterText(find.byKey(const Key('passwordField')), 'Abcdef.9');

      await tester.enterText(find.byKey(const Key('password2Field')),'Abcdef:9');

      await tester.ensureVisible(find.text('Registrarse'));

      await tester.tap(find.text('Registrarse'));

      await tester.pump();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);

    });

  });

  group('Simple Vote', (){

    final decision = Decision(
      id: '1',
      id_creator : '1',
      title: 'Elegir restaurante',
      state: DecisionState.vote,
      type: DecisionType.simple,
      votes: false,
    );

    final usuario = Usuario(
      id: '1',
      username: 'username',
      name: 'name',
      tipo: 'client',
    );

    final options = [
      Option(
        id: '1',
        id_decision: '1',
        id_creator: '1',
        title: 'Dominos',
        type: OptionType.standard
      ),
      Option(
        id: '2',
        id_decision: '1',
        id_creator: '1',
        title: 'Burger King',
        type: OptionType.standard
      ),
    ];
    
    testWidgets('The main elements are shown', (tester) async{

      await tester.pumpWidget(
        createSimpleVoteTestApp(
          decision: decision,
          options: options,
          usuario: usuario,
        ),
      );

      await tester.pump();

      expect(find.text('Elegir restaurante'), findsOneWidget);
      expect(find.text('Dominos'), findsOneWidget);
      expect(find.text('Burger King'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(2));
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Votar'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('An option is selected', (tester) async{

      await tester.pumpWidget(
        createSimpleVoteTestApp(
          decision: decision,
          options: options,
          usuario: usuario,
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsNothing);

      await tester.tap(find.byIcon(Icons.radio_button_unchecked).first);
      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Only an option is selected', (tester) async{

      await tester.pumpWidget(
        createSimpleVoteTestApp(
          decision: decision,
          options: options,
          usuario: usuario,
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsNothing);

      await tester.tap(find.byIcon(Icons.radio_button_unchecked).first);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.radio_button_unchecked).last);
      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Vote without an option selected returns an error', (tester) async{

      await tester.pumpWidget(
        createSimpleVoteTestApp(
          decision: decision,
          options: options,
          usuario: usuario,
        ),
      );

      await tester.pump();

      await tester.tap(find.text('Votar'));
      await tester.pump();

      expect(find.text('Error: Selecciona una opción para votar'), findsOneWidget);
    });

  });

}
