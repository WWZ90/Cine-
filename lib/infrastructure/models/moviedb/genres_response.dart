class GenreResponse {
    final List<GenreMovieDb> genres;

    GenreResponse({
        required this.genres,
    });

    factory GenreResponse.fromJson(Map<String, dynamic> json) => GenreResponse(
        genres: List<GenreMovieDb>.from(json["genres"].map((x) => GenreMovieDb.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    };
}

class GenreMovieDb {
    final int id;
    final String name;

    GenreMovieDb({
        required this.id,
        required this.name,
    });

    factory GenreMovieDb.fromJson(Map<String, dynamic> json) => GenreMovieDb(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
