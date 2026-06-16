import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/watch_decision_session_provider.dart';
import 'package:dego/providers/watch_decision_provider.dart';
import 'package:flutter/cupertino.dart';
class WatchVote extends ConsumerWidget {
  final String id;

  const WatchVote({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    final decisionAsync = ref.watch(watchDecisionByIdProvider(id));
    final state = ref.watch(watchDecisionSessionProvider(id));

    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;

    if (decisionAsync.isLoading ) {
      return const Scaffold(
        body: Center(child: CupertinoActivityIndicator(radius: 15)),
      );
    }

    final decision = decisionAsync.requireValue;

    // Si la lista esta vacia
    if (state.queue.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = state.currentMovie;

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

          // 🎬 TÍTULO
          Text(
            movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          // ▶ BOTÓN SIGUIENTE
          ElevatedButton(
            onPressed: () {
              ref
                  .read(watchDecisionSessionProvider(id).notifier)
                  .next();
            },
            child: const Text("Siguiente"),
          ),
        ],
      ),
        ),
      ),
    );
  }
}





//https://image.tmdb.org/t/p/w500/i89vUDwNhAEWUZSFYITSiv1RIbK.jpg.