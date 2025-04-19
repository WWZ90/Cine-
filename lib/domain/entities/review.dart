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
}
