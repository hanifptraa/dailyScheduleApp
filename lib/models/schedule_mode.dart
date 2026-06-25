class ScheduleModeOption {
  const ScheduleModeOption({required this.code, required this.label});

  final String code;
  final String label;

  static const regular =
      ScheduleModeOption(code: 'regular', label: 'Hari Biasa');
  static const basket =
      ScheduleModeOption(code: 'basket', label: 'Hari Basket');

  static const defaults = <ScheduleModeOption>[regular, basket];

  static ScheduleModeOption fromCode(String code) {
    final trimmed = code.trim();
    for (final mode in defaults) {
      if (mode.code == trimmed) return mode;
    }
    return ScheduleModeOption(
        code: trimmed, label: trimmed.isEmpty ? 'Custom' : trimmed);
  }

  static String normalizeCustomCode(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleModeOption && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

const maxCategoriesPerSchedule = 3;
const maxCategoryNameLength = 24;

const defaultCategories = <String>[
  'Persiapan',
  'Ibadah',
  'Coding',
  'Rutinitas',
  'Project',
  'Olahraga',
  'Istirahat',
  'Digital Skill',
  'Review',
  'Planning',
];

List<String> parseCategories(String value) {
  return value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toSet()
      .take(maxCategoriesPerSchedule)
      .toList();
}

String normalizeCategoryName(String value) {
  final trimmed = value.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (trimmed.length <= maxCategoryNameLength) return trimmed;
  return trimmed.substring(0, maxCategoryNameLength).trim();
}

String normalizeCategoryValue(String value) {
  final parsed = parseCategories(value);
  return encodeCategories(parsed.isEmpty ? [value] : parsed);
}

String encodeCategories(Iterable<String> categories) {
  final normalized = <String>[];
  for (final category in categories) {
    final value = normalizeCategoryName(category);
    if (value.isEmpty || normalized.contains(value)) continue;
    normalized.add(value);
    if (normalized.length == maxCategoriesPerSchedule) break;
  }
  return normalized.join(', ');
}

String productivityStatus(int percent) {
  if (percent >= 90) return 'Sangat Produktif';
  if (percent >= 70) return 'Produktif';
  if (percent >= 50) return 'Cukup';
  return 'Perlu diperbaiki';
}
