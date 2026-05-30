import 'package:dego/providers/users_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/usuario.dart';

//Id del currentGroup
final idSelectedUserProvider = StateProvider<String?>((ref) => null);

final selectedUserProvider = Provider<Usuario?>((ref) {
  final id = ref.watch(idSelectedUserProvider);
  final usersAsync = ref.watch( userListProvider);

  if (id == null) return null;

  // Simplemente filtramos el valor actual de la lista
  return usersAsync.maybeWhen(
    data: (users) => users.firstWhere((u) => u.id == id),
    orElse: () => null,
  );
});