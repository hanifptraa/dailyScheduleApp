class AppDateUtils {
  const AppDateUtils._();

  static String dateKey(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime fromDateKey(String key) {
    final parts = key.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }
}
