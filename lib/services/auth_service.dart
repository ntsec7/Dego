import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final supabase = Supabase.instance.client;

  Future<void> register({
    required String email,
    required String username,
    required String name,
    required String password,
  }) async {

    //Crear usuario en auth
    final res= await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user= res.user;

    if(user == null){
      throw Exception("No se pudo crear el usuario");
    }

    //Insertar en tabla usuario
    await supabase.from('usuario').insert({
      'id': 'user.id',
      'email': 'email',
      'username': 'username',
      'name': 'name',
      'tipo': 'client',
    });

  }


  Future<void> login(String input, String password) async{
    String email = input;

    //Si ha introducido el username coge el email para hacer el login
    if(!input.contains('@')){
      //single porque solo esperamos uno. Si hay más de uno o 0 da error
      final res=await supabase.from('usuario').select('email').eq('username',input).single();

      email= res['email'];
    }

    await supabase.auth.signInWithPassword(
      email: email,
      password: password
    );

  }

}