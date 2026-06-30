import 'package:dego/models/movie_serie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/watch_decision_session_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

// Estructura simple para pasar dos parámetros al .family
class WatchDecisionListProvider {
  final List<int> ids;
  final bool isMovie;
  
  WatchDecisionListProvider(this.ids, this.isMovie);

  // Sobreescribimos la igualdad para que Riverpod compare el contenido, no la memoria
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchDecisionListProvider &&
          runtimeType == other.runtimeType &&
          // Comparamos si las listas tienen los mismos elementos
          const ListEquality().equals(ids, other.ids) && 
          isMovie == other.isMovie;

  @override
  int get hashCode => Object.hash(Object.hashAll(ids), isMovie);

}

final watchDecisionListProvider = FutureProvider.family<List<MovieSerie>, WatchDecisionListProvider>((ref, record) async {
  final tmdbService = ref.read(tmdbServiceProvider);

  final List<dynamic> rawData = await tmdbService.getMultipleMedia(
    ids: record.ids, 
    isMovie: record.isMovie
  );

  final List<MovieSerie> resultado = rawData.map((item) {
    return MovieSerie.fromJson(item as Map<String, dynamic>);
  }).toList();

  return resultado;
});