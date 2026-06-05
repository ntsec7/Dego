import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:dego/models/decision.dart';
import 'package:dego/models/decision_draft.dart';
import 'package:dego/models/option_draft.dart';
import 'package:dego/models/option.dart';

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


      //Cambiar email y/o contraseña llama Edge-function
      if(email!=null || password!=null){
        await supabase.functions.invoke(
          'update-user', 
          body: { 'userIdToUpdate': id, 'newEmail':email, 'newPassword':password },
        );
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

  Future<void> createDecision({
    required String id_creator,
    String? id_group,
    required DecisionState state,
    required DecisionDraft decision,
  }) async{
    try{

      //Creamos la decision
      final response = await supabase.from('decision').insert({
        'id_creator' : id_creator,
        'id_group' : id_group,
        'title' : decision.title,
        'state' : state.name,
        'options_date' : decision.options_date?.toUtc().toIso8601String(),
        'vote_date' : decision.vote_date?.toUtc().toIso8601String(),
        'type': decision.type.name,
      }).select('id').single();

      final String decisionId = response['id'];

      if(decision.options.isNotEmpty){
        for(OptionDraft option in decision.options){
          await createOption(id_decision: decisionId, option: option);
        }
      }


    } catch(e){
      rethrow;
    }
  }

  Future<void> createOption({
    required String id_decision,
    required OptionDraft option,
  }) async{
    try{

      String? url;

      if(option.image != null){
        final name = 'options/$id_decision/${DateTime.now().millisecondsSinceEpoch}.png';
        url = await uploadImage(name: name, image: option.image!);
      }

      await supabase.from('option').insert({
        'id_decision' : id_decision,
        'id_creator' : option.id_creator,
        'title' : option.title,
        'description': option.description,
        'percentage' : option.percentage,
        'image' : url,
      });

    } catch (e){
      rethrow;
    }
  }

  Future<void> editDecision({
    required Decision decision,
  }) async{
    try{
      await supabase.from('decision').update(decision.toMap()).eq('id', decision.id);
    } catch (e){
      rethrow;
    }
  }

  Future<void> deleteDecision({
    required String decisionId,
  }) async{
    try{
      await supabase.from('decision').delete().eq('id',decisionId);
    } catch (e){
      rethrow;
    }
  }

  Future<void> editOption({
    required Option option,
  }) async{
    try{
      await supabase.from('option').update(option.toMap()).eq('id', option.id);
    } catch (e){
      rethrow;
    }
  }

  Future<void> deleteOption({
    required String optionId,
  }) async{
    try{
      await supabase.from('option').delete().eq('id',optionId);
    } catch (e){
      rethrow;
    }
  }


}

