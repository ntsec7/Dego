import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/watch_decision_session.dart';
import 'package:dego/services/tmdb_service.dart';
import 'package:dego/services/watch_decision_service.dart';
import 'package:dego/providers/usuario_provider.dart';

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

  final currentUserId = ref.watch(usuarioProvider).value?.id ?? '';

  return WatchDecisionSessionNotifier(
    decisionId: decisionId,
    userId: currentUserId,
    tmdbService: tmdbService,
    service: service,
  );

});

class WatchDecisionSessionNotifier extends StateNotifier<WatchDecisionSessionState> {
  
  final String decisionId;
  final String userId;
  final TmdbService _tmdbService;
  final WatchDecisionService service;
  dynamic _position;   //propiedad de la clase para poder usarla en todo el archivo
  dynamic _decision;
  
  WatchDecisionSessionNotifier({required this.decisionId, required this.userId, required TmdbService tmdbService, required this.service,
  }) : _tmdbService = tmdbService,
      super(
          WatchDecisionSessionState(
            queue: [],
            currentIndex: 0,
            currentPage: 1,
            path: "",
            isInitialLoaded: false,
            resSeen: 0,
          ),
        ) {
    _init();
  }
  
  // Carga inicial leyendo supabase
   Future<void> _init() async {
    if (userId.isEmpty) return;

    _decision = await service.getWatchDecision(decisionId);
    _position = await service.getWatchPosition(decisionId, userId);
    if(_position.finish==true){ //que no vuelva a cargar si ya no quedan opciones por votar
      state = state.copyWith(isInitialLoaded: true);
      return;
    }

    final savedPage = _position.page;
    final lastId= _position.last_id;
    final savedPath = _decision.url;

      state = state.copyWith(
      currentPage: savedPage,
      path: savedPath,
    );

    await _loadPage(savedPage);

    final index= _restoreIndex(lastId);

    state = state.copyWith(isInitialLoaded: true);

    final savedResSeen = (savedPage-1) * 20 + index;

    state = state.copyWith(
      resSeen: savedResSeen,
    );

    //Si no hay datos
    if (!state.hasNext || state.resSeen>=(_decision.res_limit ?? double.infinity)){ //Termina la votación del usuario
      if(_position.finish==false){ 
        _position.finish=true;
        try {
          await service.updateWatchDecisionPosition(position: _position);
        } catch (e) {
          rethrow;
        }
      } 
      return;
    } 
  }

  int _restoreIndex(int lastId) {
    final index = state.queue.indexWhere(
      (data) => data.id == lastId,
    );

    if (index == -1) return 0;

    state = state.copyWith(currentIndex: index);

    return index;
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

  void next() async{

    final nextResSeen = state.resSeen + 1;

    if (!state.hasNext || nextResSeen>=(_decision.res_limit ?? double.infinity)){ //Termina la votación del usuario
      if(_position.finish==false){ 
        state = state.copyWith(resSeen: nextResSeen, queue: []);  //vaciamos la cola para que salga la pantalla de que no quedan más opciones
        _position.finish=true;
        try {
          await service.updateWatchDecisionPosition(position: _position);
        } catch (e) {
          rethrow;
        }
      } 
      return;
    } 

    final newIndex = state.currentIndex + 1;

    //Actualizar ultima peli y página en Supabase
    final nextMovie = state.queue[newIndex];
    final nextMovieId = nextMovie.id;
  
    //calculamos la pagina
    final moviePage = (newIndex ~/ 20) + 1; 

    _position.last_id=nextMovieId;
    _position.page=moviePage;

    try {
      await service.updateWatchDecisionPosition(position: _position);
    } catch (e) {
      rethrow;
    }

    state = state.copyWith(currentIndex: newIndex, resSeen: nextResSeen);

    // para que el usuario no experimente carga
    if (!state.isLoadingMore && state.queue.length - newIndex < 5) {
      _loadPage(state.currentPage);
    }
  }

  Future<void> watchVote() async{
    try{

      if (state.queue.isEmpty || state.currentIndex >= state.queue.length || userId.isEmpty) return;

      final movieId= state.queue[state.currentIndex].id;

      await service.watchVote(decisionId: decisionId, userId: userId, optionId: movieId);
      
    } catch (e){
      rethrow;
    }
  }

}