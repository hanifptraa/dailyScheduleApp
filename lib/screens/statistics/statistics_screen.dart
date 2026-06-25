import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/today_models.dart';
import '../../providers/app_providers.dart';
import '../../utils/date_utils.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(statisticsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: RefreshIndicator(
        onRefresh: () async => refreshMainProviders(ref),
        child: asyncStats.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text('Gagal memuat statistik: $error')))
            ],
          ),
          data: (stats) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
            children: [
              _ScoreCard(stats: stats),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.sizeOf(context).width > 520 ? 4 : 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.45,
                children: [
                  _MetricCard(
                      icon: Icons.today,
                      label: 'Hari ini',
                      value: '${stats.todayPercent}%',
                      helper: 'progress aktif'),
                  _MetricCard(
                      icon: Icons.show_chart,
                      label: 'Rata-rata 7 hari',
                      value: '${stats.last7Average}%',
                      helper: 'konsistensi'),
                  _MetricCard(
                      icon: Icons.local_fire_department,
                      label: 'Streak',
                      value: '${stats.streak}',
                      helper: 'hari produktif'),
                  _MetricCard(
                      icon: Icons.done_all,
                      label: 'Selesai',
                      value: '${stats.completedTasks}/${stats.totalTasks}',
                      helper: '${stats.completionRate}% total'),
                ],
              ),
              const SizedBox(height: 12),
              _TrendSection(points: stats.trend),
              const SizedBox(height: 12),
              _CategorySection(categories: stats.categories),
              const SizedBox(height: 12),
              _InsightSection(stats: stats),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.stats});

  final StatisticsData stats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Skor Produktivitas',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  Text(
                    '${stats.consistencyScore}%',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stats.consistencyScore >= 70
                        ? 'Ritme mingguan kamu sudah stabil.'
                        : 'Fokus pada agenda paling penting dulu minggu ini.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 92,
              height: 92,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: stats.consistencyScore / 100,
                    strokeWidth: 10,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                  Center(
                    child:
                        Icon(Icons.insights, color: scheme.primary, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.helper});

  final IconData icon;
  final String label;
  final String value;
  final String helper;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: scheme.primary, size: 22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900)),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge),
                Text(helper,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendSection extends StatelessWidget {
  const _TrendSection({required this.points});

  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tren 7 Hari',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            if (points.isEmpty)
              Text(
                  'Belum ada data tren. Checklist hari ini akan mulai membentuk grafik.',
                  style: TextStyle(color: scheme.onSurfaceVariant))
            else ...[
              SizedBox(
                  height: 140,
                  child: CustomPaint(
                      painter:
                          _TrendPainter(points: points, color: scheme.primary),
                      child: const SizedBox.expand())),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: points.map((point) {
                  final date = AppDateUtils.fromDateKey(point.dateKey);
                  return Expanded(
                    child: Text(
                      AppDateUtils.formatShortDay(date),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.categories});

  final List<CategoryPerformance> categories;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Performa Kategori',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            if (categories.isEmpty)
              Text('Kategori sering dipakai akan muncul setelah ada checklist.',
                  style: TextStyle(color: scheme.onSurfaceVariant))
            else
              ...categories.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CategoryBar(item: item),
                  )),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.item});

  final CategoryPerformance item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(item.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            const SizedBox(width: 12),
            Text('${item.percent}%',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 7),
        LinearProgressIndicator(
          value: item.percent / 100,
          minHeight: 9,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: scheme.surfaceContainerHighest,
        ),
      ],
    );
  }
}

class _InsightSection extends StatelessWidget {
  const _InsightSection({required this.stats});

  final StatisticsData stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Insight',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _InsightRow(
                icon: Icons.emoji_events_outlined,
                label: 'Hari terbaik',
                value: stats.bestDayLabel == '-'
                    ? '-'
                    : '${stats.bestDayLabel} - ${stats.bestDayPercent}%'),
            _InsightRow(
                icon: Icons.check_circle_outline,
                label: 'Kategori terkuat',
                value: stats.mostDoneCategory),
            _InsightRow(
                icon: Icons.error_outline,
                label: 'Perlu perhatian',
                value: stats.mostMissedCategory),
            _InsightRow(
                icon: Icons.calendar_month_outlined,
                label: 'Hari produktif',
                value: '${stats.productiveDays} hari'),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.points, required this.color});

  final List<TrendPoint> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (points.length == 1) {
      final y = size.height * (1 - points.first.percent / 100);
      canvas.drawCircle(Offset(size.width / 2, y), 5, Paint()..color = color);
      return;
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / math.max(1, points.length - 1);
      final y = size.height * (1 - points[i].percent / 100);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / math.max(1, points.length - 1);
      final y = size.height * (1 - points[i].percent / 100);
      canvas.drawCircle(Offset(x, y), 5, Paint()..color = color);
      canvas.drawCircle(Offset(x, y), 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
