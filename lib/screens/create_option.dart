import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/error.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:dego/providers/current_group_provider.dart';

class CreateOption extends ConsumerStatefulWidget {
  const CreateOption({super.key});

  @override
  ConsumerState<CreateOption> createState() => _CreateOption();
}

class _CreateOption extends ConsumerState<CreateOption> {

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final picker = ImagePicker();

  Uint8List? imageBytes;
  XFile? selectedImage;

  //Bandera para asignar los valores de Riverpod solo una vez.
  bool imageRemoved = false;


  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600 ? true : false;

    final grupo = ref.watch(currentGroupProvider);

    final labelWidth = web ? screenWidth * 0.1 : screenWidth * 0.3;

    return Scaffold(
      body: SafeArea(
        child: Column( 
          children: [

            //Título
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: web ? screenWidth * 0.3 : screenWidth * 0.1),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.lang.crear_opcion,
                    style: TextStyle(
                      fontSize: web
                          ? (screenHeight + screenWidth) * 0.01
                          : (screenHeight + screenWidth) * 0.02,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  ),
                ],
              ),
            ),

            
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: screenHeight * 0.05),
                                
                            //TÍTULO
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                SizedBox(
                                  width: labelWidth,
                                  child: 
                                  Text.rich(
                                    TextSpan(
                                      text: "${context.lang.titulo} ", 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                                        color: Theme.of(context).textTheme.bodyLarge?.color, 
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: '*', 
                                          style: TextStyle(
                                            color: Colors.red, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' :', 
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  )
                                                            ),
                                SizedBox(width: screenWidth * 0.03),
                                Expanded(
                                  child: TextFormField(
                                    key: const Key('nameField'),
                                    controller: _title,
                                    validator: (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                                    cursorColor: Colors.grey,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Arial',
                                      fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: context.lang.titulo,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.012,
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.04),

                            //DESCRIPCIÓN
                            Row(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Alineado arriba porque es multilínea
                                  children: [
                                    SizedBox(
                                      width: labelWidth,
                                      child: Text(
                                        "${context.lang.descripcion}: ",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: web
                                              ? (screenHeight + screenWidth) * 0.012
                                              : (screenHeight + screenWidth) * 0.014,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.03),
                                    Expanded(
                                      child: TextFormField(
                                        key: const Key('descriptionField'),
                                        controller: _description,
                                        maxLines: 4, // Permite múltiples líneas para texto libre
                                        minLines: 2,
                                        cursorColor: Colors.grey,
                                        textAlign: TextAlign.start, // Alineación de texto tradicional para parágrafos
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Arial',
                                          fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: context.lang.descripcion_txt,
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                                          ),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), // Bordes sutiles para bloques de texto
                                          filled: true,
                                          fillColor: Colors.white,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),


                              SizedBox(height: screenHeight * 0.04),

                             Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: labelWidth,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0), // Nivelado visualmente con el botón
                                        child: Text(
                                            "${context.lang.imagen}: ", 
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                                                color: Theme.of(context).textTheme.bodyLarge?.color, 
                                              ),
                                          )
                                      ),
                                    ),
                                  
                                //FOTO
                                Stack(  //para poder poner la x
                                  children: [

                                    ElevatedButton(
                                      onPressed: () async {

                                        final XFile? image = await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );

                                        if(image != null){

                                          final bytes = await image.readAsBytes();

                                          setState(() {
                                            selectedImage = image;
                                            imageBytes = bytes;
                                            imageRemoved = false;
                                          });
                                        }
                                      },

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: EdgeInsets.zero,
                                        fixedSize: Size(
                                          web ? screenWidth * 0.4 : screenWidth * 0.8,
                                          web ? screenHeight * 0.4 : screenHeight * 0.3,
                                        ),
                                      ),

                                      child: ClipRRect( //para que la imagen no se salga del borde
                                        borderRadius: BorderRadius.circular(15),

                                        child: imageBytes != null
                                            ? 
                                              Image.memory(
                                                imageBytes!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )

                                              : (grupo?.image != null && grupo!.image!.isNotEmpty && !imageRemoved)
                                                ? Image.network(
                                                    grupo.image!, // URL de la foto actual guardada en tu BD (ej: Supabase/Firebase)
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    errorBuilder: (context, error, stackTrace) => Icon(
                                                      Icons.photo,
                                                      size: web ? screenWidth * 0.05 : screenWidth * 0.2,
                                                      color: Colors.grey[600],
                                                    ),
                                                  )
                                            
                                            :Icon(
                                                Icons.photo,
                                                size: web ? screenWidth * 0.05 : screenWidth * 0.2,
                                                color: Colors.grey[600],
                                              ),
                                      ),
                                    ),

                                    if(imageBytes != null || (grupo?.image != null && grupo!.image!.isNotEmpty && !imageRemoved) )
                                      Positioned(
                                        top: 10,
                                        right: 10,

                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImage = null;
                                              imageBytes = null;
                                              imageRemoved= true;
                                            });
                                          },

                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFCC2525),
                                              shape: BoxShape.circle,
                                            ),

                                            padding: const EdgeInsets.all(5),

                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                  ],
                             ),

                                SizedBox(height: screenHeight * 0.07),

                                // BOTONES
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                //CANCELAR
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFCC2525), // Color personalizado
                                    foregroundColor: Colors.white, // Tamaño
                                  ),
                                  child: Text(context.lang.cancelar,
                                  style: TextStyle(
                                    fontSize: web
                                        ? (screenHeight + screenWidth) * 0.01
                                        : (screenHeight + screenWidth) * 0.015,
                                  ),),
                                ),

                              SizedBox(width: web ? screenWidth * 0.04 : screenWidth * 0.04),

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

                                        if(!context.mounted) return;

                                        Navigator.pop(context);
                                        
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
                              ]),

                                SizedBox(height: screenHeight * 0.03),
                              ],
                            ),
                          ),
                        ],
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