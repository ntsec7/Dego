import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/watch_decision_provider.dart';
import 'package:dego/providers/decision_provider.dart';

class GroupHistory extends ConsumerStatefulWidget {

  const GroupHistory({super.key});

  @override
  ConsumerState<GroupHistory> createState() => _GroupHistory();
}

class _GroupHistory extends ConsumerState<GroupHistory> {

 @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    final grupo = ref.watch(currentGroupProvider);
    final finishDecisions = ref.watch(finishDecisionsProvider);
    final watchDecisions = ref.watch(finishWatchDecisionsProvider);

    if (grupo == null) {
      return Scaffold(
        body: Center(child: Text(context.lang.error_carga_grupo)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            //HISTORIAL
            Padding(
              padding: EdgeInsets.only(
                left: web ? screenWidth * 0.01 : screenWidth * 0.03,
                right: web ? screenWidth * 0.01 : screenWidth * 0.03,
                top: web ? screenHeight * 0.015 : screenHeight * 0.02,
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                    child: Text(
                      "${context.lang.historial}:",
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) * 0.009 : (screenHeight + screenWidth) * 0.015,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                ),
              ),

            // LISTA DE VOTOS
            Expanded(
              child: CustomScrollView(
                slivers: [
                  
                  finishDecisions.when(
                    data: (Decs) {
                      if (Decs.isEmpty) {
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final dec = Decs[index];
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(context, 'groupHistoryDecision', arguments: dec.id),
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
                                          dec.title,
                                          style: TextStyle(
                                            fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: Decs.length,
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
                                  Navigator.pushNamed(context, 'groupHistoryWatchDecision', arguments: watchDec.id);
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
          ],
        ),
      ),
    );
}
}