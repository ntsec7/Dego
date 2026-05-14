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
  
}

