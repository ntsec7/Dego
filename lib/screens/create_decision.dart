import 'package:dego/models/decision.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';

class CreateDecision extends ConsumerStatefulWidget {

  const CreateDecision({super.key});

  @override
  ConsumerState<CreateDecision> createState() => _CreateDecision();
}

class _CreateDecision extends ConsumerState<CreateDecision> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  DecisionType _selectedType = DecisionType.simple;

  bool _loading = false;

// Liberar controladores para evitar fugas de memoria
  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  final usuarioAsync = ref.watch(usuarioProvider);
  final currentUserId = usuarioAsync.value?.tipo;

  return Scaffold(
    body: SafeArea(
      child:  Column(
            children: [

              //TíTULO
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: web ? screenHeight * 0.03 : screenHeight * 0.02,
                  horizontal: web ? screenWidth * 0.3 : screenWidth * 0.1),
               child: 
               Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  context.lang.crear_decision,
                  style: TextStyle(
                    fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline, 
                  )
               ),
               ),
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
 
                  //TITULO
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,  //para que el error no suba el campo
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        SizedBox(
                          width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                          child: Text("${context.lang.titulo}: ",
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
                        controller: _title,
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
                            hintText: context.lang.titulo,
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


                    //TIPO
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline, // para que el error no suba el campo
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        SizedBox(
                          width: web ? screenWidth * 0.1 : screenWidth * 0.25,
                          child: Text(
                            "${context.lang.tipo}: ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: DropdownButtonFormField<DecisionType>(
                            key: const Key('typeField'),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            initialValue: _selectedType,
                            validator: (value) => value == null ? context.lang.campo_obligatorio : null,
                            
                            // Al cambiar, actualizamos el controlador
                            onChanged: (DecisionType? newValue) {
                              if (newValue != null) {
                                _selectedType = newValue;
                              }
                            },
                            
                            // Opciones del desplegable
                            items: DecisionType.values.map((DecisionType type) {
                              return DropdownMenuItem<DecisionType>(
                                value: type,                  // El valor interno ahora es el enum (ej: DecisionType.roulette)
                                child: Text(type.title(context)), // Usa tu extensión para traducir el texto
                              );
                            }).toList(),

                            // Estilos del texto seleccionado
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Arial',
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
                            ),

                            decoration: InputDecoration(
                              hintText: context.lang.nombre, 
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Arial',
                                fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                              ),
                              errorStyle: TextStyle(
                                fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.012,
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), 
                            ),
                            
                            // Ajustes visuales extra del desplegable
                            alignment: Alignment.center, 
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: web ? screenHeight * 0.03 : screenHeight * 0.03),

                    //OPCIONES





                    SizedBox(height: web ? screenHeight * 0.03 : screenHeight * 0.05),

                  // BOTONES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                  //CANCELAR
                  ElevatedButton(
                    onPressed: () => {

                      //TODO ELIMINAR LA DECISIÓN

                      Navigator.pop(context),
                    },
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

                          if(true){

                            //TODO ACTUALIZAR LA DECISION
                            
                            if(!context.mounted) return;

                            Navigator.pushNamed(context,'createDecisionStep2');
                          
                          }
                          
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
                        : Text(context.lang.crear,
                          style: TextStyle(
                          fontSize: web
                              ? (screenHeight + screenWidth) * 0.01
                              : (screenHeight + screenWidth) * 0.015,
                        ),),
                  ),
                    ],
                  ),
                      ],
                      ),
                    ),

                ],)
              ),
            ),
          ],
          ),
        ),
  );
}
}