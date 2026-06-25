import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../widgets/empty_state.dart';
import '../statistics/statistics_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHistory = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
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
                              'Buka Today dan gunakan checklist agar riwayat tersimpan.')),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const StatisticsScreen(),
                const SizedBox(height: 14),
                ...history.map((day) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(day.dateKey,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                          subtitle: Text(
                              '${day.mode.label} • ${day.done}/${day.total} selesai • ${day.percent}% • ${day.status}'),
                          children: [
                            const Divider(height: 1),
                            for (final item in day.items)
                              ListTile(
                                leading: Icon(item.isDone
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked),
                                title: Text(item.snapshotTitle),
                                subtitle: Text(
                                    '${item.snapshotStartTime} - ${item.snapshotEndTime} • ${item.snapshotCategory}'),
                              ),
                          ],
                        ),
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
