import 'package:dego/models/option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/usuario_provider.dart';

class SimpleVote extends ConsumerStatefulWidget {
  final String id;

  const SimpleVote({super.key, required this.id});

  @override
  ConsumerState<SimpleVote> createState() => _SimpleVote();
}

class _SimpleVote extends ConsumerState<SimpleVote> {
  bool _loading = false;
  // Guardamos el ID de la opción seleccionada (será null al principio)
  String? _selectedOptionId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;

    final decisionAsync = ref.watch(decisionByIdProvider(widget.id));
    final optionsAsync = ref.watch(optionsByDecisionProvider(widget.id));
    final usuarioAsync = ref.watch(usuarioProvider);
    final currentUserId = usuarioAsync.value?.id;

    if (decisionAsync.isLoading || optionsAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CupertinoActivityIndicator(radius: 15)),
      );
    }

    final decision = decisionAsync.requireValue;
    final options = optionsAsync.requireValue;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: ladoIzquierdo, right: ladoDerecho, bottom: 20),
          child: Column(
            children: [
              // TÍTULO DE LA DECISIÓN
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                  horizontal: web ? screenWidth * 0.05 : screenWidth * 0.01,
                ),
                child: Row(
                  children: [
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: Text(
                        decision.title,
                        style: TextStyle(
                          fontSize: web
                              ? (screenHeight + screenWidth) * 0.014
                              : (screenHeight + screenWidth) * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // BLOQUE DE OPCIONES (Se expande para ocupar el espacio restante)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(
                    web
                        ? (screenHeight + screenWidth) * 0.01
                        : (screenHeight + screenWidth) * 0.01,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = _selectedOptionId == option.id;

                    return GestureDetector(
                      onTap: () {
                        // Al tocar la tarjeta, vamos a la información de la opción
                        if(option.type==OptionType.standard){
                          Navigator.pushNamed(context, 'seeOption', arguments: option.id);
                        }else{
                          Navigator.pushNamed(context, 'seeMediaOption', arguments: {
                            'id': decision.id,
                            'optionId': option.id,
                          },);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                        padding: EdgeInsets.only(
                          left: web
                              ? (screenHeight + screenWidth) * 0.01
                              : (screenHeight + screenWidth) * 0.015,
                          // Reducimos el padding derecho un poco para que el IconButton no quede muy lejos del borde
                          right: web ? 4.0 : 8.0, 
                        ),
                        constraints: BoxConstraints(
                          minHeight: web ? screenHeight * 0.05 : 50.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : const Color.fromARGB(255, 224, 224, 224),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: web
                                      ? (screenHeight + screenWidth) * 0.007
                                      : (screenHeight + screenWidth) * 0.013,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            
                            // ICONBUTTON EXCLUSIVO PARA LA SELECCIÓN
                            IconButton(
                              icon: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected ? const Color.fromARGB(255, 77, 77, 77) : Colors.black38,
                              ),
                              onPressed: () {
                                // Cambiamos la selección de voto solo al presionar este botón
                                setState(() {
                                  _selectedOptionId = option.id;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

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
                        fontSize: web
                            ? (screenHeight + screenWidth) * 0.01
                            : (screenHeight + screenWidth) * 0.015,
                      ),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.05),

                  // VOTAR
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            // Validación: Verificar que haya seleccionado una opción antes de votar
                            if (_selectedOptionId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.lang.error_votar_simple_no_ops),
                                ),
                              );
                              return;
                            }

                            setState(() => _loading = true);
                            try {

                              //Comprueba si ya ha votado en esta decision
                              final hasAlreadyVote = await ref.read(createProvider.notifier).hasAlreadyVote(id_decision:decision.id, id_user:currentUserId!);

                              if(hasAlreadyVote){
                                if(!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.lang.error_ya_votado),
                                  ),
                                );
                                setState(() => _loading = false);
                                return;
                              }

                              //Vota
                              await ref.read(createProvider.notifier).createSimpleVote(id_option: _selectedOptionId!, id_decision: decision.id, id_user: currentUserId);

                              if (!context.mounted) return;
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(translateSupabaseError(context, e))),
                              );
                            }
                            setState(() => _loading = false);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF098238),
                      foregroundColor: Colors.white,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            context.lang.votar,
                            style: TextStyle(
                              fontSize: web
                                  ? (screenHeight + screenWidth) * 0.01
                                  : (screenHeight + screenWidth) * 0.015,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}