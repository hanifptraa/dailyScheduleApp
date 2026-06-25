import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(statisticsProvider);
    return asyncStats.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text('Gagal memuat statistik: $error'),
        ),
      ),
      data: (stats) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistik Sederhana', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              _StatRow(label: 'Progress hari ini', value: '${stats.todayPercent}%'),
              _StatRow(label: 'Rata-rata 7 hari', value: '${stats.last7Average}%'),
              _StatRow(label: 'Hari produktif', value: '${stats.productiveDays} hari'),
              _StatRow(label: 'Streak ≥ 70%', value: '${stats.streak} hari'),
              _StatRow(label: 'Kategori sering selesai', value: stats.mostDoneCategory),
              _StatRow(label: 'Kategori sering terlewat', value: stats.mostMissedCategory),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
