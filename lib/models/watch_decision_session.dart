import 'package:dego/models/movie_serie.dart';

class WatchDecisionSessionState {
  final List<MovieSerie> queue;
  final int currentIndex;
  final int currentPage;
  final bool isLoadingMore;
  final String path;
  final bool isInitialLoaded;

  WatchDecisionSessionState({
    required this.queue,
    required this.currentIndex,
    required this.currentPage,
    this.isLoadingMore = false,
    required this.path,
    required this.isInitialLoaded,
  });

  MovieSerie get currentMovie => queue[currentIndex];

  bool get hasNext => currentIndex + 1 < queue.length;

  WatchDecisionSessionState copyWith({
    List<MovieSerie>? queue,
    int? currentIndex,
    int? currentPage,
    bool? isLoadingMore,
    String? path,
    bool? isInitialLoaded,
  }) {
    return WatchDecisionSessionState(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      path: path ?? this.path,
      isInitialLoaded: isInitialLoaded ?? this.isInitialLoaded,
    );
  }
}