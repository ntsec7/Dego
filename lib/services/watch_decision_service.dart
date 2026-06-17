import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/watch_decision.dart';
import 'package:dego/models/watch_position.dart';

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

  Future<WatchDecision> getWatchDecision(String id) async{
    try{
      final res= await supabase.from('watch_decision').select().eq('id',id).single();
    
      return WatchDecision.fromMap(res);
    }
    catch(e){
      rethrow;
    }
  }

  Future<WatchPosition> getWatchPosition(String decision_id) async{
    try{
      final res= await supabase.from('watch_decision_position').select().eq('id_decision', decision_id).single();

      return WatchPosition.fromMap(res);
    }
    catch(e){
      rethrow;
    }
  }

  Stream<WatchDecision> getWatchDecisionById(String id) {
    return supabase
        .from('watch_decision')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => WatchDecision.fromMap(data.first));
  }

  Future<void> updateWatchDecisionPosition({
    required String decisionId,
    required String userId,
    required int lastId,
    required int page,
  }) async {
    try{
      await supabase.from('watch_decision_position')
      .update({'last_id': lastId, 'page': page})
      .eq('id_decision', decisionId).eq('id_user', userId);
    }catch(e){
      rethrow;
    }
  }

  Future<void> watchVote({
    required String decisionId,
    required String userId,
    required int optionId,
  }) async{
    try{
      await supabase.from('watch_vote')
      .insert({
        'id_decision' : decisionId,
        'id_user' : userId,
        'id_option' : optionId,
      });
    } catch(e){
      rethrow;
    }
  }

}