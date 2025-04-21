import 'package:cinemania/infrastructure/models/moviedb/tvshow_moviedb.dart';

class TvShowResponse {
    final int page;
    final List<TVShowDB> results;
    final int totalPages;
    final int totalResults;

    TvShowResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory TvShowResponse.fromJson(Map<String, dynamic> json) => TvShowResponse(
        page: json["page"],
        results: List<TVShowDB>.from(json["results"].map((x) => TVShowDB.fromJson(x))),
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