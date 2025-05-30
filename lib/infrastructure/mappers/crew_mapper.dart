import 'package:cinemania/domain/entities/entities.dart';

class CrewMemberMapper {
  static CrewPerson crewMemberFromJson(Map<String, dynamic> json) => CrewPerson(
    id: json['id'],
    name: json['name'] ?? 'No Name',
    profilePath:
        json['profile_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
            : 'no-avatar',
    department: json['department'] ?? '',
    job: json['job'] ?? '',
    creditId: json['credit_id'] ?? '',
    adult: json['adult'],
    gender: json['gender'] ?? 1,
    originalName: json['original_name'] ?? '',
    popularity: json['popularity'] ?? 0,
  );
}
