import 'package:dego/funciones/check.dart';
import 'package:dego/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dego/widgets/legal_footer.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';

class Register extends ConsumerStatefulWidget {

  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _Register();
}

class _Register extends ConsumerState<Register> {

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  bool _passwordVisible= true;
  bool _passwordVisible2= true;

  void _showEmailConfirmation(BuildContext context) {

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(context.lang.confirmar_email),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.lang.confirmar_email_text,
            ),
            SizedBox(height: 12),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, 'login'),
            child: Text(context.lang.continuar),
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: web ? screenWidth * 0.3 : screenWidth * 0.1),
          child : Stack(
          alignment: Alignment.center,
          children: [

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
            ),
            ),

            //DEGO
            Text(
              "DEGO",
              style: GoogleFonts.shareTechMono(
                fontSize: (screenHeight + screenWidth) * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],), ), 

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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal

          children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
            children: [

          SizedBox(height: screenHeight * 0.05),

            //USERNAME
            Row(
              // crossAxisAlignment: CrossAxisAlignment.baseline,  //para que el error no suba el campo
              // textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                  child: Text("${context.lang.username}: ",
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
              key: const Key('usernameField'),
              controller: _username,
              validator:  (value) => CheckUsername().check(value),
              cursorColor: Colors.grey,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                  hintText: context.lang.username,
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

        SizedBox(height: screenHeight * 0.03),

        //NOMBRE
        Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,  //para que el error no suba el campo
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                child: Text("${context.lang.nombre}: ",
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
              key: const Key('nameField'),
              controller: _name,
              validator:  (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
              cursorColor: Colors.grey,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize:  web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                  hintText: context.lang.nombre,
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

          SizedBox(height: screenHeight * 0.03),

          //EMAIL
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,  //para que el error no suba el campo
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                child: Text("${context.lang.email}: ",
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
              key: const Key('emailField'),
              controller: _email,
              validator:  (value) => CheckEmail().check(value),
              cursorColor: Colors.grey,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontFamily: 'Arial',
                fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
              ),
              decoration: InputDecoration(
                hintText: context.lang.email,
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

          SizedBox(height: screenHeight * 0.03),

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
              validator:  (value) {
                if (value == null || value.isEmpty) return context.lang.campo_obligatorio;
                return CheckPassword().check(value);
              },
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

          SizedBox(height: screenHeight * 0.03),

          //REPETIR CONTRASEÑA
          Row(
              // crossAxisAlignment: CrossAxisAlignment.baseline,  //para que el error no suba el campo
              // textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              width: web ? screenWidth * 0.1 : screenWidth * 0.25,
              child: Text("${context.lang.repite_contra}: ",
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
              key: const Key('password2Field'),
              controller: _password2,
              validator:  (value) {
                if (value == null || value.isEmpty) return context.lang.campo_obligatorio;
                if (value != _password.text) return context.lang.contras_no_coinciden;
                return null;
              },
              cursorColor: Colors.grey,
              textAlign: TextAlign.center,
              obscureText: _passwordVisible2,
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
                  _passwordVisible2 ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Actualizamos el estado para redibujar el widget
                  setState(() {
                    _passwordVisible2 = !_passwordVisible2;
                  });
                },
              ),
              ),
            ),
            ),
          ],),

          SizedBox(height: screenHeight * 0.07),

          ElevatedButton(
          onPressed: _loading ? null : () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _loading = true);

            try {
              await ref.read(authProvider.notifier).register(
                email: _email.text.trim(),
                username: _username.text.trim(),
                name: _name.text.trim(),
                password: _password.text.trim(),
              );

              if(!context.mounted) return;

              // Éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.lang.exito_crear_usuario)),
              );

              _showEmailConfirmation(context);

            } catch (e) {
              // Error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translateSupabaseError(context,e))),
              );
            }

              setState(() => _loading = false);
            }
          },
          child: _loading 
            ? const CircularProgressIndicator(color: Colors.white) 
            : Text(context.lang.registrarse,
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

            ],
            ),
          ),
          const LegalFooter(),

      ],)
     ),
     ),
     ),
                  ),
                  ),
                ),
            ),
          ],
        ),
     ),
    );
  }

}