import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/grupo.dart';

class GrupoService {

  final supabase = Supabase.instance.client;

  
  Stream<List<Grupo>> getGrupos(){
    try{

      // final List<dynamic> grupos= await supabase.from('grupo').select();

      // return grupos.map((json) => Grupo.fromMap(json)).toList();  //Lo convierte a una lista de grupos

      return supabase.from('grupo').stream(primaryKey: ['id']).map((data) => data.map((json) => Grupo.fromMap(json)).toList());

    } catch(e){
      rethrow;
    }
  }
  
}

