import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/models/decision.dart';

class GroupHomePage extends ConsumerStatefulWidget {

  const GroupHomePage({super.key});

  @override
  ConsumerState<GroupHomePage> createState() => _GroupHomePage();
}

class _GroupHomePage extends ConsumerState<GroupHomePage> {

  void _deleteDecision(BuildContext context, Decision dec) {

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
          return AlertDialog(
          title: Text(context.lang.eliminar_decision),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.lang.eliminar_decision_txt(dec.title),
              ),
            ],
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

                  await ref.read(createProvider.notifier).deleteDecision(decisionId: dec.id);

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.lang.exito_eliminar_decision),
                      ),
                    );
                  }
                } catch (e) {
                  if(context.mounted){
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateSupabaseError(context,e))),
                    );
                  }
                }
              },
              child: Text(context.lang.aceptar),
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

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  final grupo = ref.watch(currentGroupProvider);
  final optionDecisions = ref.watch(optionDecisionsProvider);
  final voteDecisions = ref.watch(voteDecisionsProvider);

  final usuarioAsync = ref.watch(usuarioProvider);
  final currentUserId = usuarioAsync.value?.id;
  final currentUserType = usuarioAsync.value?.tipo;

  if(grupo==null){
    return Scaffold(
        body: Center(child: Text(context.lang.error_carga_grupo)),
    );
  }

  return Scaffold(
    body: SafeArea(
      child: Column(
            children: [

              //VOTAR
              Padding(
                padding:EdgeInsets.only( 
                  left: web ? screenWidth * 0.01 : screenWidth * 0.03 , 
                  right: web ? screenWidth * 0.01 : screenWidth * 0.03 , 
                  top: web ? screenHeight * 0.01 : screenHeight * 0.015),
              child: Align(
                    alignment: Alignment.centerLeft,    
                child: Row(
                  children: [
                  Text(
                  "${context.lang.votar}:",
                  style: TextStyle(
                    fontSize: web ? (screenHeight + screenWidth) *0.009 : (screenHeight + screenWidth) *0.015,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline, 
                  )
                  ),
                  SizedBox(width: web ? screenWidth * 0.007 : screenWidth * 0.02),
                  Icon(
                    Icons.how_to_vote_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  ],
                ),
              ),
              ),

            Expanded( // Esto hace que la lista use todo el espacio central
              child: voteDecisions.when(
                data: (voteDec) {
                  if (voteDec.isEmpty) return const Center(child: Text(""));

                  return ListView.builder(
                    padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01), // Espaciado alrededor de la lista
                    itemCount: voteDec.length,
                    itemBuilder: (context, index) {
                      final votDec = voteDec[index];
                      return GestureDetector(
                        // onTap: () {
                        // },
                        child: Container(
                          margin: EdgeInsets.only(bottom: web ? screenHeight * 0.02 : screenHeight * 0.02), // Separación entre cuadros
                          padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.008 : (screenHeight + screenWidth) * 0.01),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 224, 224), 
                            borderRadius: BorderRadius.circular(30), // Bordes redondeados
                          ),
                          child: Row(
                            children: [
                              
                              //TITULO
                              Expanded(
                                child: Text(
                                  votDec.title,
                                  style:  TextStyle(
                                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                            if(votDec.id_creator == currentUserId || currentUserType=='admin' ) ...[
                              //EDITAR
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: isDarkMode ? Color.fromARGB(255, 145, 162, 169) : Color.fromARGB(255, 95, 104, 108),
                                onPressed: () => Navigator.pushNamed(context, 'editDecision', arguments: votDec.id),
                              ),

                              //ELIMINAR
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () {
                                  _deleteDecision(context, votDec);
                                },
                              ),
                            ],

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

              //DAR OPCIONES
              Padding(
                padding:EdgeInsets.symmetric( horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,),
              child: Align(
                    alignment: Alignment.centerLeft,    
                child: Row(
                  children: [
                  Text(
                  "${context.lang.dar_opciones}:",
                  style: TextStyle(
                    fontSize: web ? (screenHeight + screenWidth) *0.009 : (screenHeight + screenWidth) *0.015,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline, 
                  )
                  ),
                  SizedBox(width: web ? screenWidth * 0.003 : screenWidth * 0.01),
                  Icon(
                    Icons.emoji_objects,
                    color: Colors.amber,
                  ),
                  ],
                ),
                ),
              ),

            Expanded( // Esto hace que la lista use todo el espacio central
              child: optionDecisions.when(
                data: (optionsDec) {
                  if (optionsDec.isEmpty) return const Center(child: Text(""));

                  return ListView.builder(
                    padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01), // Espaciado alrededor de la lista
                    itemCount: optionsDec.length,
                    itemBuilder: (context, index) {
                      final opDec = optionsDec[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'seeDecision', arguments: opDec.id);
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
                              
                              //TITULO
                              Expanded(
                                child: Text(
                                  opDec.title,
                                  style:  TextStyle(
                                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                              if(opDec.id_creator == currentUserId || currentUserType=='admin' ) ...[
                              
                              //EDITAR
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: isDarkMode ? Color.fromARGB(255, 145, 162, 169) : Color.fromARGB(255, 95, 104, 108),
                                onPressed: () => Navigator.pushNamed(context, 'editDecision', arguments: opDec.id),
                              ),

                              //ELIMINAR
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () {
                                  _deleteDecision(context, opDec);
                                },
                              ),

                              ],

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

              //NUEVA DECISIÓN
              Align(
                alignment: AlignmentGeometry.center,
                child: IconButton(
                  icon: const Icon(Icons.add,
                  weight: 900.0,),
                  color: Color(0xFF098238),
                  iconSize: web ? screenWidth * 0.03 : screenWidth * 0.15,
                  onPressed: () async{
                    Navigator.pushNamed(context, 'createDecision');
                  },
                ),
              )

              

            ],
      ),
    ),
  );
}
}