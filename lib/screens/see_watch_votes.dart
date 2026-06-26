import 'package:dego/models/decision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/watch_decision_provider.dart';

class SeeWatchVotes extends ConsumerStatefulWidget {
  final String id;

  const SeeWatchVotes({super.key, required this.id});

  @override
  ConsumerState<SeeWatchVotes> createState() => _SeeWatchVotes();
}

class _SeeWatchVotes extends ConsumerState<SeeWatchVotes> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600 ? true : false;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 1. Escuchamos la decisión
    final decisionAsync = ref.watch(watchDecisionByIdProvider(widget.id));

    return Scaffold(
      body: SafeArea(
        // Manejamos el flujo de la decisión de forma segura
        child: decisionAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator(radius: 15)),
          error: (err, stack) => Center(child: Text('Error al cargar decisión: $err')),
          data: (decision) {
            // 2. Solo cuando la decisión existe, escuchamos los votos de forma segura
            final votesAsync = ref.watch(voteCountProvider(decision.id));

            return votesAsync.when(
              loading: () => const Center(child: CupertinoActivityIndicator(radius: 15)),
              error: (err, stack) => Center(child: Text('Error al cargar votos: $err')),
              data: (counts) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text(counts.toString())),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}