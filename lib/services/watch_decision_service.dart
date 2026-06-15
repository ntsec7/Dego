import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/watch_decision.dart';

class WatchDecisionService {

  final supabase= Supabase.instance.client;

  Stream<List<WatchDecision>> getGroupWatchDecisions(String groupId){
    return supabase
      .from('watch_decision')
      .stream(primaryKey: ['id'])
      .eq('id_group', groupId)
      .map((data) => data.map((json) => WatchDecision.fromMap(json)).toList());
  }

  Stream<List<WatchDecision>> getIndividualWatchDecisions(){
    return supabase
      .from('individual_watch_decision')
      .stream(primaryKey: ['id'])
      .eq('id_gcreator', supabase.auth.currentUser?.id ?? '')
      .map((data) => data.map((json) => WatchDecision.fromMap(json)).toList());
  }

}