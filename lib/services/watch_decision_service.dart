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

  Future<WatchPosition> getWatchPosition(String decision_id, String user_id) async{
    try{
      final res= await supabase.from('watch_decision_position').select().eq('id_decision', decision_id).eq('id_user', user_id).single();

      return WatchPosition.fromMap(res);
    }
    catch(e){
      return WatchPosition(
        id_decision: decision_id,
        id_user: user_id,
        last_id: 0, 
        page: 1, 
        finish: false,  
      );
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
    required WatchPosition position,
  }) async {
    try{
      await supabase.from('watch_decision_position').upsert({ //hace un insert, pero si ya existe hace un update
        'id_decision': position.id_decision,
        'id_user': position.id_user,
        'last_id': position.last_id,
        'page': position.page,
        'finish': position.finish, // Añadimos el valor por defecto por consistencia
      });
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

  Stream<Map<int, int>> getVoteCount(String decisionId) {
    return supabase
        .from('watch_vote')
        .stream(primaryKey: ['id_decision', 'id_user', 'id_option'])
        .eq('id_decision', decisionId)
        .map((rows) {
          final Map<int, int> counts = {};

          for (final row in rows) {
            final optionId = row['id_option'] as int;
            counts.update(
              optionId,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }

          return counts;
        });
  }

}