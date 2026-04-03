abstract class Check{
  String? comprobar(String? value);
}

class CheckEmail implements Check{

  @override
  String? comprobar(String? value){

    if(value == null || value.isEmpty) return "Campo obligatorio";

    final RegExp regExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!regExp.hasMatch(value)) {
      return "Introduce un email válido";
    }

    return null; //Si todo fue bien
  }

}

class CheckUsername implements Check{

  @override
  String? comprobar(String? value){

    if(value == null || value.isEmpty) return "Campo obligatorio";

    if(value.contains('@')){
      return "El nombre de usuario no puede contener '@' ";
    }

    return null;
  }

}

class CheckPassword implements Check{

  @override
  String? comprobar(String? value){

    if(value == null || value.isEmpty) return "Campo obligatorio";

    bool err= false;
    String error = "La constraseña debe contener al menos: \n"; 

    //Longitud
    if (value.length<8) {
      err = true;
      error += " - 8 caracteres \n";
    }

    //Minúscula
    if (!value.contains(RegExp(r'[a-z]'))) {
      err = true;
      error += " - Un carácter en minúscula \n";
    }

    //Mayúscula
    if (!value.contains(RegExp(r'[A-Z]'))) {
      err = true;
      error += " - Un carácter en mayúscula \n";
    }

    //Número
    if (!value.contains(RegExp(r'[0-9]'))) {
      err = true;
      error += " - Un número \n";
    }


    //Caracter especial
    if (!value.contains(RegExp(r'[_\-.,:;{}+^`¡¿=)(/%#|ºª€@$!%*?&]'))) {
      err = true;
      error += " - Un carácter especial \n";
    }

  if(err){
    return error;
  }

    return null;
  }

}