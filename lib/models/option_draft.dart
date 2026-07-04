import 'dart:typed_data';

import 'package:dego/models/option.dart';
class OptionDraft{
  String id_creator;
  String title;
  String? description;
  int? percentage;
  Uint8List? image;
  OptionType type;

  OptionDraft({
    required this.id_creator,
    required this.title,
    this.description,
    this.percentage,
    this.image,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_creator': id_creator,
      'title': title,
      'description': description,
      'percentage': percentage,
      'type': type.databaseValue,
    };
  }

}