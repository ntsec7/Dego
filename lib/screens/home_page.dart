import 'package:dego/providers/auth_provider.dart';
import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/widgets/navigation_bottom.dart';
import 'package:dego/widgets/navigation_bottom_admin.dart';

class Homepage extends ConsumerStatefulWidget {

  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _Homepage();
}

class _Homepage extends ConsumerState<Homepage> {

  @override
@override
Widget build(BuildContext context) {
  final usuarioAsync = ref.watch(usuarioProvider);

  final TextEditingController searchController = TextEditingController();
  
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

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

                            //BUSCADOR Y +
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: web ? 0 : screenWidth * 0.03 ,
                              ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      //print(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: context.lang.buscar_grupos,
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: web ? screenWidth * 0.02 : screenWidth * 0.03),

                                CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () => Navigator.pushNamed(context, 'createGroup'),
                                  ),
                                ),
                              ],
                            ),
                            ),
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

              if(usuario.tipo=='admin')
                const NavigationBottomAdmin(currentIndex: 0)
              else
                const NavigationBottom(currentIndex: 0)
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