import 'package:dego/models/grupo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/grupo_provider.dart';

final groupInfoProvider = NotifierProvider<GroupInfoNotifier, Grupo?>(() {
  return GroupInfoNotifier();
});

class GroupInfoNotifier extends Notifier<Grupo?> {

  @override
  Grupo? build() {
    return null; 
  }
  
  //COGER EL NOMBRE DEL GRUPO A PARTIR DE SU ID
  Future<String?> getGroupName(String id) async{
    try{

      final grupoService = ref.read(grupoServiceProvider);

      return await grupoService.getGroupName(id);

    } catch (e) {
      rethrow;
    }
  }

  //JOIN GRUPO
  Future<void> joinGroup(String id) async{
    try{

      final grupoService = ref.read(grupoServiceProvider);

      return await grupoService.joinGroup(id);
      
    } catch (e){
      rethrow;
    }
  }

}