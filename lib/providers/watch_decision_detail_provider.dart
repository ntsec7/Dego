import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/movie_serie_detail.dart';
import 'package:dego/providers/watch_decision_session_provider.dart';

// Estructura simple para pasar dos parámetros al .family
class WatchDecisionDetail {
  final int id;
  final bool isMovie;
  
  WatchDecisionDetail(this.id, this.isMovie);

  //Para evitar bucles infinitos de llamadas a las edge-function
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchDecisionDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isMovie == other.isMovie;

  @override
  int get hashCode => id.hashCode ^ isMovie.hashCode;

}

final  watchDecisionDetailProvider = FutureProvider.family<MovieSerieDetail,  WatchDecisionDetail>((ref, record) async {

  final tmdbService = ref.read(tmdbServiceProvider);

  return await tmdbService.getDetail(id: record.id, isMovie: record.isMovie);
});