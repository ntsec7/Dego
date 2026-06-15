class WatchDecision{
  String id;
  String? id_group;
  String id_creator;
  String title;
  String url;
  DateTime? finish_hour;
  bool finish;


  WatchDecision({
    required this.id,
    this.id_group,
    required this.id_creator,
    required this.title,
    required this.url,
    this.finish_hour,
    required this.finish,
  });

  //Desde Supabase
  factory WatchDecision.fromMap(Map<String,dynamic> map){
    return WatchDecision(
      id: map['id'], 
      id_group : map['id_group'] ?? "",
      id_creator: map['id_creator'], 
      title: map['title'], 
      url: map['url'],
      finish_hour: map['finish_hour'], 
      finish: map['finish']
    );
  }

  //Hacia Supabase
  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'id_group' : id_group,
      'id_creator' : id_creator,
      'title' : title,
      'url' : url,
      'finish_hour' : finish_hour?.toUtc().toIso8601String(),
      'finish' : finish,
    };
  }

}