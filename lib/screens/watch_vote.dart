import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/watch_decision_session_provider.dart';

class WatchVote extends ConsumerWidget {
  final String id;

  const WatchVote({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(watchDecisionSessionProvider(id));

    // Si la lista esta vacia
    if (state.queue.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = state.currentMovie;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Watch Session"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

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
    );
  }
}





//https://image.tmdb.org/t/p/w500/i89vUDwNhAEWUZSFYITSiv1RIbK.jpg.