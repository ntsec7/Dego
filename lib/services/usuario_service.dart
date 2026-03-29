import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/usuario.dart';

class UsuarioService {

  final supabase = Supabase.instance.client;

  Future<Usuario> getUser() async {
    final user= supabase.auth.currentUser;

    //el ! fuerza a dart a creer que no es null
    final res = await supabase.from('usuario').select().eq('id', user!.id).single();

    return Usuario.fromMap(res);

  }

}