import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/grupo_provider.dart';
import 'package:dego/providers/current_group_provider.dart';

class Homepage extends ConsumerStatefulWidget {

  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _Homepage();
}

class _Homepage extends ConsumerState<Homepage> {

  late TextEditingController _searchController;
  String search = "";

  @override
  void initState() {
    super.initState();
    // Inicializar el controlador una sola vez
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // Es buena práctica liberar la memoria
    _searchController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  // final usuarioAsync = ref.watch(usuarioProvider);
  final gruposState = ref.watch(grupoProvider);

  
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;  //Para ver si el tema es claro u oscuro

  return Scaffold(
  body: SafeArea(
    child: Column( 
          children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: web? screenHeight * 0.03 : screenHeight * 0.02,
              horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,
            ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() { search = value.toLowerCase(); });
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

        Padding(
          padding:EdgeInsets.symmetric( horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,),
        child: Align(
              alignment: Alignment.centerLeft,    
          child: Row(
            children: [ 
            Text(
            context.lang.grupos,
            style: TextStyle(
              fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline, 
            )
            ),
            SizedBox(width: web ? screenWidth * 0.006 : screenWidth * 0.02),
            if(isDarkMode) //imagen blanca
              Image.asset( 
                'assets/images/IconoGrupoBlanco.png',
                width: web? screenWidth * 0.025 : screenWidth * 0.07,
              )
            else //Imagen oscura
             Image.asset( 
                'assets/images/IconoGrupo.png',
                width: web? screenWidth * 0.025 : screenWidth * 0.07,
              ),
            
            ],
          ),
        ),
        ),

            // LISTA DE GRUPOS
            Expanded( // Esto hace que la lista use todo el espacio central
              child: gruposState.when(
                data: (grupos) {
                  if (grupos.isEmpty) return const Center(child: Text(""));
                  
                  final gruposFiltrados = grupos.where((g) {
                    return g.name.toLowerCase().contains(search);
                  }).toList();

                  return ListView.builder(
                    padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01), // Espaciado alrededor de la lista
                    itemCount: gruposFiltrados.length,
                    itemBuilder: (context, index) {
                      final grupo = gruposFiltrados[index];
                      return GestureDetector(
                        onTap: () {
                          ref.read(idCurrentGroupProvider.notifier).state = grupo.id;  //actualizamos los datos de currentGroup
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: web ? screenHeight * 0.02 : screenHeight * 0.02), // Separación entre cuadros
                          padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.008 : (screenHeight + screenWidth) * 0.01),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 224, 224), 
                            borderRadius: BorderRadius.circular(30), // Bordes redondeados
                          ),
                          child: Row(
                            children: [
                              
                              // IMAGEN
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.03,
                                  height: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.03,
                                  color: Colors.grey[400], // Fondo por si la imagen falla
                                  child: grupo.image != null && grupo.image!.isNotEmpty
                                      ? Image.network(
                                          grupo.image!, // URL de Supabase
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => 
                                              Icon(Icons.group, size: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.02),
                                        )
                                      :  Icon(Icons.group, size: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.02), // Icono por defecto
                                ),
                              ),
                              SizedBox(width: web ? screenWidth * 0.01 : screenWidth * 0.03), // Espacio entre foto y texto
                              
                              // NOMBRE
                              Expanded(
                                child: Text(
                                  grupo.name,
                                  style:  TextStyle(
                                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text("Error: $e")),
              ),
            ),

          ],
    ),
  ),
);

}
}