import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/watch_decision_session.dart';
import 'package:dego/services/tmdb_service.dart';
import 'package:dego/services/watch_decision_service.dart';

final tmdbServiceProvider = Provider<TmdbService>((ref) {
  return TmdbService();
});

final watchDecisionServiceProvider = Provider<WatchDecisionService>((ref){
  return WatchDecisionService();
});

// Definimos el provider de la sesión
final watchDecisionSessionProvider = StateNotifierProvider.family<WatchDecisionSessionNotifier, WatchDecisionSessionState, String>((ref, decisionId) {
  
  final tmdbService = ref.read(tmdbServiceProvider);
  final service = ref.read(watchDecisionServiceProvider);

  return WatchDecisionSessionNotifier(
    decisionId: decisionId,
    tmdbService: tmdbService,
    service: service,
  );

});

class WatchDecisionSessionNotifier extends StateNotifier<WatchDecisionSessionState> {
  
  final String decisionId;
  final TmdbService _tmdbService;
  final WatchDecisionService service;
  
  WatchDecisionSessionNotifier({required this.decisionId, required TmdbService tmdbService, required this.service,
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

    final decision = await service.getWatchDecision(decisionId);
    final position = await service.getWatchPosition(decisionId);

    final savedPage = position.page;
    final lastId= position.last_id;
    final savedPath = decision.url;

    state = state.copyWith(
      currentPage: savedPage,
      path: savedPath,
    );

    await _loadPage(savedPage);

    _restoreIndex(lastId);
  }

  void _restoreIndex(int lastId) {
    final index = state.queue.indexWhere(
      (data) => data.id == lastId,
    );

    if (index == -1) return;

    state = state.copyWith(currentIndex: index);
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