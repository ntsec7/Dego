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

      //comprobamos si ya existe el username
      final resUsername = await supabase
        .from('usuario')
        .select('username')
        .eq('username', username)
        .maybeSingle();

      if (resUsername != null) {
        throw 'username_ya_existe'; 
      }

      final res = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'username': username,
            'name': name,
          },
          emailRedirectTo: 'com.dego://login-callback',
      );

      final user = res.user;

      if (user == null) {
        throw ("No se pudo crear el usuario");
      }

    } on AuthException catch (e){
      throw e.message;
    } catch (e){
      rethrow;
    }
  

  }

  Future<void> login(String input, String password) async{
    String email = input;

    //Si ha introducido el username coge el email para hacer el login
    if(!input.contains('@')){

      try {

        // Invocamos la edge function
        final res = await supabase.functions.invoke(
          'get-email-from-username', 
          body: {
            'username': input,
          },
        );

        if (res.status != 200) {
          throw 'Credenciales incorrectas';
        }

        email = res.data['email'];


      } catch (e) {
        // Si es un error de red o el throw anterior
        rethrow;
      }

    }

    try{
      await supabase.auth.signInWithPassword(
        email: email,
        password: password
      );
    } on AuthException catch (e){
      throw e.message;
    } catch (e){
      rethrow;
    }

  }

  Future<String?> getUserId(String username) async{
    try{
      
      final user = await supabase.from('usuario').select('id').eq('username',username).maybeSingle();

      if(user==null){
        return null;
      }

      return user['id'] as String;

    } catch (e) {
      rethrow;
    }
  }

}

