import 'package:dego/models/grupo.dart';
import 'package:dego/services/grupo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupInfoServiceProvider = Provider<GrupoService>((ref) {
  return GrupoService();
});


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
      
      final grupoService = ref.read(groupInfoServiceProvider);

      return await grupoService.getGroupName(id);

    } catch (e) {
      rethrow;
    }
  }

}