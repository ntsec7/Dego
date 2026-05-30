import 'package:dego/services/usuario_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/usuario.dart';
import './usuario_provider.dart';

final UserListServiceProvider = Provider<UsuarioService>((ref) => UsuarioService());

// Este provider escuchará el stream automáticamente
final userListProvider = StreamProvider<List<Usuario>>((ref) {
  final service = ref.watch(usuarioServiceProvider);
  final userAsync = ref.watch(usuarioProvider);
  return userAsync.maybeWhen(
    data: (user) {
      // Si el usuario es null (no hay sesión en Supabase), devolvemos un stream vacío
      if (user == null) {
        return Stream.value([]);
      }

      // Si el usuario ya está cargado
      if(user.tipo=='admin'){
        return service.getUsersList();
      }
      else {
        return Stream.value([]);
      }
      
    },
    // Mientras el FutureProvider está cargando los datos del usuario de Supabase,
    // o si da un error, mantenemos el stream de grupos en espera devolviendo una lista vacía.
    orElse: () => Stream.value([]),
  );
});
