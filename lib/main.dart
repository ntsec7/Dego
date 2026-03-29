import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/screens/register.dart';

void main() async{
  await Supabase.initialize(
      url: 'https://iqnyxljnkjaxowvsapbs.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlxbnl4bGpua2pheG93dnNhcGJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNzU5MjksImV4cCI6MjA4OTk1MTkyOX0.C-sPr9ZqzqdREpDbvSlMdUdBUH8b49KkROzQaZQuhFc'
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Para que no ponga "Demo"
      title: 'DEGO',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: 'register',
      routes: {
        'register': (context) => Register(),
      },
    );
  }
}
