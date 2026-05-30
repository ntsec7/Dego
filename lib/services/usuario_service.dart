import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/usuario.dart';

class UsuarioService {

  final supabase = Supabase.instance.client;

  Future<Usuario> getUser(String userId) async {

    final res = await supabase.from('usuario').select().eq('id', userId).single();

    return Usuario.fromMap(res);

  }

  Stream<List<Usuario>> getUsersList() {
    try{

      final supabase = Supabase.instance.client;

      return supabase.from('usuario').stream(primaryKey: ['id']).order('name').map((data) => data.map((json) => Usuario.fromMap(json)).toList());
    } catch (e){
      rethrow;
    }
  }

}