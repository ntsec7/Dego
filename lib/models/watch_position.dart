class WatchPosition {

    String id_decision;
    String id_user;
    int last_id;
    int page;

    WatchPosition({
      required this.id_decision,
      required this.id_user,
      required this.last_id,
      required this.page,
    });

    //Desde Supabase
    factory WatchPosition.fromMap(Map<String,dynamic> map){
      return WatchPosition(
        id_decision: map['id_decision'], 
        id_user: map['id_user'], 
        last_id: map['last_id'], 
        page: map['page'],
      );
    }

    //Hacia Supabase
    Map<String,dynamic> toMap(){
      return{
        'id_decision' : id_decision,
        'id_user' : id_user,
        'last_id' : last_id,
        'page' : page,
      };
    }

}