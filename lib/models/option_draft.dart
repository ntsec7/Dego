import 'dart:typed_data';
class OptionDraft{
  String id_creator;
  String title;
  String? description;
  int? percentage;
  Uint8List? image;

  OptionDraft({
    required this.id_creator,
    required this.title,
    this.description,
    this.percentage,
    this.image,
  });

}