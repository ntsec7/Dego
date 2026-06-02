class Option{
  String id;
  String id_decision;
  String id_creator;
  String title;
  String? description;
  int? percentage;

  Option({
    required this.id,
    required this.id_decision,
    required this.id_creator,
    required this.title,
    this.description,
    this.percentage,
  });

  //Desde Supabase 
  factory Option.fromMap(Map<String,dynamic> map){
    return Option(
      id: map['id'],
      id_decision: map['id_decision'],
      id_creator: map['id_creator'],
      title: map['title'],
      description: map['description'],
      percentage: map['percentage'],
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
    };
  }

}