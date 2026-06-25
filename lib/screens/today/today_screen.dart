import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/schedule_mode.dart';
import '../../providers/app_providers.dart';
import '../../utils/date_utils.dart';
import '../../widgets/category_badge.dart';
import '../../widgets/empty_state.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncToday = ref.watch(todayDataProvider);
    final dateText = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => refreshMainProviders(ref),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: asyncToday.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Gagal memuat jadwal: $error')),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async => refreshMainProviders(ref),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Text(dateText, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                _ProgressCard(
                  done: data.done,
                  total: data.total,
                  percent: data.percent,
                  progress: data.progress,
                  mode: data.mode,
                  onModeChanged: (mode) async {
                    final key = AppDateUtils.dateKey(DateTime.now());
                    await ref
                        .read(scheduleRepositoryProvider)
                        .setDailyMode(key, mode);
                    refreshMainProviders(ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Mode hari ini: ${mode.label}')));
                    }
                  },
                ),
                const SizedBox(height: 14),
                if (data.entries.isEmpty)
                  const SizedBox(
                    height: 420,
                    child: EmptyState(
                      icon: Icons.event_busy,
                      title: 'Belum ada jadwal',
                      message:
                          'Tambahkan jadwal aktif untuk mode ini di tab Schedule.',
                    ),
                  )
                else
                  ...data.entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TodayScheduleCard(
                          title: entry.item.title,
                          time:
                              '${entry.item.startTime} - ${entry.item.endTime}',
                          category: entry.item.category,
                          description: entry.item.description,
                          isDone: entry.isDone,
                          onChanged: (value) async {
                            await ref
                                .read(scheduleRepositoryProvider)
                                .setChecklistDone(
                                  dateKey: data.dateKey,
                                  mode: data.mode,
                                  item: entry.item,
                                  isDone: value ?? false,
                                );
                            refreshMainProviders(ref);
                          },
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.done,
    required this.total,
    required this.percent,
    required this.progress,
    required this.mode,
    required this.onModeChanged,
  });

  final int done;
  final int total;
  final int percent;
  final double progress;
  final ScheduleModeType mode;
  final ValueChanged<ScheduleModeType> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress hari ini',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('$done/$total selesai • $percent%',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                Icon(Icons.track_changes, color: scheme.primary),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(999)),
            const SizedBox(height: 16),
            DropdownButtonFormField<ScheduleModeType>(
              initialValue: mode,
              decoration: const InputDecoration(labelText: 'Mode hari ini'),
              items: ScheduleModeType.values
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)))
                  .toList(),
              onChanged: (value) {
                if (value != null) onModeChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayScheduleCard extends StatelessWidget {
  const _TodayScheduleCard({
    required this.title,
    required this.time,
    required this.category,
    required this.description,
    required this.isDone,
    required this.onChanged,
  });

  final String title;
  final String time;
  final String category;
  final String? description;
  final bool isDone;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onChanged(!isDone),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.25,
                child: Checkbox(value: isDone, onChanged: onChanged),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(time,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(width: 8),
                        CategoryBadge(label: category),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                          ),
                    ),
                    if (description != null &&
                        description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(description!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
