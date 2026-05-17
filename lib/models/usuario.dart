class Usuario{

  String id;
  String username;
  String name;
  String? image;
  String tipo;

  //Constructor
  Usuario({
    required this.id,
    required this.username,
    required this.name,
    this.image,
    required this.tipo,
  });

  //Desde Supabase
  factory Usuario.fromMap(Map<String, dynamic> map){
    return Usuario(
      id: map['id'],
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      image: map['image'],
      tipo: map['user_type'] ?? 'client',
    );
  }

  //Hacia Supabase
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'username': username,
      'name': name,
      'image': image,
      'tipo': tipo,
    };
  }

}