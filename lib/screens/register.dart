import 'package:dego/funciones/check.dart';
import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Register extends ConsumerStatefulWidget {

  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _Register();
}

class _Register extends ConsumerState<Register> {

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

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
     body: Form(
      key: _formKey,
      child: Center (
        child: SingleChildScrollView(
        child: Column(children: [

          //USERNAME
          Row(children: [
            Text("Nombre de usuario: "),
            Expanded(
            child: TextFormField(
              key: const Key('usernameField'),
              controller: _username,
              validator:  (value) => CheckUsername().comprobar(value),
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
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
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
            ),
            ),
          ],),

          //EMAIL
          Row(children: [
            Text("Email: "),
            Expanded(
            child: TextFormField(
              key: const Key('emailField'),
              controller: _email,
              validator:  (value) => CheckEmail().comprobar(value),
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
            ),
            ),
          ],),

          //CONTRASEÑA
          Row(children: [
            Text("Contraseña: "),
            Expanded(
            child: TextFormField(
              key: const Key('passwordField'),
              validator:  (value) => CheckPassword().comprobar(value),
              controller: _password,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                errorMaxLines: 6,
                border: InputBorder.none,
                hintText: 'Introducir contraseña',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
              ),
            ),
            ),
          ],),

          //REPETIR CONTRASEÑA
          Row(children: [
            Text("Repetir contraseña: "),
            Expanded(
            child: TextFormField(
              key: const Key('password2Field'),
              controller: _password2,
              validator:  (value) {
                if (value == null || value.isEmpty) return "Campo obligatorio";
                if (value != _password.text) return "Las contraseñas no coinciden";
                return null;
              },
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
            ),
            ),
          ],),

          ElevatedButton(
          onPressed: _loading ? null : () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _loading = true);

            try {
              await ref.read(authProvider.notifier).register(
                email: _email.text,
                username: _username.text,
                name: _name.text,
                password: _password.text,
              );

              // Éxito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Usuario creado correctamente")),
              );

            } catch (e) {
              // Error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }

              setState(() => _loading = false);
            }
          },
          child: const Text("Registrarse"),
        )

      ],)
     ),
     ),
     ),
    );
  }

}