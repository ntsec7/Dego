import 'package:dego/providers/auth_provider.dart';
import 'package:dego/widgets/legal_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/funciones/check.dart';
import 'package:dego/utilities/error.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends ConsumerStatefulWidget {

  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _Profile();
}

class _Profile extends ConsumerState<Profile> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  bool _passwordVisible= true;
  bool _passwordVisible2= true;

  bool _loading = false;

  final picker = ImagePicker();

  Uint8List? imageBytes;
  XFile? selectedImage;

  //Bandera para asignar los valores de Riverpod solo una vez.
  bool _isInitialized = false;
  bool imageRemoved = false;

@override
Widget build(BuildContext context) {
  final usuarioAsync = ref.watch(usuarioProvider);
  
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;  //Para ver si el tema es claro u oscuro

  final double avatarSize = web ? screenWidth * 0.08 : screenWidth * 0.25;


  return usuarioAsync.when(
        data: (usuario) {
          if (usuario == null) {
            return const Center(child: Text("No hay usuario"));
          }

            if (!_isInitialized) {
              _username.text = usuario.username;
              _name.text = usuario.name;
              _email.text = Supabase.instance.client.auth.currentUser?.email ?? "";
              _isInitialized = true;
            }
            
    return Scaffold(
    body: SafeArea(
    child: SingleChildScrollView(
          child: Column(
            children: [

              //TITULO Y PAPELERA
              Padding(
                padding:EdgeInsets.only(
                top: web ? screenHeight * 0.03 : screenHeight * 0.02,
                bottom: web ? 0 : screenHeight * 0.01,
                left: web ? screenWidth * 0.01 : screenWidth * 0.03,   
                right: web ? screenWidth * 0.03 : screenWidth * 0.05,  
              ),
               child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [ 
                  Text(
                  context.lang.perfil,
                  style: TextStyle(
                    fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline, 
                  )
                  ),
                  SizedBox(width: web ? screenWidth * 0.006 : screenWidth * 0.015),
                  if(isDarkMode) //imagen blanca
                    Image.asset( 
                      'assets/images/IconoPerfilBlanco.png',
                      width: web? screenWidth * 0.025 : screenWidth * 0.09,
                    )
                  else //Imagen oscura
                  Image.asset( 
                      'assets/images/IconoPerfil.png',
                      width: web? screenWidth * 0.025 : screenWidth * 0.09,
                    ),
                  ],
                ),
              
              const Spacer(),

              //PAPELERA
              if(usuario.tipo!='admin')
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.redAccent,
                  onPressed: () async{
                    //TODO ELIMINAR CUENTA
                  },
                ),
                
              ],
               ),
              ),

              //FOTO
              Stack(
                clipBehavior: Clip.none,
                children: [

                  GestureDetector(
                    onTap: () async {

                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (image != null) {
                        final bytes = await image.readAsBytes();

                        setState(() {
                          selectedImage = image;
                          imageBytes = bytes;
                          imageRemoved = false;
                        });
                      }
                    },

                    child: CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: Colors.grey[300],

                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : (usuario.image != null &&
                                  usuario.image!.isNotEmpty &&
                                  !imageRemoved)
                              ? NetworkImage(usuario.image!)
                              : null,

                      child: imageBytes == null &&
                              (usuario.image == null ||
                                  usuario.image!.isEmpty ||
                                  imageRemoved)
                          ? Icon(
                              Icons.photo,
                              size: avatarSize * 0.4,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                  ),

                  if (imageBytes != null ||
                      (usuario.image != null &&
                          usuario.image!.isNotEmpty &&
                          !imageRemoved))
                    Positioned(
                      top: -5,
                      right: -5,

                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = null;
                            imageBytes = null;
                            imageRemoved = true;
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFCC2525),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

                    Form(
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

                          SizedBox(height: web ? screenHeight * 0.01 : screenHeight * 0.03),

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

                        //   ElevatedButton(
                        //   onPressed: _loading ? null : () async {
                        //     if (_formKey.currentState!.validate()) {
                        //       setState(() => _loading = true);

                        //     try {
                        //       await ref.read(authProvider.notifier).register(
                        //         email: _email.text.trim(),
                        //         username: _username.text.trim(),
                        //         name: _name.text.trim(),
                        //         password: _password.text.trim(),
                        //       );

                        //       if(!context.mounted) return;

                        //       // Éxito
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(content: Text(context.lang.exito_crear_usuario)),
                        //       );

                        //       // _showEmailConfirmation(context);

                        //     } catch (e) {
                        //       // Error
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(content: Text(translateSupabaseError(context,e))),
                        //       );
                        //     }

                        //       setState(() => _loading = false);
                        //     }
                        //   },
                        //   child: _loading 
                        //     ? const CircularProgressIndicator(color: Colors.white) 
                        //     : Text(context.lang.registrarse,
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                        //         ),),
                        // ),

                        // BOTONES
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [

                      //   //CANCELAR
                      //   ElevatedButton(
                      //     onPressed: () => Navigator.of(context).pushReplacementNamed('mainContainer'),
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Color(0xFFCC2525), // Color personalizado
                      //       foregroundColor: Colors.white, // Tamaño
                      //     ),
                      //     child: Text(context.lang.cancelar,
                      //     style: TextStyle(
                      //       fontSize: web
                      //           ? (screenHeight + screenWidth) * 0.01
                      //           : (screenHeight + screenWidth) * 0.015,
                      //     ),),
                      //   ),

                      // SizedBox(width: web ? screenWidth * 0.04 : screenWidth * 0.04),

                        //GUARDAR 
                        ElevatedButton(
                          onPressed: _loading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _loading = true);
                              try {
                                
                                // Uint8List? sendImage;
                                // bool deletePhoto= false;

                                // if(imageBytes!=null){ //nueva foto
                                //   sendImage = imageBytes;
                                // } else if(imageRemoved){  //ha borrado la foto que había
                                //   deletePhoto = true;
                                // }

                                // String? sendName;
                                // if (_name.text.trim() != grupo?.name) {
                                //   sendName = _name.text.trim();  //Solo lo enviamos si es distinto de lo que había
                                // }

                                // if(sendImage!=null || deletePhoto || sendName!=null){
                                //   await ref.read(createProvider.notifier).updateGroup(id:grupo!.id, name: sendName, image: sendImage, deletePhoto: deletePhoto, oldImageName: grupo.image);
                                // }

                                if(!context.mounted) return;

                                Navigator.pushNamed(context, 'mainContainer');
                                
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(translateSupabaseError(context, e))),
                                );
                              }
                              setState(() => _loading = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF098238), // Color personalizado
                            foregroundColor: Colors.white, // Tamaño
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(context.lang.guardar,
                                style: TextStyle(
                                fontSize: web
                                    ? (screenHeight + screenWidth) * 0.01
                                    : (screenHeight + screenWidth) * 0.015,
                              ),),
                        ),
                      // ]),

                            ],
                            ),
                          ),

                      ],)
                    ),
                    ),

                    SizedBox(height: web ? screenHeight * 0.03 : screenHeight * 0.1),

                  //CERRAR SESION
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 199, 199),
                        foregroundColor: Color.fromARGB(255, 142, 0, 0), 
                        side: BorderSide( //Borde
                          color: Color.fromARGB(255, 142, 0, 0),
                          width: 1.5,
                        ),
                      ),
                      onPressed: () async{
                        await ref.read(authProvider.notifier).logout();
                      },
                      child: Text(context.lang.logout,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                            ),),
                  ),

          ],
          ),
           ),
        ),
        bottomNavigationBar: LegalFooter(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
  );
}
}