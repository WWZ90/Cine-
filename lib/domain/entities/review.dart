import 'package:cinemania/domain/entities/author_details.dart';

class Review {
  final String id;
  final String author;
  final AuthorDetails authorDetails;
  final String content;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
  });

  Review copyWith({
    String? id,
    String? author,
    AuthorDetails? authorDetails,
    String? content,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      author: author ?? this.author,
      authorDetails: authorDetails ?? this.authorDetails,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
