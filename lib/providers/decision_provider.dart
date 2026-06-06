import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/decision.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/services/decision_service.dart';
import 'package:dego/models/option.dart';

final decisionServiceProvider = Provider<DecisionService>((ref) {
  return DecisionService();
});

final decisionProvider = StreamProvider<List<Decision>>((ref){

  final service = ref.watch(decisionServiceProvider);
  final groupId = ref.watch(idCurrentGroupProvider);

  if(groupId!=null){  //coge los de un grupo
    return service.getGroupDecisions(groupId);
  }else{  //Coge los individuales
    return service.getIndividualDecisions();
  }

});

final optionDecisionsProvider = Provider<AsyncValue<List<Decision>>>((ref) {

  // Escuchamos el proveedor principal en tiempo real
  final allDecisionsAsync = ref.watch(decisionProvider);

  // Filtramos los datos localmente en memoria sin volver a consultar a Supabase
  return allDecisionsAsync.whenData((decisionsList) => 
    decisionsList.where((d) => d.state == DecisionState.options).toList()
  );
});

final voteDecisionsProvider = Provider<AsyncValue<List<Decision>>>((ref) {

  // Escuchamos el proveedor principal en tiempo real
  final allDecisionsAsync = ref.watch(decisionProvider);

  // Filtramos los datos localmente en memoria sin volver a consultar a Supabase
  return allDecisionsAsync.whenData((decisionsList) => 
    decisionsList.where((d) => d.state == DecisionState.vote).toList()
  );
});

final finishDecisionsProvider = Provider<AsyncValue<List<Decision>>>((ref) {

  // Escuchamos el proveedor principal en tiempo real
  final allDecisionsAsync = ref.watch(decisionProvider);

  // Filtramos los datos localmente en memoria sin volver a consultar a Supabase
  return allDecisionsAsync.whenData((decisionsList) => 
    decisionsList.where((d) => d.state == DecisionState.finish).toList()
  );
});

final decisionByIdProvider = StreamProvider.family<Decision, String>((ref, id) {
  final service = ref.watch(decisionServiceProvider);

  return service.getDecisionById(id);
});

final optionsByDecisionProvider = StreamProvider.family<List<Option>, String>((ref, decisionId) {
  final service = ref.watch(decisionServiceProvider);
  return service.getOptionsByDecision(decisionId);
});

final optionByIdProvider = StreamProvider.family<Option,String> ((ref, id) {
  final service = ref.watch(decisionServiceProvider);
  return service.getOptionById(id);
});
