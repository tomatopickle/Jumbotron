class Movie {
  final int id;
  final String runtime;
  final double vote_average;
  final String poster_path;
  final String backdrop_path;
  final String title;
  final String release_date;
  final String overview;
  final String tagline;
  final List genres;

  const Movie({
    required this.title,
    required this.id,
    required this.poster_path,
    required this.backdrop_path,
    required this.release_date,
    required this.overview,
    required this.vote_average,
    required this.runtime,
    required this.tagline,
    required this.genres,
  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Format is y/m/d
    List<String> dateSplit = json['release_date'].split('-');
    return Movie(
        poster_path: json['poster_path'] ?? '',
        backdrop_path: json['backdrop_path'] ?? '',
        id: json['id'],
        title: json['title'],
        tagline: json['tagline'] ?? '',
        runtime: convert(json['runtime'] ?? 0),
        genres: json['genres'] ?? [],
        release_date: '${dateSplit[2]}/${dateSplit[1]}/${dateSplit[0]}',
        overview: json['overview'],
        vote_average: json['vote_average'].toDouble());
  }
}

String convert(int minutes) {
  print(minutes);
  var duration = Duration(minutes: minutes);
  return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
}
