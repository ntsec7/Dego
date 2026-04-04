import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/auth_provider.dart';
import 'package:dego/screens/login.dart';
import 'package:dego/screens/home_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(authProvider);

    if (user == null) {
      return const Login();
    } else {
      return const Homepage();
    }
  }
}