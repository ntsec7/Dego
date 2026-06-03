class OptionDraft{
  String id_creator;
  String title;
  String? description;
  int? percentage;
  String? image;

  OptionDraft({
    required this.id_creator,
    required this.title,
    this.description,
    this.percentage,
    this.image,
  });

}