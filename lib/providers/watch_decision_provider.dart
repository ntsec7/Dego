import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/watch_decision.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/services/watch_decision_service.dart';

final watchDecisionServiceProvider = Provider<WatchDecisionService>((ref) {
  return WatchDecisionService();
});

final watchDecisionProvider = StreamProvider<List<WatchDecision>>((ref){

  final service = ref.watch(watchDecisionServiceProvider);
  final groupId = ref.watch(idCurrentGroupProvider);

  if(groupId!=null){  //coge los de un grupo
    return service.getGroupWatchDecisions(groupId);
  }else{  //Coge los individuales
    return service.getIndividualWatchDecisions();
  }  

});

final voteWatchDecisionsProvider = Provider<AsyncValue<List<WatchDecision>>>((ref) {

  // Escuchamos el proveedor principal en tiempo real
  final allDecisionsAsync = ref.watch(watchDecisionProvider);

  // Filtramos los datos localmente en memoria sin volver a consultar a Supabase
  return allDecisionsAsync.whenData((decisionsList) => 
    decisionsList.where((d) => d.finish == false).toList()
  );
});