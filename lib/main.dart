import 'package:dego/screens/create_decision.dart';
import 'package:dego/screens/create_group.dart';
import 'package:dego/screens/edit_decision.dart';
import 'package:dego/screens/edit_group.dart';
import 'package:dego/screens/edit_option.dart';
import 'package:dego/screens/group_history.dart';
import 'package:dego/screens/group_home_page.dart';
import 'package:dego/screens/group_members.dart';
import 'package:dego/screens/navigate_to_create_decision.dart';
import 'package:dego/screens/reset_password.dart';
import 'package:dego/screens/simple_vote.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  //activa riverpod en toda la app
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:dego/config/theme.dart';
import 'package:dego/screens/register.dart';
import 'package:dego/screens/login.dart';
import 'package:dego/screens/home_page.dart';
import 'package:dego/screens/auth_gate.dart';
import 'package:dego/screens/individual_home_page.dart';
import 'package:dego/screens/profile.dart';
import 'package:dego/screens/users_list.dart';
import 'package:dego/screens/notifications.dart';
import 'package:dego/screens/main_container.dart';
import 'package:dego/screens/group_container.dart';
import 'package:dego/screens/edit_user.dart';
import 'package:dego/screens/create_draft_option.dart';
import 'package:dego/screens/create_option.dart';
import 'package:dego/screens/see_decision.dart';
import 'package:dego/screens/see_option.dart';
import 'package:dego/screens/ranking_vote.dart';
import 'package:dego/screens/roulette_vote.dart';
import 'package:dego/screens/create_decision_watch.dart';
import 'package:dego/screens/watch_vote.dart';
import 'package:dego/screens/edit_decision_watch.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://iqnyxljnkjaxowvsapbs.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlxbnl4bGpua2pheG93dnNhcGJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNzU5MjksImV4cCI6MjA4OTk1MTkyOX0.C-sPr9ZqzqdREpDbvSlMdUdBUH8b49KkROzQaZQuhFc'
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}  

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      // final session = data.session;
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        // Usamos la navigatorKey para movernos a la pantalla sin errores de contexto
        navigatorKey.currentState?.pushNamed('resetPassword');
      }
      
      //Si es un registro nuevo (confirmación de email)
      // if (event == AuthChangeEvent.signedIn && session != null) {
      //   navigatorKey.currentState?.pushNamed('login');
      // }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false, //Para que no ponga "Demo"
      title: 'DEGO',

    //Tema
    theme: lightTheme,
    darkTheme:  darkTheme,
    themeMode: ThemeMode.system,  //Coge el tema del sistema

    //Idioma
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

      home: const AuthGate(),
      routes: {
        'register': (context) => Register(),
        'login' : (context) => Login(),
        'homePage' : (context) => Homepage(),
        'resetPassword' : (context) => ResetPassword(),
        'profile' : (context) => Profile(),
        'individualHomePage' : (context) => Individualhomepage(),
        'notifications' : (context) => Notifications(),
        'usersList' : (context) => Userslist(),
        'createGroup' : (context) => CreateGroup(),
        'groupHomePage' : (context) => GroupHomePage(),
        'mainContainer' : (context) => AppMainContainer(),
        'groupMembers' : (context) => GroupMembers(),
        'groupHistory' : (context) => GroupHistory(),
        'groupContainer' : (context) => GroupContainer(),
        'editGroup' : (context) => EditGroup(),
        'editUser' : (context) => EditUser(),
        'createDecision' : (context) => CreateDecision(),
        'createOptionDraft' : (context) {
          final int? index = ModalRoute.of(context)?.settings.arguments as int?;
          return CreateDraftOption(index: index);
        },
        'editDecision' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return EditDecision(id:id);
        },
        'editOption' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return EditOption(id:id);
        },
        'createOption' : (context) {
          final String decisionId = ModalRoute.of(context)?.settings.arguments as String;
          return CreateOption(decisionId:decisionId);
        },
        'seeDecision' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return SeeDecision(id:id);
        },
        'seeOption' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return SeeOption(id:id);
        },
        'simpleVote' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return SimpleVote(id:id);
        },
        'rankingVote' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return RankingVote(id:id);
        },
        'rouletteVote' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return RouletteVote(id:id);
        },
        'createDecisionWatch' : (context) => CreateDecisionWatch(),
        'watchVote' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return WatchVote(id:id);
        },
        'editDecisionWatch' : (context) {
          final String id = ModalRoute.of(context)?.settings.arguments as String;
          return EditDecisionWatch(id:id);
        },
        'navigateToCreateDecision' : (context) => NavigateToCreateDecision(),
      },
    );
  }
}
