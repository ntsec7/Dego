import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class CreateService {

  final supabase = Supabase.instance.client;

  Future<String> uploadImage({
    required String name,
    required Uint8List image,
  }) async{

    try{
      //subir la imagen
      await supabase.storage.from('images').uploadBinary(name, image);

      //coger la url
      final url = supabase.storage.from('images').getPublicUrl(name);

      return url;
    }
    catch (e){
      rethrow;
    }

  }

  Future<void> createGroup({
    required String name,
    Uint8List? image,
  }) async{

    try{

      final user = supabase.auth.currentUser;
      String? url;
      
      if (user == null) {
        throw 'Usuario no autenticado';
      }

      if(image != null){
        final name = 'groups/${user.id}/${DateTime.now().millisecondsSinceEpoch}.png';
        url = await uploadImage(name: name, image: image);
      }

      //Creamos el grupo
      await supabase.from('grupo').insert({
        'name' : name,
        'image' : url,
      });


    } catch(e){
      rethrow;
    }


  }

}

