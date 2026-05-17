import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/utilities/lang.dart';

class GroupHistory extends ConsumerStatefulWidget {

  const GroupHistory({super.key});

  @override
  ConsumerState<GroupHistory> createState() => _GroupHistory();
}

class _GroupHistory extends ConsumerState<GroupHistory> {

@override
Widget build(BuildContext context) {
  final usuarioAsync = ref.watch(usuarioProvider);
  final screenHeight = MediaQuery.of(context).size.height;
  final grupo = ref.watch(currentGroupProvider);

  if(grupo==null){
    return Scaffold(
        body: Center(child: Text(context.lang.error_carga_grupo)),
    );
  }

  return Scaffold(
    body: SafeArea(
      child: usuarioAsync.when(
        data: (usuario) {
          if (usuario == null) {
            return const Center(child: Text("No hay usuario"));
          }

          return Column(
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

              // if(usuario.tipo=='admin')
              //   const NavigationBottomAdmin(currentIndex: -1) //-1 para que no marque ninguno
              // else
              //   const NavigationBottom(currentIndex: -1)
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