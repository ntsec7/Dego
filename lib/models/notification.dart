enum NotificationType {invite_group, kick_group, create_vote, end_vote, create_option}
class NotificationModel{
  
  String? id;
  String id_user;
  String? id_creator_user;
  String id_group;
  String? id_decision;
  bool? is_watch;
  NotificationType type;

  NotificationModel({
    this.id,
    required this.id_user,
    this.id_creator_user,
    required this.id_group,
    this.id_decision,
    this.is_watch,
    required this.type,
  });

  //Desde Supabase 
  factory NotificationModel.fromMap(Map<String,dynamic> map){
    return NotificationModel(
      id: map['id'],
      id_user: map['id_user'],
      id_creator_user: map['id_creator_user'],
      id_group: map['id_group'],
      id_decision: map['id_decision'],
      is_watch: map['is_watch'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.invite_group, 
      ),
    );
  }

  //Hacia Supabase
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'id_user':id_user,
      'id_creator_user':id_creator_user,
      'id_group':id_group,
      'id_decision' : id_decision,
      'is_watch' : is_watch,
      'type':type.name, //name convierte el enum a String
    };
  }

}
class NotificationDisplayModel{

  final NotificationModel baseNotification;
  final String creatorUsername;
  final String groupName;
  final String? decisionTitle;

  NotificationDisplayModel({
    required this.baseNotification,
    required this.creatorUsername,
    required this.groupName,
    this.decisionTitle,
  });

}