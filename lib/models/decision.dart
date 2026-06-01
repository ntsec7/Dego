import 'package:flutter/material.dart';
import 'package:dego/utilities/lang.dart';

// enum DecisionType{roulette, simple, scientific, ranking}
enum DecisionType{roulette, simple, ranking}

extension DecisionTypeExtension on DecisionType {
  String title(BuildContext context) {
    switch (this) {
      case DecisionType.simple: return context.lang.votacion;
      case DecisionType.roulette: return context.lang.ruleta;
      case DecisionType.ranking: return context.lang.ranking;
      // case DecisionType.scientific: return context.lang.cientifico;
    }
  }
}

enum DecisionState{draft, options, vote, finish}

class DecisionModel{
  String? id;
  String id_creator;
  String? id_group;
  String? title;
  DecisionState state;
  DateTime? options_date;
  DateTime? vote_date;
  DecisionType type;

  DecisionModel({
    this.id,
    required this.id_creator,
    this.id_group,
    this.title,
    required this.state,
    this.options_date,
    this.vote_date,
    required this.type,
  });

  //Desde Supabase 
  factory DecisionModel.fromMap(Map<String,dynamic> map){
    return DecisionModel(
      id: map['id'],
      id_creator: map['id_creator'],
      id_group: map['id_group'],
      title: map['title'],
      state : map['state'],
      options_date: map['options_date'],
      vote_date: map['vote_date'],
      type: DecisionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DecisionType.simple, 
      ),
    );
  }

  //Hacia Supabase
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'id_creator':id_creator,
      'id_group':id_group,
      'title' : title,
      'state' : state.name,
      'options_date' : options_date,
      'vote_date': vote_date,
      'type':type.name, //name convierte el enum a String
    };
  }
}