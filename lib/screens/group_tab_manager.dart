import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/screens/home_page.dart';
import 'package:dego/screens/group_container.dart';

class GroupTabManager extends ConsumerWidget {
  const GroupTabManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el ID del grupo seleccionado
    final idCurrentGroup = ref.watch(idCurrentGroupProvider);

    // Si no hay grupo seleccionado (asumiendo null o string vacío "" según tu provider)
    if (idCurrentGroup == null || idCurrentGroup.toString().isEmpty) {
      return const Homepage(); // Muestra la lista de búsqueda de grupos
    }

    // Si ya hay un ID de grupo, muestra el contenedor con las barras superiores
    return const GroupContainer(); 
  }
}