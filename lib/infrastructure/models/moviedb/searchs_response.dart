import 'package:cinemania/domain/entities/known_for.dart';

class SearchResponse {
    final int page;
    final List<SearchDB> results;
    final int totalPages;
    final int totalResults;

    SearchResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        page: json["page"],
        results: List<SearchDB>.from(json["results"].map((x) => SearchDB.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class SearchDB {
    final int id;
    final String? name;
    final String? originalName;
    final String mediaType;
    final bool adult;
    final double popularity;
    final int? gender;
    final String? knownForDepartment;
    final dynamic profilePath;
    final List<KnownFor>? knownFor;
    final String? backdropPath;
    final String? overview;
    final String? posterPath;
    final String? originalLanguage;
    final List<int>? genreIds;
    final DateTime? firstAirDate;
    final double? voteAverage;
    final int? voteCount;
    final List<String>? originCountry;
    final String? title;
    final String? originalTitle;
    final DateTime? releaseDate;
    final bool? video;

    SearchDB({
        required this.id,
        this.name,
        this.originalName,
        required this.mediaType,
        required this.adult,
        required this.popularity,
        this.gender,
        this.knownForDepartment,
        this.profilePath,
        this.knownFor,
        this.backdropPath,
        this.overview,
        this.posterPath,
        this.originalLanguage,
        this.genreIds,
        this.firstAirDate,
        this.voteAverage,
        this.voteCount,
        this.originCountry,
        this.title,
        this.originalTitle,
        this.releaseDate,
        this.video,
    });

    factory SearchDB.fromJson(Map<String, dynamic> json) => SearchDB(
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        mediaType: json["media_type"],
        adult: json["adult"],
        popularity: json["popularity"]?.toDouble(),
        gender: json["gender"],
        knownForDepartment: json["known_for_department"],
        profilePath: json["profile_path"],
        knownFor: json["known_for"] == null ? [] : List<KnownFor>.from(json["known_for"]!.map((x) => KnownFor.fromJson(x))),
        backdropPath: json["backdrop_path"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        originalLanguage: json["original_language"],
        genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
        firstAirDate: (json["first_air_date"] == null || json["first_air_date"] == '') ? null : DateTime.parse(json["first_air_date"]),
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        originCountry: json["origin_country"] == null ? [] : List<String>.from(json["origin_country"]!.map((x) => x)),
        title: json["title"],
        originalTitle: json["original_title"],
        releaseDate: (json["release_date"] == null || json["release_date"] == '') ? null : DateTime.parse(json["release_date"]),
        video: json["video"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "original_name": originalName,
        "media_type": mediaType,
        "adult": adult,
        "popularity": popularity,
        "gender": gender,
        "known_for_department": knownForDepartment,
        "profile_path": profilePath,
        "known_for": knownFor == null ? [] : List<dynamic>.from(knownFor!.map((x) => x.toJson())),
        "backdrop_path": backdropPath,
        "overview": overview,
        "poster_path": posterPath,
        "original_language": originalLanguage,
        "genre_ids": genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
        "first_air_date": "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}",
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "origin_country": originCountry == null ? [] : List<dynamic>.from(originCountry!.map((x) => x)),
        "title": title,
        "original_title": originalTitle,
        "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "video": video,
    };
}

