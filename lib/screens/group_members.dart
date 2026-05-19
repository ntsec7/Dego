import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/group_members_provider.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/models/notification.dart';
import 'package:dego/providers/auth_provider.dart';
import 'package:dego/providers/notification_provider.dart';

class GroupMembers extends ConsumerStatefulWidget {

  const GroupMembers({super.key});

  @override
  ConsumerState<GroupMembers> createState() => _GroupMembers();
}

class _GroupMembers extends ConsumerState<GroupMembers> {

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

  void _addMembers(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String? error;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
          return AlertDialog(
          title: Text(context.lang.anadir_miembro),
          content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.lang.anadir_miembro_txt,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: usernameController,
                // keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: context.lang.intro_username,
                  border: OutlineInputBorder(),
                  errorText: error,
                ),
                onChanged: (_) {
                  // Si el usuario vuelve a escribir, limpiamos el erro
                  if (error != null) {
                    setStateDialog(() => error = null);
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.lang.campo_obligatorio; 
                  }
                  return null; // Si devuelve null, significa que todo está correcto
                },
              ),
            ],
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.lang.cancelar),
            ),
            ElevatedButton(
              onPressed: () async {
                

                try {

                  final username = usernameController.text.trim();

                  final groupMembers = ref.watch(groupMembersProvider).value ?? [];

                  //Comprobamos si el usuario ya pertenece al grupo
                  final belongs = groupMembers.any(
                        (user) => user.username == username
                  );

                  if(belongs){
                    setStateDialog(() {
                      error = context.lang.usuario_pertenece_grupo;
                    });
                    return;
                  }

                  final idUser= await ref.read(authProvider.notifier).getUserId(username);

                  if (idUser==null){
                    setStateDialog(() {
                      error = context.lang.username_no_existe;
                    });
                    return;
                  }

                  final idCreator = ref.read(usuarioProvider).value!.id; // El usuario actual
                  final idGroup = ref.read(currentGroupProvider)!.id;

                  final notification= NotificationModel(id_user:idUser, id_creator_user:idCreator, id_group:idGroup, type:'invite_group');

                  await ref.read(NotificationsProvider.notifier).createNotification(notification);

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.lang.invitacion_enviada),
                      ),
                    );
                  }
                } catch (e) {
                  if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(translateSupabaseError(context,e))),
                  );
                  }
                }
              },
              child: Text(context.lang.enviar),
            ),
          ],
          );
          },
        );
      },
    );
}


@override
Widget build(BuildContext context) {
  final groupMembers = ref.watch(groupMembersProvider);

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

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
                    hintText: context.lang.buscar_miembros,
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
                  onPressed: () => _addMembers(context),
                ),
              ),
            ],
          ),
          ),

        Padding(
          padding:EdgeInsets.symmetric( horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,),
        child: Align(
              alignment: Alignment.centerLeft,    
          child:
            Text(
            "${context.lang.miembros}:",
            style: TextStyle(
              fontSize: web ? (screenHeight + screenWidth) *0.009 : (screenHeight + screenWidth) *0.015,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline, 
            )
            ),
          ),
        ),

            // LISTA DE GRUPOS
            Expanded( // Esto hace que la lista use todo el espacio central
              child: groupMembers.when(
                data: (members) {
                  if (members.isEmpty) return const Center(child: Text(""));
                  
                  final filteredMembers = members.where((user) {
                    return user.name.toLowerCase().contains(search);
                  }).toList();

                  return ListView.builder(
                    padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01), // Espaciado alrededor de la lista
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final user = filteredMembers[index];
                      return GestureDetector(
                        onTap: () {
                          // ref.read(idCurrentGroupProvider.notifier).state = grupo.id;  //actualizamos los datos de currentGroup
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
                              
                              //NOMBRE Y USERNAME
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

                              //ELIMINAR
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () {
                                  // Lógica para eliminar el grupo
                                },
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