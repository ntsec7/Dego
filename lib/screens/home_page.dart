import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';

class Homepage extends ConsumerStatefulWidget {

  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _Homepage();
}

class _Homepage extends ConsumerState<Homepage> {

  @override
  Widget build(BuildContext context) {
    
    final usuarioAsync = ref.watch(usuarioProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final textFieldWidth = screenWidth * 0.5;

    return Scaffold(
     body: Center (
      child: usuarioAsync.when(
        data: (usuario) {
          if (usuario == null){
            return const Text("No hay usuario");
          }
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
        );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text("Error: $e"),
      ),
     ),
    );
  }
}