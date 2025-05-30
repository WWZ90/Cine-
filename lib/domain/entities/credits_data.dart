import 'package:cinemania/domain/entities/entities.dart';

class CreditsData {
  final List<CastPerson> cast;
  final List<CrewPerson> crew;
  CreditsData({required this.cast, required this.crew});
}
