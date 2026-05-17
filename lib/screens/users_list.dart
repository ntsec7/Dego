import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';

class Userslist extends ConsumerStatefulWidget {

  const Userslist({super.key});

  @override
  ConsumerState<Userslist> createState() => _Userslist();
}

class _Userslist extends ConsumerState<Userslist> {

  @override
@override
Widget build(BuildContext context) {
  final usuarioAsync = ref.watch(usuarioProvider);
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    body: SafeArea(
      child: usuarioAsync.when(
        data: (usuario) {
          if (usuario == null) {
            return const Center(child: Text("No hay usuario"));
          }

          return Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
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
                            Text("Bienvenido ${usuario.name}"),
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

                // const NavigationBottomAdmin(currentIndex: 1)

            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    ),
  );
}
}