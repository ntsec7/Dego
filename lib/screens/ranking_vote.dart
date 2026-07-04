import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/models/option.dart';

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

  // Lista local para manejar el ordenamiento por arrastre
  List<dynamic> _localOptions = []; 
  bool _initialized = false;

  // MÉTODO DE VALIDACIÓN
  String? _validarVotacion(int totalOptions) {
    if (_votos.length < totalOptions || _votos.values.any((v) => v == null)) {
      return context.lang.error_votar_ranking_no_ops;
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

    // Inicializamos nuestra lista local una sola vez al cargar
    if (!_initialized && options.isNotEmpty) {
      _localOptions = List.from(options);
      for (int i = 0; i < _localOptions.length; i++) {
        _votos[_localOptions[i].id] = i + 1; 
      }
      _initialized = true;
    }

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
                context.lang.votar_ranking,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: web ? (screenHeight + screenWidth) * 0.012 : (screenHeight + screenWidth) * 0.014,
                  color: Theme.of(context).textTheme.bodyLarge?.color, 
                ),
              ),

              SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),

              // BLOQUE DE OPCIONES REORDENABLES
              Expanded(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false, 
                  padding: EdgeInsets.all((screenHeight + screenWidth) * 0.01),
                  itemCount: _localOptions.length,
                  
                  // Con esto eliminamos el rectángulo extraño del fondo y las sombras por defecto
                  //Crea una copia flotante que sigue al dedo
                  proxyDecorator: (Widget child, int index, Animation<double> animation) {
                    return Material(
                      color: Colors.transparent, // Evita que se cree un fondo detrás de la tarjeta
                      child: child,
                    );
                  },
                  
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;  //-1 porque flutter devuelve una posición por debajo de donde se suelta
                      }

                      //Mover el elemento en tu lista de datos
                      final item = _localOptions.removeAt(oldIndex);
                      _localOptions.insert(newIndex, item);

                      // Sincronizamos las puntuaciones del mapa automáticamente
                      for (int i = 0; i < _localOptions.length; i++) {
                        _votos[_localOptions[i].id] = i + 1;
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    final option = _localOptions[index];
                    final currentPosition = _votos[option.id] ?? (index + 1);

                    return ReorderableDragStartListener(  //para poder arrastrar elementos
                      key: ValueKey(option.id),
                      index: index,
                      child: GestureDetector(
                        onTap: () {
                          if(option.type == OptionType.standard){
                            Navigator.pushNamed(context, 'seeOption', arguments: option.id);
                          } else {
                            Navigator.pushNamed(context, 'seeMediaOption', arguments: {
                              'id': decision.id,
                              'optionId': option.id,
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                          padding: EdgeInsets.only(
                            left: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                            right: 24.0,
                          ),
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
                                    fontSize: web
                                        ? (screenHeight + screenWidth) * 0.007
                                        : (screenHeight + screenWidth) * 0.013,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                                shape: BoxShape.circle,
                              ),
                              child:Text(
                                '$currentPosition',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.white,
                                  fontSize: 16
                                ),
                              ),
                            ),
                            ],
                          ),
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
                            final errorValidacion = _validarVotacion(_localOptions.length);
                            
                            if (errorValidacion != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorValidacion)),
                              );
                              return;
                            }

                            setState(() => _loading = true);
                            try {
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