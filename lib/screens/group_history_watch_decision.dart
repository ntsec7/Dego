import 'package:dego/models/watch_decision_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/watch_decision_provider.dart';

class GroupHistoryWatchDecision extends ConsumerStatefulWidget {
  final String id;

  const GroupHistoryWatchDecision({super.key, required this.id});

  @override
  ConsumerState<GroupHistoryWatchDecision> createState() => _GroupHistoryWatchDecision();
}

class _GroupHistoryWatchDecision extends ConsumerState<GroupHistoryWatchDecision> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600 ? true : false;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;


    final decisionAsync = ref.watch(watchDecisionByIdProvider(widget.id));

    return Scaffold(
      body: SafeArea(
        
        child: decisionAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator(radius: 15)),
          error: (err, stack) => Center(child: Text(context.lang.error_carga_decision)),
          data: (decision) {
            

            final listOptions = ref.watch(watchVoteListProvider(HistoryArgs(decisionId: decision.id, isMovie: decision.url.contains('movie') ) ));

            return listOptions.when(
              loading: () => const Center(child: CupertinoActivityIndicator(radius: 15)),
              error: (err, stack) => Center(child: Text(context.lang.error_carga_votos)),
              data: (options) {

            return SingleChildScrollView( 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  
                  for (var option in options) ...[
                    InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'groupHistoryWatchDecisionComplete', arguments: {
                      'id': decision.id,
                      'mediaId': option.media.id,
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Row(
                        children: [
                          
                          option.media.posterPath != null
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w92${option.media.posterPath}',
                                  width: 50,
                                )
                              : const Icon(Icons.movie, size: 50),
                          const SizedBox(width: 15),
                          
                          // Título de la peli/serie
                          Expanded(
                            child: Text(
                              option.media.title, 
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          
                          // Número de votos
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${option.votes}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    const Divider(), // Una línea divisoria entre peli y peli
                  ],
        ],
      ),
    );
  },
            );
          }
        ),
));
  }
}