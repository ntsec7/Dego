import 'package:dego/models/usuario.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/grupo.dart';
import 'dart:async';

class GrupoService {

  final supabase = Supabase.instance.client;

  
  Stream<List<Grupo>> getGruposAdmin(String Id){
      try{
      return supabase.from('grupo').stream(primaryKey: ['id']).map((data) => data.map((json) => Grupo.fromMap(json)).toList());
    } catch(e){
      rethrow;
    }
  }

  Stream<List<Grupo>> getGrupos(String Id){
    
    final controller = StreamController<List<Grupo>>();

      Future<void> fetchDatos() async {
        try {
          final response = await supabase
              .from('grupo')
              .select('*, group_members!inner(id_user)')
              .eq('group_members.id_user', Id);
              
          final listaGrupos = response.map((map) => Grupo.fromMap(map)).toList();
          if (!controller.isClosed) controller.add(listaGrupos);
        } catch (e) {
          if (!controller.isClosed) controller.addError(e);
        }
      }

      //Hacemos la primera carga de datos
      fetchDatos();

      // Nos suscribimos al canal en tiempo real para que escuche cambios en la tabla
      final canal = supabase
          .channel('public:grupo')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'grupo',
            callback: (payload) {
              fetchDatos();   //Cada vez que cambie algo en la tabla 'grupo', volvemos a ejecutar la query
            },
          );
          
      canal.subscribe();

      //Limpiamos el canal cuando Riverpod deje de escuchar este stream
      controller.onCancel = () {
        canal.unsubscribe();
        controller.close();
      };

      return controller.stream;

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
    try{
      await supabase.from('group_members').insert({'id_group': id});
    } catch (e) {
      rethrow;
    }
  }
  
}

