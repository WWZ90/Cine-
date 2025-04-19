import 'package:cinemania/domain/entities/author_details.dart';

class ReviewsResponse {
    final int id;
    final int page;
    final List<ReviewsDB> results;
    final int totalPages;
    final int totalResults;

    ReviewsResponse({
        required this.id,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory ReviewsResponse.fromJson(Map<String, dynamic> json) => ReviewsResponse(
        id: json["id"],
        page: json["page"],
        results: List<ReviewsDB>.from(json["results"].map((x) => ReviewsDB.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class ReviewsDB {
    final String author;
    final AuthorDetails authorDetails;
    final String content;
    final DateTime createdAt;
    final String id;
    final DateTime updatedAt;
    final String url;

    ReviewsDB({
        required this.author,
        required this.authorDetails,
        required this.content,
        required this.createdAt,
        required this.id,
        required this.updatedAt,
        required this.url,
    });

    factory ReviewsDB.fromJson(Map<String, dynamic> json) => ReviewsDB(
        author: json["author"],
        authorDetails: AuthorDetails.fromJson(json["author_details"]),
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "author_details": authorDetails.toJson(),
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "updated_at": updatedAt.toIso8601String(),
        "url": url,
    };
}