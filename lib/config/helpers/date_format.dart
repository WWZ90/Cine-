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
