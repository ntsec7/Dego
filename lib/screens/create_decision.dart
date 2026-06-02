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
  final TextEditingController _dateControllerOption = TextEditingController(); // Controlador para la fecha
  final TextEditingController _dateControllerVote = TextEditingController(); // Controlador para la fecha
  DecisionType _selectedType = DecisionType.simple;
  DateTime? _selectedDateTimeOption;
  DateTime? _selectedDateTimeVote;

  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _dateControllerOption.dispose();
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
    final formattedText = 
      "${finalDateTime.day.toString().padLeft(2, '0')}-${finalDateTime.month.toString().padLeft(2, '0')}-${finalDateTime.year} "
      "${finalDateTime.hour.toString().padLeft(2, '0')}:${finalDateTime.minute.toString().padLeft(2, '0')}";

    setState(() {
      if (isOptionDate) {
        _selectedDateTimeOption = finalDateTime;
        _dateControllerOption.text = formattedText;
      } else {
        _selectedDateTimeVote = finalDateTime;
        _dateControllerVote.text = formattedText;
      }
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
    final currentUserId = usuarioAsync.value?.tipo;

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

                      SizedBox(height: screenHeight * 0.02),

                      //TIPO
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(
                            width: labelWidth,
                            child: 
                            // Text(
                            //   "${context.lang.tipo}: ",
                            //   textAlign: TextAlign.right,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w500,
                            //     fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                            //   ),
                            // ),
                            Text.rich(
                              TextSpan(
                                text: "${context.lang.tipo} ", // El texto normal (ej: "Título")
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                                  color: Theme.of(context).textTheme.bodyLarge?.color, // Color adaptativo al modo oscuro/claro
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*', // El asterisco obligatorio
                                    style: TextStyle(
                                      color: Colors.red, // Forzamos a que siempre sea rojo
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' :', // Los dos puntos finales si los necesitas
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            )
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: DropdownButtonFormField<DecisionType>(
                              key: const Key('typeField'),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              initialValue: _selectedType,
                              validator: (value) => value == null ? context.lang.campo_obligatorio : null,
                              onChanged: (DecisionType? newValue) {
                                if (newValue != null) {
                                  _selectedType = newValue;
                                }
                              },
                              items: DecisionType.values.map((DecisionType type) {
                                return DropdownMenuItem<DecisionType>(
                                  value: type,
                                  child: Text(type.title(context)),
                                );
                              }).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0125,
                              ),
                              decoration: InputDecoration(
                                hintText: context.lang.nombre,
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              ),
                              alignment: Alignment.center,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      //OPCIONES
                      Row(
                        children: [
                          SizedBox(
                            width: labelWidth,
                            child: 
                            // Text(
                            //   "${context.lang.opciones}: ",
                            //   textAlign: TextAlign.right,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w500,
                            //     fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                            //   ),
                            // ),
                            Text.rich(
                              TextSpan(
                                text: "${context.lang.opciones} ", // El texto normal (ej: "Título")
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                                  color: Theme.of(context).textTheme.bodyLarge?.color, // Color adaptativo al modo oscuro/claro
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*', // El asterisco obligatorio
                                    style: TextStyle(
                                      color: Colors.red, // Forzamos a que siempre sea rojo
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' :', // Los dos puntos finales si los necesitas
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            )
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          const Expanded(child: SizedBox()), // Espacio vacío para mantener alineación del título
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // RECTÁNGULO CON SCROLL INTERNO Y STICKY FOOTER
                      Container(
                        height: web ? screenHeight * 0.35 : screenHeight * 0.5, // Altura fija para el contenedor de opciones
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color.fromARGB(255, 143, 143, 143)),
                        ),
                        child: Column(
                          children: [
                            //Opciones
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Contenido de las opciones 1...", style: TextStyle(fontSize: web ? 14 : 16)),
                                    const SizedBox(height: 10),
                                    Text("Contenido de las opciones 2...", style: TextStyle(fontSize: web ? 14 : 16)),
                                    const SizedBox(height: 10),
                                    Text("Contenido de las opciones 3...", style: TextStyle(fontSize: web ? 14 : 16)),
                                    const SizedBox(height: 10),
                                    Text("Contenido de las opciones 4...", style: TextStyle(fontSize: web ? 14 : 16)),
                                    // Añade aquí los inputs dinámicos de las opciones que necesites
                                  ],
                                ),
                              ),
                            ),

                            // STICKY FOOTER (Fijo abajo del rectángulo)
                            Container(
                              decoration: BoxDecoration(
                                // color: const Color.fromARGB(255, 143, 143, 143), // Fondo diferenciado para el footer fijo
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                border: Border(top: BorderSide(color: const Color.fromARGB(255, 143, 143, 143))),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  //FECHA FINAL OPCIONES
                                  TextFormField(
                                    controller: _dateControllerOption,
                                    readOnly: true,
                                    onTap: () => _pickDateTime(true),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black, 
                                    ),
                                    validator: (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                                    decoration: InputDecoration(
                                      hintText: context.lang.fecha_final_opciones,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                                      ),
                                      prefixIcon: const Icon(Icons.calendar_today, size: 18, color:Colors.black),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),


                                  const SizedBox(height: 8),

                                  //AÑADIR MÁS OPCIONES
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                    weight: 700.0,),
                                    color: Color(0xFF098238),
                                    iconSize: 30,
                                    onPressed: () async{
                                      Navigator.pushNamed(context, 'createOption');
                                    },
                                  ),                              
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: web ? screenHeight * 0.02 : screenHeight * 0.02),

                    // BOTÓN ABRIR VOTACIONES
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
                        // Navigator.pushNamed(context, 'register');
                      },
                      child: Text(context.lang.abrir_opciones,
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
                      onTap: () => _pickDateTime(false),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black, 
                      ),
                      validator: (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                      decoration: InputDecoration(
                        hintText: context.lang.fecha_final_votacion,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                        ),
                        prefixIcon: const Icon(Icons.calendar_today, size: 18, color:Colors.black),
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
                              //TODO ELIMINAR DECISION
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
                                        // Tu lógica de guardado aquí
                                        if (!context.mounted) return;
                                        //TODO ACTUALIZAR DECISION

                                        //// NOTA: Cuando guardes en la base de datos, usa:
                                        // _selectedDateTimeOption e _selectedDateTimeVote 
                                        // que son objetos DateTime reales y limpios.
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