import 'package:dego/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/grupo.dart';

class GrupoService {

  final supabase = Supabase.instance.client;

  
  Stream<List<Grupo>> getGrupos(){
    try{

      return supabase.from('grupo').stream(primaryKey: ['id']).map((data) => data.map((json) => Grupo.fromMap(json)).toList());

    } catch(e){
      rethrow;
    }
  }

  // Escucha en tiempo real los miembros de un grupo específico
  Stream<List<Map<String, dynamic>>> streamGroupMembers(String idGroup) {
    return supabase.from('group_members').stream(primaryKey: ['id_user', 'id_group']).eq('id_group', idGroup);
  }

  // Obtiene los datos de los usuarios dado una lista de IDs
  Future<List<Usuario>> obteinUsersProfiles(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    
    final response = await supabase.from('usuario').select('id, username, name, image, user_type').inFilter('id', userIds);
        
    return List<Map<String, dynamic>>.from(response).map((map) => Usuario.fromMap(map)).toList(); //Lo convertimos a tipo Usuario
  }
  
}

