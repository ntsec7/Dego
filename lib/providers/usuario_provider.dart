import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/services/usuario_service.dart';
import 'package:dego/models/usuario.dart';
import 'auth_provider.dart';

//Provider del service
final usuarioServiceProvider = Provider<UsuarioService>((ref){
  return UsuarioService();
});

//Provider del usuario (datos de la BD)
final usuarioProvider = FutureProvider<Usuario?>((ref) async{
  final authUser = ref.watch(authProvider);
  
  //Si no hay sesión no hay usuario
  if (authUser == null) return null;

  final usuarioService = ref.watch(usuarioServiceProvider);

  //Cargar datos del usuario
  return await usuarioService.getUser(authUser.id);
});