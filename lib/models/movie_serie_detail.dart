import 'package:dego/models/movie_serie.dart';

class MovieSerieDetail {
  final int id;
  final String title;       
  final String tagline;
  final String releaseDate;
  final String? finishDate;
  final int? movieRuntime;
  final int? numberSeasons;
  final int? numberEpisodes;
  final List<int>? episodeRuntime; 
  final String? status;
  final List<String> actors;
  final List<String> directors;
  final List<String> scriptwriters;
  final List<String> platforms;
  final int? budget;
  final int? revenue;
  final List<String> productionCompanies;
  final String? trailer;
  final bool isMovie;
  final List<MovieSerie> similars;

  MovieSerieDetail({
    required this.id,
    required this.title,
    required this.tagline,
    required this.releaseDate,
    this.finishDate,
    this.movieRuntime,
    this.numberSeasons,
    this.numberEpisodes,
    this.episodeRuntime,
    this.status,
    required this.actors,
    required this.directors,
    required this.scriptwriters,
    required this.platforms,
    this.budget,
    this.revenue,
    required this.productionCompanies,
    this.trailer,
    required this.isMovie,
    required this.similars,
  });

  // Constructor inteligente
  factory MovieSerieDetail.fromJson(Map<String, dynamic> json) {

    // Si el JSON contiene 'title', es una película; de lo contrario, es una serie (tv)
    final isMovie = json.containsKey('title');

    //compañias productoras
    final companies = json['production_companies'] as List? ?? [];
    final List<String> parsedCompanies = companies
        .map((c) => c['name'] as String)
        .toList();

    final videos = json['videos']?['results'] as List? ?? [];
    String? bestTrailerKey;

    if (videos.isNotEmpty) {
      // Intentamos buscar uno que sea de YouTube, de tipo "Trailer" y que sea oficial
      final officialTrailer = videos.firstWhere(
        (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer' && v['official'] == true,
        orElse: () => null,
      );

      if (officialTrailer != null) {
        bestTrailerKey = officialTrailer['key'];
      } else {
        // Si no hay uno marcado como oficial, buscamos cualquier cosa que sea "Trailer"
        final anyTrailer = videos.firstWhere(
          (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
          orElse: () => null,
        );
        
        if (anyTrailer != null) {
          bestTrailerKey = anyTrailer['key'];
        } else {
          // Si no hay trailers, nos quedamos con el primer video disponible (puede ser un Teaser o Clip)
          final anyVideo = videos.firstWhere(
            (v) => v['site'] == 'YouTube',
            orElse: () => null,
          );
          bestTrailerKey = anyVideo?['key'];
        }
      }
    }    

    // Actores, Directores y Guionistas
    final castList = json['credits']?['cast'] as List? ?? [];
    final crewList = json['credits']?['crew'] as List? ?? [];

    final List<String> parsedActors = castList
        .take(15) // Tomamos los 15 primeros
        .map((actor) => actor['name'] as String)
        .toList();

    final List<String> parsedDirectors = [];
    final List<String> parsedScriptwriters = [];

    if (isMovie) {
      for (var person in crewList) {
        if (person['job'] == 'Director') parsedDirectors.add(person['name']);
        if (person['job'] == 'Screenplay' || person['job'] == 'Writer') {
          parsedScriptwriters.add(person['name']);
        }
      }
    } else {
      // En series los directores/creadores principales vienen en 'created_by'
      final createdBy = json['created_by'] as List? ?? [];
      for (var creator in createdBy) {
        parsedDirectors.add(creator['name']);
      }
      for (var person in crewList) {
        if (person['job'] == 'Writer' || person['job'] == 'Executive Producer') {
          parsedScriptwriters.add(person['name']);
        }
      }
    }

    //Plataformas de España (JustWatch)
    final providers = json['watch/providers']?['results']?['ES']?['flatrate'] as List? ?? [];
    final List<String> parsedPlatforms = providers
        .map((p) => p['provider_name'] as String)
        .toList();


    //Similares
    final recommendationsJson = json['recommendations']?['results'] as List? 
                             ?? json['similar']?['results'] as List? 
                             ?? [];
                             
    final List<MovieSerie> parsedSimilars = recommendationsJson
        .map((item) => MovieSerie.fromJson(item)) 
        .toList();

    
    return MovieSerieDetail(
      id: json['id'] ?? 0,
      title: isMovie ? (json['title'] ?? '') : (json['name'] ?? ''),
      tagline: json['tagline'] ?? '',
      releaseDate: isMovie ? (json['release_date'] ?? '') : (json['first_air_date'] ?? ''),
      finishDate: isMovie ? null : json['last_air_date'], 
      movieRuntime: isMovie ? json['runtime'] : null,
      numberSeasons: isMovie ? null : json['number_of_seasons'],
      numberEpisodes: isMovie ? null : json['number_of_episodes'],
      episodeRuntime: isMovie ? null : List<int>.from(json['episode_run_time']),
      status: json['status'],
      actors: parsedActors,
      directors: parsedDirectors,
      scriptwriters: parsedScriptwriters,
      platforms: parsedPlatforms,
      budget: isMovie ? json['budget'] : null,
      revenue: isMovie ? json['revenue'] : null,
      productionCompanies: parsedCompanies,
      trailer: bestTrailerKey,
      similars: parsedSimilars,
      isMovie: isMovie,
    );
  }
}