import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/watch_decision_session.dart';
import 'package:dego/services/tmdb_service.dart';

final tmdbServiceProvider = Provider<TmdbService>((ref) {
  return TmdbService();
});

// Definimos el provider de la sesión
final watchDecisionSessionProvider = StateNotifierProvider.family<WatchDecisionSessionNotifier, WatchDecisionSessionState, String>((ref, decisionId) {
  
  final tmdbService = ref.read(tmdbServiceProvider);

  return WatchDecisionSessionNotifier(
    decisionId: decisionId,
    tmdbService: tmdbService,
  );

});

class WatchDecisionSessionNotifier extends StateNotifier<WatchDecisionSessionState> {
  
  final String decisionId;
  final TmdbService _tmdbService;
  
  WatchDecisionSessionNotifier({required this.decisionId, required TmdbService tmdbService,
  }) : _tmdbService = tmdbService,
      super(
          WatchDecisionSessionState(
            queue: [],
            currentIndex: 0,
            currentPage: 1,
            path: "",
          ),
        ) {
    _init();
  }
  
  // Carga inicial leyendo supabase
   Future<void> _init() async {
    //TODO CARGAR SUPABASE
    final savedPage = 1;
    final savedIndex = 0;
    final savedPath = "/discover/movie?sort_by=popularity.desc";

    state = state.copyWith(
      currentPage: savedPage,
      currentIndex: savedIndex,
      path: savedPath,
    );

    await _loadPage(savedPage);
  }

  Future<void> _loadPage(int page) async {
    if (state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final newData = await _tmdbService.getDiscover( path: state.path, page: page);

      state = state.copyWith(
        queue: [...state.queue, ...newData],
        isLoadingMore: false,
        currentPage: page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void next() {
    if (!state.hasNext) return;

    final newIndex = state.currentIndex + 1;

    state = state.copyWith(currentIndex: newIndex);

    // para que el usuario no experimente carga
    if (!state.isLoadingMore && state.queue.length - newIndex < 5) {
      _loadPage(state.currentPage);
    }
  }


}