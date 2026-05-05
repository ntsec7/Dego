import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';
import 'package:dego/funciones/check.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {

    bool _loading = false;

    final _formKey = GlobalKey<FormState>();

    final TextEditingController _password = TextEditingController();
    final TextEditingController _password2 = TextEditingController();

    bool _passwordVisible= true;
    bool _passwordVisible2= true;

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
              child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
            ),
            

            //Titulo
            Text(
              context.lang.recuperar_contra,
              style: TextStyle(
                fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline, 
              )
            ),
              ],
              ),
          ),

          ],), ), 

            Expanded(
              child: Align(
                alignment: Alignment.center,
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
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            SizedBox(height: screenHeight * 0.05),

          Text(context.lang.intro_nueva_contra,
          textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: web ? (screenHeight + screenWidth) *0.008 : (screenHeight + screenWidth) *0.0125,
            ),
          ),

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
              validator:  (value) => CheckPassword().check(value),
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
              // await ref.read(authProvider.notifier).register(
              //   email: _email.text.trim(),
              //   username: _username.text.trim(),
              //   name: _name.text.trim(),
              //   password: _password.text.trim(),
              // );

              // Éxito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Usuario creado correctamente")),
              );

              Navigator.of(context).pushReplacementNamed('/');

            } catch (e) {
              // Error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }

              setState(() => _loading = false);
            }
          },
          child: _loading 
            ? const CircularProgressIndicator(color: Colors.white) 
            : Text(context.lang.guardar,
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

          ],
      ),
      ),
                ),
              // ),
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