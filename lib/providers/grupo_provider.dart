import 'package:dego/services/grupo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/grupo.dart';
import './usuario_provider.dart';

final grupoServiceProvider = Provider<GrupoService>((ref) => GrupoService());

// Este provider escuchará el stream automáticamente
final grupoProvider = StreamProvider<List<Grupo>>((ref) {
  final service = ref.watch(grupoServiceProvider);
  final userAsync = ref.watch(usuarioProvider);
  return userAsync.maybeWhen(
    data: (user) {
      // Si el usuario es null (no hay sesión en Supabase), devolvemos un stream vacío
      if (user == null) {
        return Stream.value([]);
      }

      // Si el usuario ya está cargado
      if(user.tipo=='admin'){
        return service.getGruposAdmin(user.id);
      }
      else{
        return service.getGrupos(user.id);
      }
      
      
    },
    // Mientras el FutureProvider está cargando los datos del usuario de Supabase,
    // o si da un error, mantenemos el stream de grupos en espera devolviendo una lista vacía.
    orElse: () => Stream.value([]),
  );
});
