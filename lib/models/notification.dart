class NotificationModel{
  
  String? id;
  String id_user;
  String? id_creator_user;
  String id_group;
  String type;

  NotificationModel({
    this.id,
    required this.id_user,
    this.id_creator_user,
    required this.id_group,
    required this.type,
  });

  //Desde Supabase 
  factory NotificationModel.fromMap(Map<String,dynamic> map){
    return NotificationModel(
      id: map['id'],
      id_user: map['id_user'],
      id_creator_user: map['id_creator_user'],
      id_group: map['id_group'],
      type: map['type'],
    );
  }

  //Hacia Supabase
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'id_user':id_user,
      'id_creator_user':id_creator_user,
      'id_group':id_group,
      'type':type,
    };
  }

}