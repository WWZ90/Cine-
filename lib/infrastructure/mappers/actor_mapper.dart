import 'package:cinemania/domain/entities/actor.dart';
import 'package:cinemania/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    character: cast.character,
    profilePath:
        cast.profilePath != ''
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'no-avatar',
  );
}
