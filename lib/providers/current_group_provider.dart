import 'package:dego/providers/grupo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/grupo.dart';

//Id del currentGroup
final idCurrentGroupProvider = StateProvider<String?>((ref) => null);

final currentGroupProvider = Provider<Grupo?>((ref) {
  final id = ref.watch(idCurrentGroupProvider);
  final gruposAsync = ref.watch(grupoProvider);

  if (id == null) return null;

  // Simplemente filtramos el valor actual de la lista
  return gruposAsync.maybeWhen(
    data: (grupos) => grupos.firstWhere((g) => g.id == id),
    orElse: () => null,
  );
});