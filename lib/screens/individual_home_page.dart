import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/widgets/navigation_bottom.dart';

class Individualhomepage extends ConsumerStatefulWidget {

  const Individualhomepage({super.key});

  @override
  ConsumerState<Individualhomepage> createState() => _Individualhomepage();
}

class _Individualhomepage extends ConsumerState<Individualhomepage> {

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

                const NavigationBottom(currentIndex: 1)
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