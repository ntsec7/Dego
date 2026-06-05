import 'package:dego/models/decision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/models/option.dart';

class EditDecision extends ConsumerStatefulWidget {

  final String id;

  const EditDecision({super.key, required this.id});

  @override
  ConsumerState<EditDecision> createState() => _EditDecision();
}

class _EditDecision extends ConsumerState<EditDecision> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _dateControllerOption = TextEditingController(); // Controlador para la fecha
  final TextEditingController _dateControllerVote = TextEditingController(); // Controlador para la fecha
  DecisionType _selectedType = DecisionType.simple;

  bool _isInitialized = false;
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _dateControllerOption.dispose();
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
  Future<void> _pickDateTime(bool isOptionDate, Decision decision) async {
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

  //Comprobar que optionsDate < voteDate
  bool dateError = false;

  if(isOptionDate && decision.vote_date!=null){
    if (finalDateTime.isAfter(decision.vote_date!) || finalDateTime.isAtSameMomentAs(decision.vote_date!)) {
      dateError = true;
    }
  } else if(!isOptionDate && decision.options_date!=null){
    if (decision.options_date!.isAfter(finalDateTime) || decision.options_date!.isAtSameMomentAs(finalDateTime)) {
      dateError = true;
    }
  }

  if(dateError){
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.lang.error_tiempos),
          // backgroundColor: Colors.redAccent,
        ),
      );

      return; 
  }

    // Formato: DD-MM-AAAA HH:MM
    final formattedText = formatDate(finalDateTime);

    setState(() {
      if (isOptionDate) {
        _dateControllerOption.text = formattedText;
        decision.options_date=finalDateTime;

      } else {
        _dateControllerVote.text = formattedText;
        decision.vote_date=finalDateTime;
      }
    });

  }

  
  void _deleteOption(BuildContext context, Option op) {

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
          return AlertDialog(
          title: Text(context.lang.eliminar_opcion),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.lang.eliminar_opcion_txt(op.title),
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
                
                try {

                  await ref.read(createProvider.notifier).deleteOption(optionId: op.id);

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.lang.exito_eliminar_opcion),
                      ),
                    );
                  }
                } catch (e) {
                  if(context.mounted){
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateSupabaseError(context,e))),
                    );
                  }
                }
              },
              child: Text(context.lang.aceptar),
            ),
          ],
          );
          },
        );
      },
    );
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


    final decisionAsync = ref.watch(decisionByIdProvider(widget.id));
    final optionsAsync = ref.watch(optionsByDecisionProvider(widget.id));

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if(decisionAsync.isLoading || optionsAsync.isLoading){
      return const Scaffold(body: Center(child: CupertinoActivityIndicator(radius: 15)));
    }


    final decision = decisionAsync.requireValue;
    final options = optionsAsync.requireValue;

    if (!_isInitialized) {
      _title.text = decision.title;
      _selectedType = decision.type;
      _dateControllerOption.text = decision.options_date != null ? formatDate(decision.options_date!) : "";
      _dateControllerVote.text = decision.vote_date != null ? formatDate(decision.vote_date!) : "";
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
                              onChanged: (value) => decision.title=value,
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
                                  decision.type= newValue;
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
                              child: ListView.builder(
                                    padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01), // Espaciado alrededor de la lista
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, 'createOption', arguments: index); //TODO LLEVAR A VER OPCIÓN
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: web ? screenHeight * 0.02 : screenHeight * 0.02), // Separación entre cuadros
                                          padding: EdgeInsets.symmetric( horizontal: web ? (screenHeight + screenWidth) * 0.003 : (screenHeight + screenWidth) * 0.008),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 224, 224, 224), 
                                            borderRadius: BorderRadius.circular(30), // Bordes redondeados
                                          ),
                                          child: Row(
                                            children: [                                              
                                              //TITULO
                                              Expanded(
                                                child: Text(
                                                  option.title,
                                                  style:  TextStyle(
                                                    fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.013,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              
                                              //EDITAR
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                color: isDarkMode ? Color.fromARGB(255, 145, 162, 169) : Color.fromARGB(255, 95, 104, 108),
                                                onPressed: () => Navigator.pushNamed(context, 'editOption', arguments: option.id), //TODO EDITAR OPCION
                                              ),

                                              //ELIMINAR
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                color:  const Color.fromARGB(255, 99, 99, 99),
                                                iconSize: web ? screenWidth * 0.015 : screenWidth * 0.06,
                                                onPressed: () {
                                                  _deleteOption(context, option);
                                                },
                                              ),

                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),

                            // STICKY FOOTER (Fijo abajo del rectángulo)
                            Container(
                              decoration: BoxDecoration(
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
                                    onTap: () => _pickDateTime(true, decision),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black, 
                                    ),
                                    //validator: (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                                    decoration: InputDecoration(
                                      hintText: context.lang.fecha_final_opciones,
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
                                              _dateControllerOption.clear(); // Borra el texto del input
                                              decision.options_date=null;
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


                                  const SizedBox(height: 8),

                                  //AÑADIR MÁS OPCIONES
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                    weight: 700.0,),
                                    color: Color(0xFF098238),
                                    iconSize: 30,
                                    onPressed: () async{
                                      Navigator.pushNamed(context, 'createOption'); //TODO CAMBIAR EL CREAR OPCIÓN
                                    },
                                  ),                              
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: web ? screenHeight * 0.02 : screenHeight * 0.02),

                    // BOTÓN EMPEZAR VOTACIÓN
                    //TODO CAMBIAR A EMPEZAR VOTACIÓN
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
                        //Crear la decisión
                        // await ref.read(createProvider.notifier).EditDecision(id_creator: currentUserId!, id_group: currentGroupId, state: DecisionState.options, decision: draft);

                        if(!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.lang.exito_crear_decision)),
                        );

                        Navigator.pop(context);

                      },
                      child: Text(context.lang.empezar_votacion,
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
                      onTap: () => _pickDateTime(false, decision),
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
                                decision.vote_date=null;
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

                                        //Tiene que tener al menos 2 opciones para empezar la votación
                                        if(options.length<2 && decision.state==DecisionState.vote){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(context.lang.error_num_opciones),
                                            ),
                                          );
                                          _loading=false;
                                          return;
                                        }

                                        //Actualizar la decisión
                                        await ref.read(createProvider.notifier).editDecision(decision: decision);
                                        
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