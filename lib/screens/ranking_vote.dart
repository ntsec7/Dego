import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/usuario_provider.dart';

class RankingVote extends ConsumerStatefulWidget {
  final String id;

  const RankingVote({super.key, required this.id});

  @override
  ConsumerState<RankingVote> createState() => _RankingVote();
}

class _RankingVote extends ConsumerState<RankingVote> {
  bool _loading = false;
  
  // Guardamos los votos de cada opción usando un Mapa: { optionId: numero }
  final Map<String, int?> _votos = {};

  // MÉTODO DE VALIDACIÓN
  // Comprueba que todas las opciones tengan un número, que estén en rango y que no se repitan.
  String? _validarVotacion(int totalOptions) {

    // 1. Verificar que todas las opciones tengan un voto asignado
    if (_votos.length < totalOptions || _votos.values.any((v) => v == null)) {
      return context.lang.error_votar_ranking_no_ops;
    }

    final valores = _votos.values.whereType<int>().toList();

    // 2. Verificar que estén dentro del rango prefijado [1,totalOptions]
    // for (var valor in valores) {
    //   if (valor < 1 || valor > totalOptions) {
    //     return 'Los números deben estar entre 1 y $totalOptions.';
    //   }
    // }

    // 3. Verificar que no haya números repetidos
    if (valores.toSet().length != valores.length) {
      return context.lang.error_votar_ranking_repe;
    }

    return null; // Todo correcto
  }

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

              SizedBox(height: web ? screenHeight * 0.02 : screenHeight * 0.02),

              // EXPLICACIÓN SOBRE COMO VOTAR
              Text(
                context.lang.votar_ranking(1, options.length),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                  color: Theme.of(context).textTheme.bodyLarge?.color, 
                ),
              ),

              SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),

              // BLOQUE DE OPCIONES
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all((screenHeight + screenWidth) * 0.01),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    
                    // Inicializamos el mapa si la opción no existe aún en él
                    if (!_votos.containsKey(option.id)) {
                      _votos[option.id] = null;
                    }

                    final currentVote = _votos[option.id];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'seeOption', arguments: option.id);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                        padding: EdgeInsets.only(
                          left: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                          right: 16.0, // Ajustamos el padding para el dropdown
                        ),
                        constraints: BoxConstraints(
                          minHeight: web ? screenHeight * 0.05 : 50.0,
                        ),
                        decoration: BoxDecoration(
                          // Cambiamos el color si el usuario ya le ha asignado una puntuación
                          color: currentVote != null
                              ? Theme.of(context).colorScheme.secondary
                              : const Color.fromARGB(255, 224, 224, 224),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: currentVote != null ? Theme.of(context).colorScheme.primary : Colors.transparent,
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
                            
                            // DROPDOWN PARA SELECCIONAR EL NÚMERO DE RANKING
                            DropdownButton<int>(
                              dropdownColor: const Color.fromARGB(255, 224, 224, 224),
                              value: currentVote,
                              hint: const Text("-", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                              underline: const SizedBox(), // Quitamos la línea de abajo
                              onChanged: (int? newValue) {
                                setState(() {
                                  _votos[option.id] = newValue;
                                });
                              },
                              // Generamos la lista de números disponibles del 1 al total de opciones
                              items: List.generate(options.length, (i) => i + 1)
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                );
                              }).toList(),
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

                            // Validar los votos
                            final errorValidacion = _validarVotacion(options.length);
                            
                            if (errorValidacion != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorValidacion)),
                              );
                              return;
                            }

                            setState(() => _loading = true);
                            try {
                              // Comprueba si ya ha votado en esta decision
                              final hasAlreadyVote = await ref.read(createProvider.notifier).hasAlreadyRankingVote(
                                id_decision: decision.id, 
                                id_user: currentUserId!
                              );

                              if (hasAlreadyVote) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(context.lang.error_ya_votado)),
                                );
                                setState(() => _loading = false);
                                return;
                              }

                              // Vota: Bucle que envía las votaciones de todas las opciones
                              for (var entry in _votos.entries) {
                                final optionId = entry.key;
                                final points = entry.value!; 
                                
                                await ref.read(createProvider.notifier).createRankingVote(
                                  id_option: optionId, 
                                  id_decision: decision.id, 
                                  id_user: currentUserId,
                                  number: points,
                                );
                              }

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