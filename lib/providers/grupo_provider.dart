import 'package:dego/services/grupo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/grupo.dart';
import './usuario_provider.dart';

final grupoServiceProvider = Provider<GrupoService>((ref) => GrupoService());

//Provider que solo escucha los IDs de los grupos del usuario actual
final idsGruposUsuarioProvider = StreamProvider<List<String>>((ref) {
  final service = ref.watch(grupoServiceProvider);
  final userAsync = ref.watch(usuarioProvider);

  return userAsync.maybeWhen(
    data: (user) {
      if (user == null) return Stream.value([]);
      // Si es admin no filtra por miembros
      if (user.tipo == 'admin') return Stream.value([]); 
      
      return service.streamIdsGruposUsuario(user.id);
    },
    orElse: () => Stream.value([]),
  );
});

// Provider final que observa al anterior
final grupoProvider = StreamProvider<List<Grupo>>((ref) {
  final service = ref.watch(grupoServiceProvider);
  final userAsync = ref.watch(usuarioProvider);
  
  // Obtenemos el estado de los IDs de los grupos
  final idsGruposAsync = ref.watch(idsGruposUsuarioProvider);

  return userAsync.maybeWhen(
    data: (user) {
      if (user == null) return Stream.value([]);

      if (user.tipo == 'admin') {
        return service.getGruposAdmin(user.id); 
      }

      // Para usuarios normales, esperamos a tener los IDs del otro provider
      return idsGruposAsync.maybeWhen(
        data: (ids) => service.streamGruposPorIds(ids),
        orElse: () => Stream.value([]),
      );
    },
    orElse: () => Stream.value([]),
  );
});
