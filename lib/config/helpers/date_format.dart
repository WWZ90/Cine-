import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String formatDateOld(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String formatDate(DateTime date) {
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  String monthName = months[date.month - 1];
  String formatted = '${date.day} ${_capitalize(monthName)}, ${date.year}';

  return formatted;
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String formatDateNew(BuildContext context, DateTime date) {
    final loc = AppLocalizations.of(context)!;
    final day = date.day.toString().padLeft(2, '0');
    final month = _localizedMonth(loc, date.month);
    final year = date.year;
    return '$day $month. $year';
  }

  String _localizedMonth(AppLocalizations loc, int month) {
    switch (month) {
      case 1:
        return loc.month_1;
      case 2:
        return loc.month_2;
      case 3:
        return loc.month_3;
      case 4:
        return loc.month_4;
      case 5:
        return loc.month_5;
      case 6:
        return loc.month_6;
      case 7:
        return loc.month_7;
      case 8:
        return loc.month_8;
      case 9:
        return loc.month_9;
      case 10:
        return loc.month_10;
      case 11:
        return loc.month_11;
      case 12:
        return loc.month_12;
      default:
        return '';
    }
  }
