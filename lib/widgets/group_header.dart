import 'package:flutter/material.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';

class GroupHeader extends ConsumerWidget{

  const GroupHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    final grupo = ref.watch(currentGroupProvider);

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if(grupo==null){
      return SizedBox.shrink(); //no devuelve nada
    }

    return Padding(
      padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01),
      child: Row(                            
      children: [
        // IMAGEN
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.05,
            height: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.05,
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
        SizedBox(width: web ? screenWidth * 0.01 : screenWidth * 0.05), // Espacio entre foto y texto
        // --- TEXTO ---
        Expanded(
          child: Text(
            grupo.name,
            style:  TextStyle(
              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.02,
              fontWeight: FontWeight.bold,
              //color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          color: isDarkMode ? Color.fromARGB(255, 145, 162, 169) : Color.fromARGB(255, 95, 104, 108),
          onPressed: () {
            // Lógica para editar el grupo
            print('Editar grupo: ${grupo.id}');
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.redAccent,
          onPressed: () {
            // Lógica para eliminar el grupo
            print('Eliminar grupo: ${grupo.id}');
          },
        ),

      ],)
      
    );

  }

}