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
    try {
      final res = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'username': username,
            'name': name,
          }
      );

      final user = res.user;

      if (user == null) {
        throw Exception("No se pudo crear el usuario");
      }

    } on AuthException catch (e){
      throw e.message;
    } catch (e){
      throw Exception ("Error inesperado: $e");
    }
  

  }


  Future<void> login(String input, String password) async{
    String email = input;

    //Si ha introducido el username coge el email para hacer el login
    if(!input.contains('@')){
      //single porque solo esperamos uno. Si hay más de uno o 0 da error
      final res=await supabase.from('usuario').select('email').eq('username',input).maybeSingle(); // Usar maybeSingle evita que explote si no existe;

      if (res == null) {
        throw "El nombre de usuario no existe";
      }

      email= res['email'];
    }

    try{
      await supabase.auth.signInWithPassword(
        email: email,
        password: password
      );
    } on AuthException catch (e){
      throw e.message;
    } catch (e){
      throw Exception ("Error inesperado: $e");
    }

  }

}