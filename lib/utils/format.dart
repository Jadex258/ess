String formatDate(DateTime? date) {
  if (date == null) return 'Select date';
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}