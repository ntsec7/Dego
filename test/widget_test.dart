  import 'package:dego/providers/decision_provider.dart';
import 'package:dego/screens/create_decision.dart';
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
import 'package:dego/providers/decision_draft_provider.dart';
import 'package:dego/models/option_draft.dart';
import 'package:dego/providers/current_group_provider.dart';

void main() {

  Widget createTestApp(
    Widget child, {
      List<Override> overrides = const [],
    }) {
    return ProviderScope(
      overrides: overrides,
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

  //SIMPLE VOTE
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

  //CREATE DECISION
  group('Create decision', (){

    testWidgets( 'The screen has the main elements' ,(tester) async{
      
      await tester.pumpWidget(
        createTestApp(
          const CreateDecision(),
           overrides: [
            idCurrentGroupProvider.overrideWith((ref) => '1'),
          ],
        ),
      );

      expect(find.text('Crear decisión'), findsOneWidget);
      expect(find.byKey(const Key('nameField')), findsOneWidget);
      expect(find.byKey(const Key('typeField')), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Abrir opciones'), findsOneWidget);
      expect(find.text('Fecha de finalización de las opciones'), findsOneWidget);
      expect(find.text('Fecha de finalización de la votación'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Empezar'), findsOneWidget);

    });

    testWidgets( 'Title is mandatory' ,(tester) async{

    await tester.pumpWidget(
      createTestApp(
        const CreateDecision(),
        overrides: [
          usuarioProvider.overrideWith((ref) async {
            return Usuario(
              id: '1',
              username: 'user1',
              name: 'user',
              tipo: 'client'
            );
          }),
        ],
      ),
    );

      await tester.pumpAndSettle();
      
      await tester.ensureVisible(find.text('Empezar'));
      await tester.tap(find.text('Empezar'));
      await tester.pumpAndSettle();

      expect(find.text('Campo obligatorio'), findsOneWidget);     

    });

    testWidgets( 'You can write the title' ,(tester) async{

    await tester.pumpWidget(
      createTestApp(
        const CreateDecision(),
        overrides: [
          usuarioProvider.overrideWith((ref) async {
            return Usuario(
              id: '1',
              username: 'user1',
              name: 'user',
              tipo: 'client'
            );
          }),
        ],
      ),
    ); 

      await tester.enterText(find.byKey(const Key('nameField')),'¿Qué cenamos?');    

      expect(find.text('¿Qué cenamos?'), findsOneWidget); 

    });

    testWidgets( 'You can change the type of decision' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(
          const CreateDecision(),
          overrides: [
            usuarioProvider.overrideWith((ref) async {
              return Usuario(
                id: '1',
                username: 'user1',
                name: 'user',
                tipo: 'client'
              );
            }),
          ],
        ),
      );

      await tester.tap(find.byKey(const Key('typeField')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ranking').last);
      await tester.pumpAndSettle();
 
    });

    testWidgets( 'If they\'re no options it doesn\'t allow to start ' ,(tester) async{

      await tester.pumpWidget(
        createTestApp(
          const CreateDecision(),
          overrides: [
            usuarioProvider.overrideWith((ref) async {
              return Usuario(
                id: '1',
                username: 'user1',
                name: 'user',
                tipo: 'client'
              );
            }),
          ],
        ),
      );

      await tester.enterText(find.byKey(const Key('nameField')),'Mi decisión');

      await tester.ensureVisible(find.text('Empezar'));
      await tester.tap(find.text('Empezar'));
      await tester.pumpAndSettle();

      expect(find.text('Error: Hace falta al menos 2 opciones para poder empezar'),findsOneWidget);

    });

  testWidgets( 'Options are shown' ,(tester) async{
      
    await tester.pumpWidget(
      createTestApp(
        const CreateDecision(),
        overrides: [
          decisionDraftProvider.overrideWith((ref) {
            final notifier = DecisionDraftNotifier();

            notifier.addOption(
              OptionDraft(title: 'Pizza', id_creator:'1', type:OptionType.standard),
            );

            notifier.addOption(
              OptionDraft(title: 'Hamburguesa', id_creator:'1', type:OptionType.standard),
            );

            return notifier;
          }),
        ],
      ),
    );

    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Hamburguesa'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsNWidgets(2));

  });

  testWidgets( 'Delete an option updates the options shown' ,(tester) async{
      
    await tester.pumpWidget(
      createTestApp(
        const CreateDecision(),
        overrides: [
          usuarioProvider.overrideWith((ref) async {
            return Usuario(
              id: '1',
              username: 'user1',
              name: 'user',
              tipo: 'client'
            );
          }),
          decisionDraftProvider.overrideWith((ref) {
            final notifier = DecisionDraftNotifier();

            notifier.addOption(
              OptionDraft(title: 'Pizza', id_creator:'1', type:OptionType.standard),
            );

            notifier.addOption(
              OptionDraft(title: 'Hamburguesa', id_creator:'1', type:OptionType.standard),
            );

            return notifier;
          }),
        ],
      ),
    );

    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Hamburguesa'), findsOneWidget);
    
    // Borra la primera
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    // Ahora solo queda una
    expect(find.text('Pizza'), findsNothing);
    expect(find.text('Hamburguesa'), findsOneWidget);

  });


  testWidgets( 'There\'s no vote date in roulette decisions' ,(tester) async{
      
    await tester.pumpWidget(
      createTestApp(
        const CreateDecision(),
        overrides: [
          usuarioProvider.overrideWith((ref) async {
            return Usuario(
              id: '1',
              username: 'user1',
              name: 'user',
              tipo: 'client'
            );
          }),
        ],
      ),
    );

      await tester.tap(find.byKey(const Key('typeField')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ruleta').last);
      await tester.pumpAndSettle();

      expect(find.text('Fecha final votación'), findsNothing);

  });

  });

}
