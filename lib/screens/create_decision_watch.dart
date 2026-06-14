import 'package:dego/models/decision.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/decision_draft_provider.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/providers/create_provider.dart';

class CreateDecisionWatch extends ConsumerStatefulWidget {
  const CreateDecisionWatch({super.key});

  @override
  ConsumerState<CreateDecisionWatch> createState() => _CreateDecisionWatch();
}

class _CreateDecisionWatch extends ConsumerState<CreateDecisionWatch> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _dateControllerVote = TextEditingController(); // Controlador para la fecha

  bool _isInitialized = false;
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _dateControllerVote.dispose();
    super.dispose();
  }

  // Función para seleccionar Fecha, Hora y Minuto
  Future<void> _pickDateTime(bool isOptionDate) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      // ignore: use_build_context_synchronously
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

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // ignore: use_build_context_synchronously
          content: Text(context.lang.error_tiempo),
          // backgroundColor: Colors.redAccent,
        ),
      );

      return; // Rompe la función y no actualiza el estado
  }

    // Formato: DD-MM-AAAA HH:MM
    final formattedText = 
      "${finalDateTime.day.toString().padLeft(2, '0')}-${finalDateTime.month.toString().padLeft(2, '0')}-${finalDateTime.year} "
      "${finalDateTime.hour.toString().padLeft(2, '0')}:${finalDateTime.minute.toString().padLeft(2, '0')}";

    setState(() {
        _dateControllerVote.text = formattedText;
        ref.read(decisionDraftProvider.notifier).setVoteDate(finalDateTime);
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
    final double labelWidth = web ? screenWidth * 0.1 : screenWidth * 0.25;

    final usuarioAsync = ref.watch(usuarioProvider);
    final currentUserId = usuarioAsync.value?.id;

    final currentGroupId = ref.watch(idCurrentGroupProvider);

    final draft = ref.watch(decisionDraftProvider);

    if(!_isInitialized){
      _title.text = draft.title ?? "";
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
                  context.lang.crear_decision,
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
                      SizedBox(height: web ? screenHeight * 0.01 : screenHeight * 0.02),

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
                              onChanged: (value) => ref.read(decisionDraftProvider.notifier).setTitle(value),
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

                    SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),

                    //FECHA FINAL VOTACIÓN
                    if(draft.type!=DecisionType.roulette) ...[
                    TextFormField(
                      controller: _dateControllerVote,
                      readOnly: true,
                      onTap: () => _pickDateTime(false),
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
                                draft.vote_date=null;
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

                    ],

                      // BOTONES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CANCELAR
                          ElevatedButton(
                            onPressed: () {
                              ref.read(decisionDraftProvider.notifier).reset();
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

                          // EMPEZAR
                          ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);
                                      try {
                                        
                                        //Tiene que tener al menos 2 opciones para empezar la votación
                                        if(draft.options.length<2){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(context.lang.error_num_opciones),
                                            ),
                                          );
                                          _loading=false;
                                          return;
                                        }

                                        //Elimina el tiempo de opciones
                                          draft.options_date=null;

                                        //Elimina el tiempo de votación si es de tipo ruleta
                                        if(draft.type==DecisionType.roulette) {
                                          draft.vote_date=null;
                                        }

                                        //Crear la decisión
                                        await ref.read(createProvider.notifier).createDecision(id_creator: currentUserId!, id_group: currentGroupId, state: DecisionState.vote, decision: draft);

                                        //Borra decisionDraft
                                        ref.read(decisionDraftProvider.notifier).reset();
                                        
                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(context.lang.exito_crear_decision)),
                                        );

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
                                    context.lang.empezar,
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