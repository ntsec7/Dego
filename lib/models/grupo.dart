class Grupo{

  String id;
  String name;
  String? image;

  Grupo({
    required this.id,
    required this.name,
    this.image,
  });

  //Desde Supabase
  factory Grupo.fromMap(Map<String,dynamic> map){
    return Grupo(
      id: map['id'],
      name : map['name'] ?? '',
      image : map['image'],
    );
  }

  //Hacia supabase
  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name': name,
      'image' : image,
    };
  }

}