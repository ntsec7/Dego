import 'package:flutter/widgets.dart';
import 'package:dego/utilities/lang.dart';

String translateSupabaseError(BuildContext context, Object error) {

  final errorString = error.toString();
  
  if(errorString.contains("Credenciales incorrectas") || errorString.contains('Invalid login credentials')){
    return context.lang.error_credenciales;
  }

  if(errorString.contains("Error interno del servidor")){
    return context.lang.error_servidor;
  }

  // Ordenamos de lo más específico a lo más genérico
  if (errorString.contains('username_ya_existe') || errorString.contains('Usuario_username_key')) {
    return context.lang.error_username;
  }

  if(errorString.contains('email_exists')){
    return context.lang.error_email;
  }
  
  if (errorString.contains('email not confirmed')) {
    return context.lang.error_confirma_email;
  }
  
  if (errorString.contains('socketexception') || errorString.contains('network_error')) {
    return context.lang.error_internet;
  }

  if (errorString.contains('unexpected_failure')) {
    return context.lang.error_datos;
  }

  // default
  return context.lang.error_inesperado;
}