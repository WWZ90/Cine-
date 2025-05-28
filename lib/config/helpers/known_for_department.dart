import 'package:flutter/material.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension KnownForDepartmentLocalization on KnownForDepartment {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case KnownForDepartment.DIRECTING:
        return l10n.knownForDirecting;
      case KnownForDepartment.WRITING:
        return l10n.knownForWriting;
      case KnownForDepartment.SOUND:
        return l10n.knownForSound;
      default:
        return l10n.knownForActing;
    }
  }
}
