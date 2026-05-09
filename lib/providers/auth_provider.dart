import 'package:dego/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref){
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  final supabase = Supabase.instance.client;

  return AuthNotifier(authService, supabase);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService authService;
  final SupabaseClient supabase;

  AuthNotifier(this.authService, this.supabase)
      : super(supabase.auth.currentUser) {
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    supabase.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
  }

  // REGISTER 
  Future<void> register({
    required String email,
    required String username,
    required String name,
    required String password,
  }) async {
    try {
      await authService.register(
        email: email,
        username: username,
        name: name,
        password: password,
      );
    } catch(e){
      rethrow;
    }

  }

  // LOGIN
  Future<void> login(String input, String password) async {
    try{
      await authService.login(input, password);
    }catch (e) {
      rethrow;
    }
    
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      state = null;
    } catch (e){
      rethrow;
    }
    
  }

  //RECUPERAR CONTRASEÑA
  Future<void> recuperatePassword(String email) async{
    try{
      await supabase.auth.resetPasswordForEmail(email,
      redirectTo: 'com.dego://reset-password');
    } catch (e){
      rethrow;
    }
  }

  //CAMBIAR CONTRASEÑA DESPUÉS DE RECUPERARLA
Future<void> updatePassword(String newPassword) async {
  try {

    await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );

  } catch (e) {
    rethrow;
  }
}

}