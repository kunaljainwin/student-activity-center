bool isToday(DateTime date) {
  final DateTime localDate = date.toLocal();
  final now = DateTime.now();
  final diff = now.difference(localDate).inDays;
  return diff == 0 && now.day == localDate.day;
}
