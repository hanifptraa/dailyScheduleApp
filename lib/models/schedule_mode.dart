enum ScheduleModeType {
  regular('regular', 'Hari Biasa'),
  basket('basket', 'Hari Basket'),
  custom('custom', 'Custom');

  const ScheduleModeType(this.code, this.label);
  final String code;
  final String label;

  static ScheduleModeType fromCode(String code) {
    return ScheduleModeType.values.firstWhere(
      (item) => item.code == code,
      orElse: () => ScheduleModeType.regular,
    );
  }
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
