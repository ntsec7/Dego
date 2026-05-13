import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/grupo.dart';

class GrupoService {

  final supabase = Supabase.instance.client;

  
  Future<List<Grupo>> getGrupos() async{
    try{

      final List<dynamic> grupos= await supabase.from('grupo').select();

      return grupos.map((json) => Grupo.fromMap(json)).toList();  //Lo convierte a una lista de grupos

    } catch(e){
      rethrow;
    }
  }
  
}

