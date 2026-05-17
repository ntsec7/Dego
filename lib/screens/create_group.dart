import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/error.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class CreateGroup extends ConsumerStatefulWidget {
  const CreateGroup({super.key});

  @override
  ConsumerState<CreateGroup> createState() => _CreateGroup();
}

class _CreateGroup extends ConsumerState<CreateGroup> {

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();

  final picker = ImagePicker();

  Uint8List? imageBytes;
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600 ? true : false;

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
                    context.lang.crear_grupo,
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
                                
                                //NOMBRE
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    SizedBox(
                                      width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                                      child: Text(
                                        "${context.lang.nombre}: ",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: web
                                              ? (screenHeight + screenWidth) * 0.012
                                              : (screenHeight + screenWidth) * 0.014,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: web ? screenWidth * 0.015 : screenWidth * 0.03),
                                    Expanded(
                                      child: TextFormField(
                                        key: const Key('nameField'),
                                        validator: (value) => value == null || value.isEmpty
                                            ? context.lang.campo_obligatorio
                                            : null,
                                        controller: _name,
                                        style: const TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          hintText: context.lang.nombre,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(40)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),


                                SizedBox(height: screenHeight * 0.04),

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

                                        child: imageBytes == null

                                            ? Icon(
                                                Icons.photo,
                                                size: web ? screenWidth * 0.05 : screenWidth * 0.2,
                                                color: Colors.grey[600],
                                              )

                                            : Image.memory(
                                                imageBytes!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                      ),
                                    ),

                                    if(imageBytes != null)
                                      Positioned(
                                        top: 10,
                                        right: 10,

                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImage = null;
                                              imageBytes = null;
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

                                SizedBox(height: screenHeight * 0.07),

                                // BOTONES
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                //CANCELAR
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pushReplacementNamed('mainContainer'),
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

                                //CREAR    
                                ElevatedButton(
                                  onPressed: _loading ? null : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);
                                      try {
                                        
                                        await ref.read(createProvider.notifier).createGroup(name: _name.text.trim(), image: imageBytes);

                                        if(!context.mounted) return;

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(context.lang.exito_crear_grupo)),
                                        );

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