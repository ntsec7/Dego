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

  Future<void> deleteImage(String name) async {
    try{
      
      await supabase.storage.from('images').remove([name]);

    } catch(e){
      rethrow;
    }
  }

  Future<void> updateGroup({
    required String id,
    String? name,
    Uint8List? image,
    required bool deletePhoto,
    String? oldImageName,
  }) async{
    try{

      String? url;
      final Map<String, dynamic> updates = {};  //Mapa donde guardamos lo que vamos a actualizar

      if( (deletePhoto || image!= null) && oldImageName!=null ){
        //borrar la imagen subida
        await deleteImage(oldImageName);
      }

      if(name!=null){
        updates['name'] = name;
      }

      if(deletePhoto){
        updates['image'] = null;
      }
      else if(image!=null){
        final name = 'groups/$id/${DateTime.now().millisecondsSinceEpoch}.png';
        url = await uploadImage(name: name, image: image);
        updates['image']=url;
      }

      if (updates.isNotEmpty) {
        await supabase.from('grupo').update(updates).eq('id', id);
      }

    } catch(e){
      rethrow;
    }
  }

  Future<void> updateUser({
    required String id,
    String? username,
    String? name,
    String? email,
    String? password,
    Uint8List? image,
    required bool deletePhoto,
    String? oldImageName,
  }) async{
    try{

      String? url;
      final Map<String, dynamic> updates = {};  //Mapa donde guardamos lo que vamos a actualizar

      if( (deletePhoto || image!= null) && oldImageName!=null ){
        //borrar la imagen subida
        await deleteImage(oldImageName);
      }

      if(username!=null){
        updates['username'] = username;
      }

      if(name!=null){
        updates['name'] = name;
      }

      if(deletePhoto){
        updates['image'] = null;
      }
      else if(image!=null){
        final name = 'users/$id/${DateTime.now().millisecondsSinceEpoch}.png';
        url = await uploadImage(name: name, image: image);
        updates['image']=url;
      }

      if (updates.isNotEmpty) {
        await supabase.from('usuario').update(updates).eq('id', id);
      }

      //Cambiar email
      if(email!=null){
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            email: email,
          ),
        );
      }

      //Cambiar contraseña
      if(password!=null){
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            password: password,
          )
        );
      }


    } catch(e){
      rethrow;
    }
  }

  Future<void> updateUserAdmin({
    required String id,
    String? username,
    String? name,
    String? email,
    String? password,
    String? type,
    Uint8List? image,
    required bool deletePhoto,
    String? oldImageName,
  }) async{

    try{

      String? url;
      final Map<String, dynamic> updates = {};  //Mapa donde guardamos lo que vamos a actualizar

      if( (deletePhoto || image!= null) && oldImageName!=null ){
        //borrar la imagen subida
        await deleteImage(oldImageName);
      }

      if(username!=null){
        updates['username'] = username;
      }

      if(name!=null){
        updates['name'] = name;
      }

      if(deletePhoto){
        updates['image'] = null;
      }
      else if(image!=null){
        final name = 'users/$id/${DateTime.now().millisecondsSinceEpoch}.png';
        url = await uploadImage(name: name, image: image);
        updates['image']=url;
      }

      if(type!=null){
        updates['user_type'] = type;
      }

      if (updates.isNotEmpty) {
        await supabase.from('usuario').update(updates).eq('id', id);
      }

      //Cambiar email : llama a la Edge-function 
      if(email!=null){
        // await Supabase.instance.client.auth.updateUser(
        //   UserAttributes(
        //     email: email,
        //   ),
        // );
      }

      //Cambiar contraseña : llama a la Edge-function
      if(password!=null){
        // await Supabase.instance.client.auth.updateUser(
        //   UserAttributes(
        //     password: password,
        //   )
        // );
      }


    } catch(e){
      rethrow;
    }

  }

  Future<void> deleteUser({
    required String id,
  }) async{
    try{
      
      await supabase.functions.invoke(
        'delete-user', 
        body: { 'userIdToDelete': id },
      );

    } catch(e){
      rethrow;
    }
  }

}

