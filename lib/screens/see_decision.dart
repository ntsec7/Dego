import 'package:dego/models/decision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/models/option.dart';
import 'package:dego/providers/usuario_provider.dart';

class SeeDecision extends ConsumerStatefulWidget {
  final String id;

  const SeeDecision({super.key, required this.id});

  @override
  ConsumerState<SeeDecision> createState() => _SeeDecision();
}

class _SeeDecision extends ConsumerState<SeeDecision> {
  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
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
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(translateSupabaseError(context, e))),
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

    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double labelWidth = web ? screenWidth * 0.15 : screenWidth * 0.35;

    final decisionAsync = ref.watch(decisionByIdProvider(widget.id));
    final optionsAsync = ref.watch(optionsByDecisionProvider(widget.id));
    final usuarioAsync = ref.watch(usuarioProvider);
    final currentUserId = usuarioAsync.value?.id;
    final currentUserType = usuarioAsync.value?.tipo;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (decisionAsync.isLoading || optionsAsync.isLoading) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator(radius: 15)));
    }

    final decision = decisionAsync.requireValue;
    final options = optionsAsync.requireValue;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            // FILA SUPERIOR: FLECHA VOLVER ATRÁS + TÍTULO DE LA DECISIÓN
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                horizontal: web ? screenWidth * 0.14 : screenWidth * 0.03,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Expanded(
                    child: Text(
                      decision.title,
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) * 0.014 : (screenHeight + screenWidth) * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: ladoIzquierdo, right: ladoDerecho, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.01),

                    // FILA: TIPO DE DECISIÓN
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text(
                            "${context.lang.tipo}:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Text(
                            decision.type.title(context),
                            style: TextStyle(
                              fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // FILA: FECHA FINAL VOTACIÓN
                    if(decision.vote_date!=null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text(
                            "${context.lang.fecha_final_votacion_min}:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Text(
                            formatDate(decision.vote_date!),
                            style: TextStyle(
                              fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // ETIQUETA SECCIÓN OPCIONES
                    Row(
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text(
                            "${context.lang.opciones}:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        const Expanded(child: SizedBox()),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    // BLOQUE DE OPCIONES
                    Container(
                      height: web ? screenHeight * 0.35 : screenHeight * 0.45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color.fromARGB(255, 143, 143, 143)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.01),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'seeOption', arguments: option.id);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                                    padding: EdgeInsets.symmetric(horizontal: web ? (screenHeight + screenWidth) * 0.003 : (screenHeight + screenWidth) * 0.008),

                                    constraints: BoxConstraints(
                                      minHeight: web ? screenHeight * 0.05 : 50.0, 
                                    ),

                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 224, 224, 224),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option.title,
                                            style: TextStyle(
                                              fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.013,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),

                                        if(decision.id_creator == currentUserId || option.id_creator==currentUserId || currentUserType=='admin') ...[
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: isDarkMode ? const Color.fromARGB(255, 145, 162, 169) : const Color.fromARGB(255, 95, 104, 108),
                                          onPressed: () => Navigator.pushNamed(context, 'editOption', arguments: option.id),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: const Color.fromARGB(255, 99, 99, 99),
                                          iconSize: web ? screenWidth * 0.015 : screenWidth * 0.06,
                                          onPressed: () {
                                            _deleteOption(context, option);
                                          },
                                        ),
                                        ],

                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // STICKY FOOTER DEL CUADRO DE OPCIONES
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              border: const Border(top: BorderSide(color: Color.fromARGB(255, 143, 143, 143))),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                
                                Visibility(
                                  visible: decision.options_date!=null, //si no está en options no es visible
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: labelWidth,
                                      child: Text(
                                        "${context.lang.fecha_final_opciones_min}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: Text(
                                        decision.options_date != null ? formatDate(decision.options_date!) : "",
                                        style: TextStyle(
                                          fontSize: web ? (screenHeight + screenWidth) * 0.011 : (screenHeight + screenWidth) * 0.013,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ),

                                const SizedBox(height: 4),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  color: const Color(0xFF098238),
                                  iconSize: 28,
                                  onPressed: () async {
                                    Navigator.pushNamed(context, 'createOption', arguments: decision.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}