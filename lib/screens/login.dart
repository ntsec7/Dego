import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:dego/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {

  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _Login();
}

class _Login extends ConsumerState<Login> {

  bool _loading= false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();  //puede ser email o username
  TextEditingController _password = TextEditingController();

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

          //CONTRASEÑA
          Row(children: [
            Text("Contraseña: "),
            Expanded(
            child: TextFormField(
              key: const Key('passwordField'),
              validator:  (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              controller: _password,
              cursorColor: Colors.grey,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
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

          ElevatedButton(
          onPressed: _loading
          ? null // Deshabilita el botón mientras carga
          : () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _loading = true);
            try {
              await ref.read(authProvider.notifier).login(_name.text.trim(),_password.text.trim(),);
            } catch (e) {
              print(e);
              // Error
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }
            finally {
              if (mounted) setState(() => _loading = false);
            }
            }
          },
          child: _loading 
            ? const CircularProgressIndicator(color: Colors.white) 
            : const Text("Iniciar Sesión"),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'register');

            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => const Register()),
            // );

          },
          child:const Text("Registrarse"),
        )

      ],)
     ),
     ),
     ),
    );
  }

}