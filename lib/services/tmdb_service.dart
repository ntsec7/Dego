import 'package:dego/models/movie_serie_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/movie_serie.dart';
import 'package:dego/models/option.dart';

class TmdbService {

  final supabase = Supabase.instance.client;

  Future<List<MovieSerie>> getDiscover({
    required String path,
    required int page,
  }) async {

    final res = await supabase.functions.invoke(
      'generate-watch-url',
      body: {
        'path': path,
        'page': page,
      },
    );

    final List data = res.data['results'];

    return data.map((json) => MovieSerie.fromJson(json)).toList();
  }

  Future<MovieSerieDetail> getDetail({
    required int id, 
    required bool isMovie
  }) async {
    try {
      // Invocamos la Edge Function
      final response = await supabase.functions.invoke(
        'get-movie-serie-detail',
        body: {
          'id': id,
          'isMovie': isMovie,
        },
      );

      if (response.status != 200) {
        throw Exception('Error al obtener detalles de TMDB');
      }

      final Map<String, dynamic> data = response.data;
      return MovieSerieDetail.fromJson(data);

    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  Future<List<dynamic>> getMultipleMedia({
    required List<int> ids, 
    required bool isMovie
  }) async {

    final String tipo = isMovie ? 'movie' : 'tv';
    
    final response = await supabase.functions.invoke(
      'get-multiple-media',
      body: {
        'ids': ids, 
        'tipo': tipo
      },
    );

    if (response.status != 200) throw Exception('Error al traer bloque de TMDB');
    // return response.data as Map<String, dynamic>;
    return response.data as List<dynamic>;
  }

  Future<MovieSerie?> getMediaByTitle({
    required String title,
    required OptionType type,
  }) async {
    final response = await supabase.functions.invoke(
      'get-media-by-title',
      body: {
        'title': title,
        'type': type.databaseValue,
      },
    );

    if (response.data == null) {
      return null;
    }

    return MovieSerie.fromJson(response.data);
  }

}