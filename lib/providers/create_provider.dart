import 'package:dego/models/decision.dart';
import 'package:dego/models/decision_draft.dart';
import 'package:dego/models/option_draft.dart';
import 'package:dego/services/create_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:dego/models/option.dart';

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

  //CREAR UNA DECISIÓN
  Future<void> createDecision({
    required String id_creator,
    String? id_group,
    required DecisionState state,
    required DecisionDraft decision,
  }) async{
    try{
      
      await createService.createDecision(id_creator: id_creator, id_group: id_group, state: state, decision: decision);

    } catch(e){
      rethrow;
    }
  }

  //EDITAR DECISIÓN
  Future<void> editDecision({
    required Decision decision,
  }) async{
    try{
      await createService.editDecision(decision: decision);
    } catch (e){
      rethrow;
    }
  }


  //BORRAR DECISIÓN
  Future<void> deleteDecision({
    required String decisionId,
  }) async{
    try{
      await createService.deleteDecision(decisionId: decisionId);
    } catch (e){
      rethrow;
    }
  }

  //CREAR UNA OPCIÓN
  Future<void> createOption({
    required String id_decision,
    required OptionDraft option,
  }) async{
    try{
      await createService.createOption(id_decision: id_decision, option: option);
    } catch (e){
      rethrow;
    }
  }

  //EDITAR OPCIÓN
  Future<void> editOption({
    required Option option,
    Uint8List? image,
    required bool deletePhoto
  }) async{
    try{
      await createService.editOption(option: option, image:image, deletePhoto:deletePhoto);
    } catch (e){
      rethrow;
    }
  }

  //BORRAR OPCIÓN
  Future<void> deleteOption({
    required String optionId,
  }) async{
    try{
      await createService.deleteOption(optionId: optionId);
    } catch (e){
      rethrow;
    }
  }

  //CREAR SIMPLE VOTE
  Future<void> createSimpleVote({
    required String id_option,
    required String id_decision,
    required String id_user,
  }) async{
    try{
      await createService.createSimpleVote(id_option:id_option, id_decision: id_decision, id_user:id_user);
    } catch (e){
      rethrow;
    }
  }

  //HAS ALREADY VOTE
  Future<bool> hasAlreadyVote({
    required String id_decision, 
    required String id_user,
  }) async{
    try{
      return createService.hasAlreadyVote(id_decision:id_decision,id_user:id_user);
    } catch(e){
      rethrow;
    }
  }

  //HAS ALREADY VOTE FOR RANKING
  Future<bool> hasAlreadyRankingVote({
    required String id_decision, 
    required String id_user,
  }) async{
    try{
      return createService.hasAlreadyRankingVote(id_decision:id_decision,id_user:id_user);
    } catch(e){
      rethrow;
    }
  }

  //CREAR RANKING VOTE
  Future<void> createRankingVote({
    required String id_option,
    required String id_decision,
    required String id_user,
    required int number,
  }) async{
    try{
      await createService.createRankingVote(id_option:id_option, id_decision: id_decision, id_user:id_user, number:number);
    } catch (e){
      rethrow;
    }
  }

  //CREAR WATCH DECISION 
  Future<void> createWatchDecision({
    required String id_creator,
    String? id_group,
    required String title,
    DateTime? finish_hour,
    required String url,

  }) async{
    try{
      
      await createService.createWatchDecision(id_creator: id_creator, id_group: id_group, title: title, finish_hour: finish_hour, url: url);

    } catch(e){
      rethrow;
    }
  }

}