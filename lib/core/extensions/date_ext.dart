extension ToDate on DateTime {
  String get toDate => '$day/$month/$year';

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
