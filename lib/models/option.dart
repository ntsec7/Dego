import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';

enum OptionType {
  standard('standard'),
  film('film'),
  serie('serie');

  // El valor que se guardará/leerá en Supabase
  final String databaseValue;
  const OptionType(this.databaseValue);

  // Tu método de traducción idéntico al de TMDBOrder
  String getLabel(BuildContext context) {
    switch (this) {
      case OptionType.standard:
        return context.lang.no; 
      case OptionType.film:
        return context.lang.peli;
      case OptionType.serie:
        return context.lang.serie;
    }
  }
}

class Option{
  String id;
  String id_decision;
  String id_creator;
  String title;
  String? description;
  int? percentage;
  String? image;
  int? num_votes;
  OptionType type;

  Option({
    required this.id,
    required this.id_decision,
    required this.id_creator,
    required this.title,
    this.description,
    this.percentage,
    this.image,
    this.num_votes,
    required this.type,
  });

  //Desde Supabase 
  factory Option.fromMap(Map<String,dynamic> map){
    return Option(
      id: map['id'],
      id_decision: map['id_decision'],
      id_creator: map['id_creator'],
      title: map['title'] ?? "",
      description: map['description'],
      percentage: map['percentage'],
      image: map['image'],
      num_votes: map['num_votes'],
      type: OptionType.values.firstWhere(
        (e) => e.databaseValue == (map['type'] as String?),
        orElse: () => OptionType.standard,
      ),
    );
  }

  //Hacia Supabase
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'id_decision':id_decision,
      'id_creator' : id_creator,
      'title' : title,
      'description' : description,
      "percentage" : percentage,
      "image": image,
      "type" : type.databaseValue,
    };
  }

}