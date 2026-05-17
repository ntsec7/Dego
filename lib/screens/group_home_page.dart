import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/utilities/lang.dart';

class GroupHomePage extends ConsumerStatefulWidget {

  const GroupHomePage({super.key});

  @override
  ConsumerState<GroupHomePage> createState() => _GroupHomePage();
}

class _GroupHomePage extends ConsumerState<GroupHomePage> {

@override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final grupo = ref.watch(currentGroupProvider);

  if(grupo==null){
    return Scaffold(
        body: Center(child: Text(context.lang.error_carga_grupo)),
    );
  }

  return Scaffold(
    body: SafeArea(
      child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Bienvenido a ${grupo.name}"),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await ref.read(authProvider.notifier).logout();
                              },
                              child: const Text("Cerrar sesión"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
      ),
    ),
  );
}
}