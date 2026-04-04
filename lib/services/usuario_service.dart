import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/usuario.dart';

class UsuarioService {

  final supabase = Supabase.instance.client;

  Future<Usuario> getUser(String userId) async {

    final res = await supabase.from('usuario').select().eq('id', userId).single();

    return Usuario.fromMap(res);

  }

}