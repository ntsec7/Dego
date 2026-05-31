import 'package:dego/services/create_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

final createServiceProvider = Provider<CreateService>((ref){
  return CreateService();
});

final createProvider = StateNotifierProvider<CreateNotifier, User?>((ref) {
  final createService = ref.watch(createServiceProvider);
  final supabase = Supabase.instance.client;

  return CreateNotifier(createService, supabase);
});

class CreateNotifier extends StateNotifier<User?> {
  final CreateService createService;
  final SupabaseClient supabase;

  CreateNotifier(this.createService, this.supabase)
      : super(supabase.auth.currentUser) {
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    supabase.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
  }

  //CREAR GRUPO
  Future<void> createGroup({
    required String name, //nombre del grupo 
    Uint8List? image,
  }) async{
    try{
      
      await createService.createGroup(
        name : name,
        image: image,
      );

    } catch (e){
      rethrow;
    }
  }

  //UPDATE GRUPO
  Future<void> updateGroup({
    required String id,
    String? name,
    Uint8List? image,
    required bool deletePhoto,
    String? oldImageName,
  }) async{
    try{
      await createService.updateGroup(id: id, name: name, image:image, deletePhoto: deletePhoto, oldImageName: oldImageName);
    } catch (e){
      rethrow;
    }
  }

  //UPDATE USER
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
      await createService.updateUser(id: id, username: username, name: name, email:email, password:password, image:image, deletePhoto: deletePhoto, oldImageName: oldImageName);
    } catch (e){
      rethrow;
    }
  }

  //UPDATE USER BY ADMIN
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
      await createService.updateUserAdmin(id: id, username: username, name: name, email:email, password:password, type:type, image:image, deletePhoto: deletePhoto, oldImageName: oldImageName);
    } catch (e){
      rethrow;
    }
  }

  //BORRAR UN USUARIO
  Future<void> deleteUser({
    required String id,
  }) async{
    try{
      
      await createService.deleteUser(id: id);

    } catch(e){
      rethrow;
    }
  }


}