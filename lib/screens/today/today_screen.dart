import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final asyncModes = ref.watch(scheduleModesProvider);
    final dateText = AppDateUtils.formatFull(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari Ini'),
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
          final modes = asyncModes.value ?? ScheduleModeOption.defaults;
          return RefreshIndicator(
            onRefresh: () async => refreshMainProviders(ref),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              children: [
                _ProgressCard(
                  dateText: dateText,
                  done: data.done,
                  total: data.total,
                  percent: data.percent,
                  progress: data.progress,
                  mode: data.mode,
                  modes: modes,
                  onModeChanged: (mode) async {
                    final key = AppDateUtils.dateKey(DateTime.now());
                    await ref
                        .read(scheduleRepositoryProvider)
                        .setDailyMode(key, mode);
                    if (!context.mounted) return;
                    refreshMainProviders(ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mode hari ini: ${mode.label}')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text(
                      'Agenda',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      '${data.entries.length} kegiatan',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (data.entries.isEmpty)
                  const SizedBox(
                    height: 420,
                    child: EmptyState(
                      icon: Icons.event_busy,
                      title: 'Belum ada jadwal',
                      message:
                          'Tambahkan jadwal aktif untuk mode ini di tab Jadwal.',
                    ),
                  )
                else
                  ...data.entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
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
                            if (!context.mounted) return;
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
    required this.dateText,
    required this.done,
    required this.total,
    required this.percent,
    required this.progress,
    required this.mode,
    required this.modes,
    required this.onModeChanged,
  });

  final String dateText;
  final int done;
  final int total;
  final int percent;
  final double progress;
  final ScheduleModeOption mode;
  final List<ScheduleModeOption> modes;
  final ValueChanged<ScheduleModeOption> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final allModes = [
      if (!modes.any((item) => item.code == mode.code)) mode,
      ...modes,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      Text(
                        percent >= 70
                            ? 'Ritme kamu bagus hari ini'
                            : 'Mulai pelan-pelan, satu agenda dulu',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$percent%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: scheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 10),
            Text('$done dari $total kegiatan selesai',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            _ModePickerButton(
              mode: mode,
              modes: allModes,
              onChanged: onModeChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModePickerButton extends StatelessWidget {
  const _ModePickerButton({
    required this.mode,
    required this.modes,
    required this.onChanged,
  });

  final ScheduleModeOption mode;
  final List<ScheduleModeOption> modes;
  final ValueChanged<ScheduleModeOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final result = await showModalBottomSheet<ScheduleModeOption>(
          context: context,
          useSafeArea: true,
          builder: (context) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pilih Mode Hari',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                for (final item in modes)
                  Card(
                    child: ListTile(
                      leading: Icon(item.code == mode.code
                          ? Icons.check_circle
                          : Icons.event_note_outlined),
                      title: Text(item.label,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      onTap: () => Navigator.pop(context, item),
                    ),
                  ),
              ],
            ),
          ),
        );
        if (result != null) onChanged(result);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Mode hari ini',
          prefixIcon: Icon(Icons.event_available_outlined),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(mode.label,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            Icon(Icons.expand_more, color: scheme.onSurfaceVariant),
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
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!isDone),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(value: isDone, onChanged: onChanged),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          time,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        CategoryBadges(value: category),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: isDone
                                ? scheme.onSurfaceVariant
                                : scheme.onSurface,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                          ),
                    ),
                    if (description != null &&
                        description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(description!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant)),
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
