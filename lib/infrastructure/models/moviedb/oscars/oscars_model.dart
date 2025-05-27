// import 'dart:convert';
// // No necesitas Locale aquí si el título en Nominee es solo de referencia

// class Ceremony {
//   final int ceremonyNumber;
//   final int ceremonyYear;
//   final String? ceremonyDate;
//   final List<OscarCategory> categories;

//   Ceremony({
//     required this.ceremonyNumber,
//     required this.ceremonyYear,
//     this.ceremonyDate,
//     required this.categories,
//   });

//   factory Ceremony.fromJson(Map<String, dynamic> json) => Ceremony(
//     ceremonyNumber: json['ceremony_number'],
//     ceremonyYear: json['ceremony_year'],
//     ceremonyDate: json['ceremony_date'],
//     categories:
//         (json['categories'] as List)
//             .map((e) => OscarCategory.fromJson(e))
//             .toList(),
//   );
// }

// class OscarCategory {
//   final String category;
//   final List<Nominee> nominees;

//   OscarCategory({required this.category, required this.nominees});

//   factory OscarCategory.fromJson(Map<String, dynamic> json) {
//     var nomineesList = json['nominees'] as List;
//     List<Nominee> nomineesData =
//         nomineesList.map((i) => Nominee.fromJson(i)).toList();
//     return OscarCategory(category: json['category'], nominees: nomineesData);
//   }

//   List<Nominee> get allWinners => nominees.where((n) => n.won).toList();

//   List<Nominee> get nonWinners => nominees.where((n) => !n.won).toList();
// }

// class Nominee {
//   final int tmdbId; // Ahora no es nullable, asumimos que siempre lo tendrás
//   final String title; // Título de referencia del JSON
//   final bool won;

//   Nominee({required this.tmdbId, required this.title, required this.won});

//   factory Nominee.fromJson(Map<String, dynamic> json) {
//     return Nominee(
//       tmdbId: json['tmdb_id'] as int, // Asegúrate de que el ID siempre esté
//       title: json['title'] as String,
//       won: json['won'] as bool? ?? false,
//     );
//   }
// }

// List<Ceremony> parseCeremonies(String jsonString) {
//   final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
//   return parsed.map<Ceremony>((json) => Ceremony.fromJson(json)).toList();
// }

// oscars_model.dart

import 'dart:convert';

class Ceremony {
  final int ceremonyNumber;
  final int ceremonyYear;
  final String? ceremonyDate;
  final List<OscarCategory> categories;

  Ceremony({
    required this.ceremonyNumber,
    required this.ceremonyYear,
    this.ceremonyDate,
    required this.categories,
  });

  factory Ceremony.fromJson(Map<String, dynamic> json) => Ceremony(
    ceremonyNumber: json['ceremony_number'],
    ceremonyYear: json['ceremony_year'],
    ceremonyDate: json['ceremony_date'],
    categories:
        (json['categories'] as List)
            .map((e) => OscarCategory.fromJson(e))
            .toList(),
  );
}

class OscarCategory {
  final String category;
  final List<Nominee> nominees;

  OscarCategory({required this.category, required this.nominees});

  factory OscarCategory.fromJson(Map<String, dynamic> json) {
    var nomineesList = json['nominees'] as List;
    // Pasar el nombre de la categoría al Nominee.fromJson para lógica condicional
    List<Nominee> nomineesData =
        nomineesList
            .map((i) => Nominee.fromJson(i, categoryName: json['category']))
            .toList();
    return OscarCategory(category: json['category'], nominees: nomineesData);
  }

  List<Nominee> get allWinners => nominees.where((n) => n.won).toList();
  List<Nominee> get nonWinners => nominees.where((n) => !n.won).toList();
}

class Nominee {
  // Para películas y otros premios basados en películas:
  final int?
  tmdbId; // ID de la película o del director si es categoría 'Directing'
  final String? title; // Título de la película

  // Específico para Directores (y potencialmente Actores si se añade):
  final String? name; // Nombre del director/actor
  final int? titleId; // ID de la película asociada al director/actor

  final bool won;

  Nominee({
    this.tmdbId, // ID de la película O del director
    this.title, // Título de la película
    this.name, // Nombre del director
    this.titleId, // ID de la película asociada al director
    required this.won,
  });

  factory Nominee.fromJson(
    Map<String, dynamic> json, {
    required String categoryName,
  }) {
    if (categoryName == 'Best Director') {
      return Nominee(
        tmdbId: json['tmdb_id'] as int?, // Este será el ID del director
        name: json['name'] as String?,
        title:
            json['title'] as String?, // Película por la que fue nominado/ganó
        titleId: json['title_id'] as int?,
        won: json['won'] as bool? ?? false,
      );
    } else {
      // Para otras categorías como Best Picture, Animated Feature, Visual Effects
      return Nominee(
        tmdbId: json['tmdb_id'] as int?, // ID de la película
        title: json['title'] as String?,
        name:
            null, // No aplica directamente o se obtiene del detalle de la película
        titleId: null,
        won: json['won'] as bool? ?? false,
      );
    }
  }
}

List<Ceremony> parseCeremonies(String jsonString) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<Ceremony>((json) => Ceremony.fromJson(json)).toList();
}
