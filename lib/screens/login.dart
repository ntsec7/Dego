import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dego/funciones/check.dart';
import 'package:dego/widgets/legal_footer.dart';

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

  void _showResetPasswordDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(context.lang.recuperar_contra),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.lang.txt_recuperar_contra,
            ),
            SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: context.lang.intro_email,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(context.lang.cancelar),
          ),
          ElevatedButton(
            onPressed: () async {

              final email = emailController.text.trim();

              final error = CheckEmail().check(email);

              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
                return;
              }

              try {
                await ref.read(authProvider.notifier).recuperatePassword(email);

                if (context.mounted) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.lang.txt_recuperar_contra2),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: Text(context.lang.enviar),
          ),
        ],
      );
    },
  );
}

   @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final textFieldWidth = screenWidth * 0.5;

    return Scaffold(
     body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: screenHeight * 0.02), 

            //DEGO
            Text(
              "DEGO",
              style: GoogleFonts.shareTechMono(
                fontSize: (screenHeight + screenWidth) * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
              // child: Center(
                child: SingleChildScrollView(
                  child: Form(
                  key: _formKey,
                  // child: Center (
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.end, // En el fondo verticalmente
                      crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal

                    children: [

                    //NOMBRE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.25,
                          child: Text("${context.lang.usuario}: ",
                            textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize : (screenHeight + screenWidth) * 0.014,
                              ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                        child:TextFormField(

                          key: const Key('nameField'),
                          controller: _name,
                          validator:  (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                          cursorColor: Colors.grey,
                          textAlign: TextAlign.center,
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
                                        fontSize:(screenHeight + screenWidth) *0.012,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(
                          width: screenWidth * 0.25,
                          child: Text("${context.lang.contra}: ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize : (screenHeight + screenWidth) * 0.014,
                          ),
                          ),
                          ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                        child: TextFormField(
                          key: const Key('passwordField'),
                          validator:  (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                          controller: _password,
                          cursorColor: Colors.grey,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Arial',
                            fontSize: (screenHeight + screenWidth) * 0.012,
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

                      SizedBox(height: screenHeight * 0.02),

                      InkWell(
                        onTap: () {
                          _showResetPasswordDialog(context);
                        },
                        child: Text(
                          context.lang.olvidado_contra,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

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
                        : Text(context.lang.login,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: (screenHeight + screenWidth) * 0.014,
                            ),),
                    ),

                    SizedBox(height: screenHeight * 0.07),

                    //REGISTRARSE
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary, 
                        side: BorderSide( //Borde
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'register');
                      },
                      child: Text(context.lang.registrarse,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: (screenHeight + screenWidth) * 0.014,
                            ),),
                    ),

                    SizedBox(height: screenHeight * 0.08),

                    Image.asset(
                      'assets/images/logo.png',
                      width: screenWidth * 0.2,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                  ],)
                // ),
                ),
                ),
                ),
                  ),
                ),

              const LegalFooter(),
          ],
        ),
      ),
    );
  }

}