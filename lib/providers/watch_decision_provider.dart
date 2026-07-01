import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/watch_decision.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/services/watch_decision_service.dart';
import 'package:dego/models/watch_decision_history.dart';
import 'package:dego/providers/watch_decision_list_provider.dart';

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

//Los que están en estado de votación
final voteWatchDecisionsProvider = Provider<AsyncValue<List<WatchDecision>>>((ref) {

  // Escuchamos el proveedor principal en tiempo real
  final allDecisionsAsync = ref.watch(watchDecisionProvider);

  // Filtramos los datos localmente en memoria sin volver a consultar a Supabase
  return allDecisionsAsync.whenData((decisionsList) => 
    decisionsList.where((d) => d.finish == false).toList()
  );
});

final finishWatchDecisionsProvider = Provider<AsyncValue<List<WatchDecision>>>((ref) {

  // Escuchamos el proveedor principal en tiempo real
  final allDecisionsAsync = ref.watch(watchDecisionProvider);

  // Filtramos los datos localmente en memoria sin volver a consultar a Supabase
  return allDecisionsAsync.whenData((decisionsList) => 
    decisionsList.where((d) => d.finish == true).toList()
  );
});

final watchDecisionByIdProvider = StreamProvider.family<WatchDecision, String>((ref, id) {
  final service = ref.watch(watchDecisionServiceProvider);

  return service.getWatchDecisionById(id);
});

final voteCountProvider =
    StreamProvider.family<Map<int, int>, String>((ref, decisionId) {
  final service = ref.watch(watchDecisionServiceProvider);

  return service.getVoteCount(decisionId);
});

final watchVoteListProvider = FutureProvider.family<List<MediaWithVotes>, HistoryArgs>((ref, args) async {
  
  final votosMap = await ref.watch(
    voteCountProvider(args.decisionId).future,
  );

  if (votosMap.isEmpty) return [];

  // 2. Extraemos solo las llaves (los IDs de las pelis/series)
  List<int> ids = votosMap.keys.toList();

  // 3. Llamamos al provider pasándole estos IDs
  // si los IDs no han cambiado, Riverpod NO llamará a la Edge Function, usará la caché
  final filmList = await ref.read(watchDecisionListProvider(WatchDecisionListProvider(ids, args.isMovie)).future);

  // 4. Cruzamos los datos: Unimos la película con sus votos correspondientes
  final List<MediaWithVotes> resultado = filmList.map((peli) {
    return MediaWithVotes(
      media: peli,
      votes: votosMap[peli.id] ?? 0,
    );
  }).toList();

  resultado.sort((a, b) => b.votes.compareTo(a.votes));

  return resultado;
});

final watchDecisionHistoryProvider =
    FutureProvider.family<WatchDecisionHistory, String>((ref, id) async {

  final decision = await ref.watch(
    watchDecisionByIdProvider(id).future,
  );

  final options = await ref.watch(
    watchVoteListProvider(
      HistoryArgs(
        decisionId: decision.id,
        isMovie: decision.url.contains('movie'),
      ),
    ).future,
  );

  return WatchDecisionHistory(
    decision: decision,
    options: options,
  );
});