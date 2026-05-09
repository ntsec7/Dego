import 'package:dego/providers/auth_provider.dart';
import 'package:dego/utilities/error.dart';
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

  final TextEditingController _name = TextEditingController();  //puede ser email o username
  final TextEditingController _password = TextEditingController();

  bool _passwordVisible= true;

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
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(translateSupabaseError(context,e))),
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

    bool web = screenWidth > 600 ? true : false;

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
                child: SingleChildScrollView(
                  child: Center( 
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                  child: Form(
                  key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal

                    children: [

                    //NOMBRE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,  //para que el error no suba el campo
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        SizedBox(
                          width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                          child: Text("${context.lang.usuario}: ",
                            textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize : web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
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
                            fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
                          ),
                          decoration: InputDecoration(
                                      hintText: context.lang.intro_usuario,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Arial',
                                        fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.012,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: web ? (screenHeight + screenWidth) *0.007 : (screenHeight + screenWidth) *0.012,
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
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                        SizedBox(
                          width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                          child: Text("${context.lang.contra}: ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize : web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
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
                          obscureText: _passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Arial',
                            fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) * 0.012,
                          ),
                          decoration: InputDecoration(
                            errorMaxLines: 6,
                            hintText: context.lang.intro_contra,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Arial',
                              fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.0125,
                            ),
                            errorStyle: TextStyle(
                              fontSize: web ? (screenHeight + screenWidth) *0.007 : (screenHeight + screenWidth) *0.012,
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)), 
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true, // Esto reduce el tamaño base
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            suffixIcon: IconButton(
                            icon: Icon(
                              // Cambia el icono según el estado
                              _passwordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Actualizamos el estado para redibujar el widget
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          ),
                        ),
                        ),
                      ],),

                      SizedBox(height: screenHeight * 0.02),

                      //HE OLVIDADO MI CONTRASEÑA
                      InkWell(
                        onTap: () {
                          _showResetPasswordDialog(context);
                        },
                        child: Text(
                          context.lang.olvidado_contra,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            fontSize:  web ? (screenHeight + screenWidth) *0.007 : (screenHeight + screenWidth) *0.012,
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
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(translateSupabaseError(context,e))),
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
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
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
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                            ),),
                    ),

                    SizedBox(height: screenHeight * 0.08),

                    Image.asset(
                      'assets/images/logo.png',
                      // Si el 20% del ancho es mayor a 150px, usa el 0.07(para web)
                      width: (screenWidth * 0.2) > 150 ? screenWidth * 0.07 : screenWidth * 0.2,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                  ],)
                ),
                ),
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