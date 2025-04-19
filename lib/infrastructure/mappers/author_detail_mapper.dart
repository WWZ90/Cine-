import 'package:cinemania/domain/entities/author_details.dart';

class AuthorDetailsMapper {
  static AuthorDetails fromResponse(AuthorDetails api) {
    // El path crudo que viene de la API:
    final raw = api.avatarPath ?? '';

    // Calculamos la URL definitiva:
    final String avatarUrl = () {
      if (raw.isEmpty) {
        return 'no-avatar';                           // tu asset local
      }
      if (raw.startsWith('/https')) {
        return raw.substring(1);                      // algunos vienen con "/" delante
      }
      return 'https://image.tmdb.org/t/p/w500$raw';    // caso path relativo
    }();

    return AuthorDetails(
      avatarPath: avatarUrl,
      rating: api.rating,
      username: api.username,
      name: api.name,
    );
  }
}
