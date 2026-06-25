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

String productivityStatus(int percent) {
  if (percent >= 90) return 'Sangat Produktif';
  if (percent >= 70) return 'Produktif';
  if (percent >= 50) return 'Cukup';
  return 'Perlu diperbaiki';
}
