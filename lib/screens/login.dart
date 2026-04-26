import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:google_fonts/google_fonts.dart';

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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center, // Centrado vertical
          crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal

        children: [

          //DEGO
          Text(
              "DEGO",
              style: GoogleFonts.shareTechMono(
                fontSize: (screenHeight + screenWidth) * 0.05, 
                fontWeight: FontWeight.bold),
          ),
          
          SizedBox(height: screenHeight * 0.1),


        //NOMBRE
        Row(children: [
            Text("${context.lang.usuario}: ",
             style: TextStyle(
              fontSize : (screenHeight + screenWidth) * 0.014,
             ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
            child:TextFormField(

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
                          hintText: context.lang.intro_usuario,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Arial',
                            fontSize:(screenHeight + screenWidth) *0.0125,
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)), 
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true, // Esto reduce el tamaño base
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
            ),
            ),
          ],),

          SizedBox(height: screenHeight * 0.05),

          //CONTRASEÑA
          Row(children: [
            Text("${context.lang.contra}: ",
             style: TextStyle(
              fontSize : (screenHeight + screenWidth) * 0.014,
             ),
            ),
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
                hintText: context.lang.intro_contra,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                  fontSize:(screenHeight + screenWidth) *0.0125,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)), 
                filled: true,
                fillColor: Colors.white,
                isDense: true, // Esto reduce el tamaño base
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            ),
          ],),

          SizedBox(height: screenHeight * 0.05),

          //INICIAR SESIÓN
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
            : Text(context.lang.login),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'register');
          },
          child: Text(context.lang.registrarse),
        ),

      ],)
     ),
     ),
     ),
    );
  }

}