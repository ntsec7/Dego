import 'package:dego/providers/users_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/usuario_provider.dart';

class Userslist extends ConsumerStatefulWidget {

  const Userslist({super.key});

  @override
  ConsumerState<Userslist> createState() => _Userslist();
}

class _Userslist extends ConsumerState<Userslist> {

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
 
  final usersState = ref.watch(userListProvider);

  
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;  //Para ver si el tema es claro u oscuro

  final usuarioAsync = ref.watch(usuarioProvider);
  final usuarioId = usuarioAsync.value?.id;

  return Scaffold(
  body: SafeArea(
    child: Column( 
          children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: web? screenHeight * 0.03 : screenHeight * 0.02,
              horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,
            ),
          child: 
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() { search = value.toLowerCase(); });
                  },
                  decoration: InputDecoration(
                    hintText: context.lang.buscar_usuarios,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
          ),

        Padding(
          padding:EdgeInsets.symmetric( horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,),
        child: Align(
              alignment: Alignment.centerLeft,    
          child: Row(
            children: [ 
            Text(
            context.lang.usuarios,
            style: TextStyle(
              fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline, 
            )
            ),
            SizedBox(width: web ? screenWidth * 0.006 : screenWidth * 0.02),
            if(isDarkMode) //imagen blanca
              Image.asset( 
                'assets/images/IconoListaUsuariosBlanco.png',
                width: web? screenWidth * 0.025 : screenWidth * 0.07,
              )
            else //Imagen oscura
             Image.asset( 
                'assets/images/IconoListaUsuarios.png',
                width: web? screenWidth * 0.025 : screenWidth * 0.07,
              ),
            
            ],
          ),
        ),
        ),

            // LISTA DE USUARIOS
            Expanded( // Esto hace que la lista use todo el espacio central
              child: usersState.when(
                data: (users) {
                  if (users.isEmpty) return const Center(child: Text(""));
                  
                  final FilterUsers = users.where((u) {
                    return (u.name.toLowerCase().contains(search) || u.username.toLowerCase().contains(search)) && u.id!=usuarioId;
                  }).toList();

                  return ListView.builder(
                    padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01), // Espaciado alrededor de la lista
                    itemCount: FilterUsers.length,
                    itemBuilder: (context, index) {
                      final user = FilterUsers[index];
                      return GestureDetector(
                        key: ValueKey(user.id),
                        onTap: () => {Navigator.pushNamed(context, 'homePage')},  //TODO LLEVAR A EDITAR USUARIO
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
                                  child: user.image != null && user.image!.isNotEmpty
                                      ? Image.network(
                                          user.image!, // URL de Supabase
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(
                                  user.name,
                                  style:  TextStyle(
                                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),

                                //USENAME
                                Text(
                                  user.username,
                                  style:  TextStyle(
                                    fontSize: web ? (screenHeight + screenWidth) * 0.009 : (screenHeight + screenWidth) * 0.012,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(221, 85, 85, 85),
                                  ),
                                ),
                            ],),
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