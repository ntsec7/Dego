import 'package:dego/models/usuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/providers/grupo_provider.dart';


// Provider que maneja el Stream de los miembros en tiempo real
final groupMembersProvider = StreamProvider.autoDispose<List<Usuario>>((ref) {
  final service = ref.watch(grupoServiceProvider);
  final groupId = ref.watch(idCurrentGroupProvider);

  // Si no hay grupo seleccionado, devolvemos un stream vacío
  if (groupId == null) return Stream.value([]);

  // Escuchamos el stream de group_members
  return service.streamGroupMembers(groupId).asyncMap((miembrosRaw) async {
    // Extraemos todos los id_user de los miembros actuales
    final userIds = miembrosRaw.map((m) => m['id_user'].toString()).toList();

    if (userIds.isEmpty) return [];

    final users = await service.obteinUsersProfiles(userIds);

    return users;
  });
});