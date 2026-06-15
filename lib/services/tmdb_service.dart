import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/movie_serie.dart';

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
}