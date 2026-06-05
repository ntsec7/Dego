import 'package:dego/models/decision.dart';
import 'package:dego/models/option.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DecisionService {

  final supabase= Supabase.instance.client;

  Stream<List<Decision>> getGroupDecisions(String groupId){
    return supabase
        .from('decision')
        .stream(primaryKey: ['id'])
        .eq('id_group', groupId)
        .order('vote_date', ascending: false).map((data) => data.map((json) => Decision.fromMap(json)).toList());
  }

  Stream<List<Decision>> getIndividualDecisions(){

    return supabase
        .from('individual_decisions')
        .stream(primaryKey: ['id'])
        .eq('id_creator', supabase.auth.currentUser?.id ?? '')
        .order('vote_date', ascending: false).map((data) => data.map((json) => Decision.fromMap(json)).toList());

  }

  Stream<Decision> getDecisionById(String id) {
    return supabase
        .from('decision')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => Decision.fromMap(data.first));
  }

  Stream <List<Option>> getOptionsByDecision(String decisionId){
    return supabase
      .from('option')
      .stream(primaryKey: ['id'])
      .eq('id_decision',decisionId)
      .map(
        (data) => data
            .map((optionMap) => Option.fromMap(optionMap))
            .toList(),
      );
  }

}