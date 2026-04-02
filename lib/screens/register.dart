import 'package:flutter/material.dart';
import 'package:dego/services/auth_service.dart';

class Register extends StatefulWidget {

  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _password2 = TextEditingController();

   @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final textFieldWidth = screenWidth * 0.5;

    return Scaffold(
     body: Center (
        child: Column(children: [

          //USERNAME
          Row(children: [
            Text("Nombre de usuario: "),
            Expanded(
            child: TextFormField(
              key: const Key('nameField'),
              controller: _username,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Introducir nombre de usuario',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
              ),
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
            ),
            ),
          ],),

        //NOMBRE
        Row(children: [
            Text("Nombre: "),
            Expanded(
            child: TextFormField(
              key: const Key('nameField'),
              controller: _name,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Introducir nombre',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
              ),
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
            ),
            ),
          ],),

          //EMAIL
          Row(children: [
            Text("Email: "),
            Expanded(
            child: TextFormField(
              key: const Key('nameField'),
              controller: _email,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Introducir email',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
              ),
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
            ),
            ),
          ],),

          //CONTRASEÑA
          Row(children: [
            Text("Contraseña: "),
            Expanded(
            child: TextFormField(
              key: const Key('nameField'),
              controller: _password,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Introducir contraseña',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
              ),
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
            ),
            ),
          ],),

          //REPETIR CONTRASEÑA
          Row(children: [
            Text("Repetir contraseña: "),
            Expanded(
            child: TextFormField(
              key: const Key('nameField'),
              controller: _password2,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Repetir contraseña',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
              ),
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
            ),
            ),
          ],),

          ElevatedButton(
          onPressed: () async {
            try {
              await AuthService().register(
                email: _email.text,
                username: _username.text,
                name: _name.text,
                password: _password.text,
              );

              // Éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Usuario creado correctamente")),
              );

            } catch (e) {
              print(e);
              // Error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }
          },
          child: const Text("Registrarse"),
        )

      ],)
     ),
    );
  }

}