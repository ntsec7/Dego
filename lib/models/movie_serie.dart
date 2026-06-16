class MovieSerie {
  final int id;
  final String title;       
  final String synopsis;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate; 
  final double voteAverage;
  final List<int> genreIds; 
  final int voteCount; 

  MovieSerie({
    required this.id,
    required this.title,
    required this.synopsis,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
    required this.voteCount,
  });

  // Getter para la URL de la imagen
  String get fullPosterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';

  // Constructor inteligente
  factory MovieSerie.fromJson(Map<String, dynamic> json) {

    // Si el JSON contiene 'title', es una película; de lo contrario, es una serie (tv)
    final isMovie = json.containsKey('title');

    return MovieSerie(
      id: json['id'] ?? 0,
      title: isMovie 
          ? (json['title'] ?? '') 
          : (json['name'] ?? ''),
      synopsis: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: isMovie 
          ? (json['release_date'] ?? '') 
          : (json['first_air_date'] ?? ''),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      voteCount: json['voteCount'] ?? '',
    );
  }
}