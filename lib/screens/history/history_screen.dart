import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../utils/date_utils.dart';
import '../../widgets/category_badge.dart';
import '../../widgets/empty_state.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHistory = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: RefreshIndicator(
        onRefresh: () async => refreshMainProviders(ref),
        child: asyncHistory.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Gagal memuat riwayat: $error')),
          data: (history) {
            if (history.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(
                    height: 480,
                    child: EmptyState(
                      icon: Icons.history_toggle_off,
                      title: 'Belum ada riwayat',
                      message:
                          'Buka Hari Ini dan gunakan checklist agar riwayat tersimpan.',
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final day = history[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      childrenPadding: const EdgeInsets.only(bottom: 8),
                      title: Text(
                        AppDateUtils.formatDateKey(day.dateKey),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                            '${day.mode.label} • ${day.done}/${day.total} selesai • ${day.percent}% • ${day.status}'),
                      ),
                      trailing: _PercentPill(percent: day.percent),
                      children: [
                        const Divider(height: 1),
                        for (final item in day.items)
                          ListTile(
                            leading: Icon(item.isDone
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked),
                            title: Text(item.snapshotTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${item.snapshotStartTime} - ${item.snapshotEndTime}'),
                                  const SizedBox(height: 6),
                                  CategoryBadges(value: item.snapshotCategory),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PercentPill extends StatelessWidget {
  const _PercentPill({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 54,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$percent%',
        style: TextStyle(
            color: scheme.onPrimaryContainer, fontWeight: FontWeight.w900),
      ),
    );
  }
}
