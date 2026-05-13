import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/widgets/navigation_bottom.dart';
import 'package:dego/widgets/navigation_bottom_admin.dart';
import 'package:dego/providers/grupo_provider.dart';

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
  final gruposState = ref.watch(grupoProvider);

  final TextEditingController searchController = TextEditingController();
  
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  return Scaffold(
  body: SafeArea(
    child: usuarioAsync.when(
      data: (usuario) {
        if (usuario == null) return const Center(child: Text("No hay usuario"));

        return Column( 
          children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: web? screenHeight * 0.01 : screenHeight * 0.01,
              horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,
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

            // LISTA DE GRUPOS
            Expanded( // Esto hace que la lista use todo el espacio central
              child: gruposState.when(
                data: (grupos) {
                  if (grupos.isEmpty) return const Center(child: Text("No hay grupos"));
                  
                  return ListView.builder(
                    itemCount: grupos.length,
                    itemBuilder: (context, index) {
                      final grupo = grupos[index];
                      return ListTile(
                        title: Text(grupo.name),
                        leading: const Icon(Icons.group),
                        onTap: () { 
                          //TODO NAVEGAR AL GRUPO
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text("Error: $e")),
              ),
            ),

            if (usuario.tipo == 'admin')
              const NavigationBottomAdmin(currentIndex: 0)
            else
              const NavigationBottom(currentIndex: 0),
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