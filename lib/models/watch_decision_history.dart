import 'package:dego/models/movie_serie.dart';

class HistoryArgs{
  final String decisionId;
  final bool isMovie;

  HistoryArgs({required this.decisionId, required this.isMovie});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryArgs &&
          runtimeType == other.runtimeType &&
          decisionId == other.decisionId &&
          isMovie == other.isMovie;

  @override
  int get hashCode => decisionId.hashCode ^ isMovie.hashCode;

}

class MediaWithVotes{
  final MovieSerie media;
  final int votes;

  MediaWithVotes({required this.media, required this.votes});
}