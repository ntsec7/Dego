// ignore_for_file: use_build_context_synchronously

import 'package:dego/models/watch_decision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/watch_decision_provider.dart';

class EditDecisionWatch extends ConsumerStatefulWidget {

  final String id;

  const EditDecisionWatch({super.key, required this.id});

  @override
  ConsumerState<EditDecisionWatch> createState() => _EditDecisionWatch();
}

class _EditDecisionWatch extends ConsumerState<EditDecisionWatch> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateControllerVote = TextEditingController(); // Controlador para la fecha

  bool _isInitialized = false;
  bool _loading = false;

  @override
  void dispose() {
    _dateControllerVote.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.year} "
          "${date.hour.toString().padLeft(2, '0')}:"
          "${date.minute.toString().padLeft(2, '0')}";
  }

  // Función para seleccionar Fecha, Hora y Minuto
  Future<void> _pickDateTime(WatchDecision decision) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;


    final finalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    //Comprobar que no ha pasado ya esa hora
    if (finalDateTime.isBefore(DateTime.now())) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.lang.error_tiempo),
          // backgroundColor: Colors.redAccent,
        ),
      );

      return; // Rompe la función y no actualiza el estado
  }

    // Formato: DD-MM-AAAA HH:MM
    final formattedText = formatDate(finalDateTime);

    setState(() {
        _dateControllerVote.text = formattedText;
        decision.finish_hour=finalDateTime;
    });

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    // Ajuste de márgenes para que empiece más a la izquierda y aproveche la pantalla
    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;


    final decisionAsync = ref.watch(watchDecisionByIdProvider(widget.id));


    if(decisionAsync.isLoading){
      return const Scaffold(body: Center(child: CupertinoActivityIndicator(radius: 15)));
    }

    final decision = decisionAsync.requireValue;

    if (!_isInitialized) {
      _dateControllerVote.text = decision.finish_hour != null ? formatDate(decision.finish_hour!) : "";
      _isInitialized = true; 
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TÍTULO DE LA PANTALLA
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: web ? screenHeight * 0.03 : screenHeight * 0.02,
                horizontal: web ? screenWidth * 0.15 : screenWidth * 0.05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.lang.editar_decision,
                  style: TextStyle(
                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.018,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),


            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: ladoIzquierdo, right: ladoDerecho, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                    SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),

                    // BOTÓN TERMINAR VOTACIÓN
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.primary, 
                        side: BorderSide( //Borde
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      onPressed: () async{

                        decision.finish = true;

                        //Actualizar la decisión
                        await ref.read(createProvider.notifier).editWatchDecision(decision: decision);

                        if(!context.mounted) return;

                        Navigator.pop(context);

                      },
                      child: Text(context.lang.terminar_votacion,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                            ),),
                    ),

                  SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),

                    //FECHA FINAL VOTACIÓN
                    TextFormField(
                      controller: _dateControllerVote,
                      readOnly: true,
                      onTap: () => _pickDateTime(decision),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black, 
                      ),
                      //validator: (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                      decoration: InputDecoration(
                        hintText: context.lang.fecha_final_votacion,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                        ),
                        prefixIcon: const Icon(Icons.calendar_today, size: 18, color:Colors.black),
                        suffixIcon: _dateControllerVote.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _dateControllerVote.clear(); // Borra el texto del input
                                decision.finish_hour=null;
                              });
                            },
                          )
                        : null, // Si está vacío, no muestra nada en la derecha
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),

                    SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),


                      // BOTONES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CANCELAR
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCC2525),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              context.lang.cancelar,
                              style: TextStyle(
                                fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                              ),
                            ),
                          ),

                          SizedBox(width: screenWidth * 0.05),

                          // GUARDAR
                          ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);
                                      try {

                                        //Actualizar la decisión
                                        await ref.read(createProvider.notifier).editWatchDecision(decision: decision);
                                        
                                        if (!context.mounted) return;

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
                              backgroundColor: const Color(0xFF098238),
                              foregroundColor: Colors.white,
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    context.lang.guardar,
                                    style: TextStyle(
                                      fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
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