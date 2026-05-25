import 'package:dego/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/grupo.dart';
import 'dart:async';

class GrupoService {

  final supabase = Supabase.instance.client;

  
  Stream<List<Grupo>> getGruposAdmin(String Id){
      try{
      return supabase.from('grupo').stream(primaryKey: ['id']).order('name').map((data) => data.map((json) => Grupo.fromMap(json)).toList());
    } catch(e){
      rethrow;
    }
  }

  Stream<List<Grupo>> getGrupos(String Id){
    
    return supabase
      .from('group_members')
      .stream(primaryKey: ['id_user', 'id_group'])
      .eq('id_user', Id) 
      .asyncMap((snapshot) async {  //filas de group_members
        if (snapshot.isEmpty) return [];

        final List<String> idsGrupos = snapshot.map((row) => row['id_group'] as String).toList();

        final res = await supabase  //coge la información del grupo
            .from('grupo')
            .select()
            .inFilter('id', idsGrupos);

        //Convertimos la respuesta a objetos Grupo
        final groupsList = (res as List).map((map) => Grupo.fromMap(map)).toList();

        // Ordenamos la lista alfabéticamente por nombre antes de enviarla
        // Esto garantiza que la lista nunca "salte" sin criterio
        groupsList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        return groupsList;    
      });

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

    Future<String?> getGroupName(String id) async{
    try{

      final grupo = await supabase.from('grupo').select('name').eq('id',id).maybeSingle();

      if(grupo==null){
        return null;
      }

      return grupo['name'] as String;

    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinGroup(String id) async{

    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");

    try{
      await supabase.from('group_members').insert({
        'id_group': id,
        'id_user': user.id,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMember(String id_group, String id_user) async{
    try{
      await supabase.from('group_members').delete()
      .eq('id_group', id_group)
      .eq('id_user',id_user);
    } catch (e){
      rethrow;
    }

  }

  Future<void> deleteGroup(String id) async{
    try{
      await supabase.from('grupo').delete().eq('id',id);
    } catch (e){
      rethrow;
    }
  }
  
}

