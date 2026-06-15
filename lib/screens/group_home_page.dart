import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:dego/providers/watch_decision_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/models/decision.dart';

class GroupHomePage extends ConsumerStatefulWidget {
  const GroupHomePage({super.key});

  @override
  ConsumerState<GroupHomePage> createState() => _GroupHomePage();
}

class _GroupHomePage extends ConsumerState<GroupHomePage> {
  void _deleteDecision(BuildContext context, Decision dec) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(context.lang.eliminar_decision),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.lang.eliminar_decision_txt(dec.title),
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
                      await ref.read(createProvider.notifier).deleteDecision(decisionId: dec.id);

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.lang.exito_eliminar_decision),
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final grupo = ref.watch(currentGroupProvider);
    final optionDecisions = ref.watch(optionDecisionsProvider);
    final voteDecisions = ref.watch(voteDecisionsProvider);
    final watchDecisions = ref.watch(voteWatchDecisionsProvider);

    final usuarioAsync = ref.watch(usuarioProvider);
    final currentUserId = usuarioAsync.value?.id;
    final currentUserType = usuarioAsync.value?.tipo;

    if (grupo == null) {
      return Scaffold(
        body: Center(child: Text(context.lang.error_carga_grupo)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            //VOTAR
            Padding(
              padding: EdgeInsets.only(
                left: web ? screenWidth * 0.01 : screenWidth * 0.03,
                right: web ? screenWidth * 0.01 : screenWidth * 0.03,
                top: web ? screenHeight * 0.015 : screenHeight * 0.02,
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "${context.lang.votar}:",
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) * 0.009 : (screenHeight + screenWidth) * 0.015,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(width: web ? screenWidth * 0.007 : screenWidth * 0.02),
                    Icon(
                      Icons.how_to_vote_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            // LISTA DE VOTOS
            Expanded(
              child: CustomScrollView(
                slivers: [
                  
                  voteDecisions.when(
                    data: (voteDec) {
                      if (voteDec.isEmpty) {
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final votDec = voteDec[index];
                              return GestureDetector(
                                onTap: () {
                                  switch (votDec.type) {
                                    case DecisionType.simple:
                                      Navigator.pushNamed(context, 'simpleVote', arguments: votDec.id);
                                      break;
                                    case DecisionType.ranking:
                                      Navigator.pushNamed(context, 'rankingVote', arguments: votDec.id);
                                      break;
                                    case DecisionType.roulette:
                                      Navigator.pushNamed(context, 'rouletteVote', arguments: votDec.id);
                                      break;
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                                  padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.008 : (screenHeight + screenWidth) * 0.01),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 224, 224, 224),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          votDec.title,
                                          style: TextStyle(
                                            fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (votDec.id_creator == currentUserId || currentUserType == 'admin') ...[
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: isDarkMode ? const Color.fromARGB(255, 145, 162, 169) : const Color.fromARGB(255, 95, 104, 108),
                                          onPressed: () => Navigator.pushNamed(context, 'editDecision', arguments: votDec.id),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.redAccent,
                                          onPressed: () => _deleteDecision(context, votDec),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: voteDec.length,
                          ),
                        ),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                    ),
                    error: (e, st) => SliverToBoxAdapter(
                      child: Center(child: Text("Error en Votos: $e")),
                    ),
                  ),

                  watchDecisions.when(
                    data: (watchDecs) {
                      if (watchDecs.isEmpty) {
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final watchDec = watchDecs[index];
                              return GestureDetector(
                                onTap: () {
                                  // Acción al pulsar una watchDecision
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                                  padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.008 : (screenHeight + screenWidth) * 0.01),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 224, 224, 224),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          watchDec.title,
                                          style: TextStyle(
                                            fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                        IconButton(
                                          icon: const Icon(Icons.visibility),
                                          color: isDarkMode ? const Color.fromARGB(255, 145, 162, 169) : const Color.fromARGB(255, 95, 104, 108),
                                          onPressed: () => null,  //TODO VER PELIS VOTADAS
                                        ),
                                      if (watchDec.id_creator == currentUserId || currentUserType == 'admin') ...[
                                        IconButton(
                                          icon: const Icon(Icons.hourglass_empty_rounded),
                                          color: isDarkMode ? const Color.fromARGB(255, 145, 162, 169) : const Color.fromARGB(255, 95, 104, 108),
                                          onPressed: () => null,  //TODO _finishWatchDecision(context,watchDec.id)
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            // _deleteWatchDecision(context, watchDec); //TODO DELETE DECISION
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: watchDecs.length,
                          ),
                        ),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                    ),
                    error: (e, st) => SliverToBoxAdapter(
                      child: Center(child: Text("Error en Visualizaciones: $e")),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: web ? screenHeight * 0.02 : screenHeight * 0.015),

            // DAR OPCIONES 
            Padding(
              padding: EdgeInsets.only(
                left: web ? screenWidth * 0.01 : screenWidth * 0.03,
                right: web ? screenWidth * 0.01 : screenWidth * 0.03,
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "${context.lang.dar_opciones}:",
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) * 0.009 : (screenHeight + screenWidth) * 0.015,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(width: web ? screenWidth * 0.003 : screenWidth * 0.01),
                    const Icon(
                      Icons.emoji_objects,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),

            // LISTA DE OPCIONES 
            Expanded(
              child: optionDecisions.when(
                data: (optionsDec) {
                  if (optionsDec.isEmpty) return const Center(child: Text(""));

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                    ),
                    itemCount: optionsDec.length,
                    itemBuilder: (context, index) {
                      final opDec = optionsDec[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'seeDecision', arguments: opDec.id);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: web ? screenHeight * 0.015 : screenHeight * 0.015),
                          padding: EdgeInsets.all(web ? (screenHeight + screenWidth) * 0.008 : (screenHeight + screenWidth) * 0.01),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 224, 224, 224),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opDec.title,
                                  style: TextStyle(
                                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              if (opDec.id_creator == currentUserId || currentUserType == 'admin') ...[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: isDarkMode ? const Color.fromARGB(255, 145, 162, 169) : const Color.fromARGB(255, 95, 104, 108),
                                  onPressed: () => Navigator.pushNamed(context, 'editDecision', arguments: opDec.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    _deleteDecision(context, opDec);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text("Error: $e")),
              ),
            ),

            // FOOTER ACCIONES 
            Padding(
              padding: EdgeInsets.only(
                top: web ? 16.0 : 10.0,
                bottom: web ? 24.0 : 16.0, // Asegura separación limpia respecto al fondo físico de la pantalla
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // NUEVA DECISIÓN DE CINE/SERIES
                  Container(
                    width: web ? screenWidth * 0.04 : screenWidth * 0.15,
                    height: web ? screenWidth * 0.04 : screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, 'createDecisionWatch');
                      },
                      child: FractionallySizedBox(
                        widthFactor: 0.95,
                        child: Image.asset(
                          'assets/images/popcorn_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: web ? screenWidth * 0.06 : screenWidth * 0.07),

                  // NUEVA DECISIÓN GENERAL
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      weight: 900.0,
                    ),
                    color: const Color(0xFF098238),
                    iconSize: web ? screenWidth * 0.03 : screenWidth * 0.15,
                    onPressed: () async {
                      Navigator.pushNamed(context, 'createDecision');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}