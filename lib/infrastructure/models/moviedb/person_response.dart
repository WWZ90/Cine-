import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';

class PersonResponse {
    final int page;
    final List<PersonMoviedb> results;
    final int totalPages;
    final int totalResults;

    PersonResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory PersonResponse.fromJson(Map<String, dynamic> json) => PersonResponse(
        page: json["page"],
        results: List<PersonMoviedb>.from(json["results"].map((x) => PersonMoviedb.fromJson(x))),
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

