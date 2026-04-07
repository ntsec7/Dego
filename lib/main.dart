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

void main() async{
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
