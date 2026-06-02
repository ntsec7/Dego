class OptionDraft{
  String id;
  String id_decision;
  String id_creator;
  String title;
  String? description;
  int? percentage;

  OptionDraft({
    required this.id,
    required this.id_decision,
    required this.id_creator,
    required this.title,
    this.description,
    this.percentage,
  });

}