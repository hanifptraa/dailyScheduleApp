import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../tutorial/guided_tutorial_controller.dart';
import '../../tutorial/tutorial_keys.dart';
import '../../utils/time_utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsProvider);
    final asyncPermission = ref.watch(notificationPermissionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Setelan')),
      body: asyncSettings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Gagal memuat setelan: $error')),
        data: (settings) {
          final userName = settings['userName'] ?? 'Hanif';
          final themeMode = settings['themeMode'] == 'dark' ? 'dark' : 'light';
          final targetSleep = settings['targetSleep'] ?? '21:00';
          final targetWake = settings['targetWake'] ?? '03:00';

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Profil',
                                style: Theme.of(context).textTheme.labelLarge),
                            Text(userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit nama',
                        onPressed: () => _editTextSetting(context, ref,
                            key: 'userName',
                            title: 'Nama user',
                            initialValue: userName),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.contrast_outlined),
                          const SizedBox(width: 10),
                          Text('Tema aplikasi',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'light',
                              label: Text('Light'),
                              icon: Icon(Icons.light_mode_outlined),
                            ),
                            ButtonSegment(
                              value: 'dark',
                              label: Text('Dark'),
                              icon: Icon(Icons.dark_mode_outlined),
                            ),
                          ],
                          selected: {themeMode},
                          onSelectionChanged: (values) async {
                            final value = values.first;
                            await ref
                                .read(scheduleRepositoryProvider)
                                .setSetting('themeMode', value);
                            if (!context.mounted) return;
                            ref.invalidate(settingsProvider);
                            ref.invalidate(themeModeProvider);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_active_outlined),
                          const SizedBox(width: 10),
                          Text('Notifikasi',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      asyncPermission.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => const Text(
                            'Status izin notifikasi belum bisa dibaca.'),
                        data: (allowed) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status izin notifikasi: ${allowed ? 'Aktif' : 'Belum aktif'}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            if (!allowed) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Notifikasi belum aktif. Aktifkan izin notifikasi agar pengingat jadwal bisa muncul.',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(notificationServiceProvider)
                                  .requestNotificationPermission();
                              ref.invalidate(notificationPermissionProvider);
                            },
                            icon: const Icon(Icons.verified_user_outlined),
                            label: const Text('Cek Izin Notifikasi'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(notificationServiceProvider)
                                  .rescheduleTodayNotifications(
                                    ref.read(scheduleRepositoryProvider),
                                  );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Notifikasi hari ini dijadwalkan ulang'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh_outlined),
                            label: const Text(
                                'Jadwalkan Ulang Notifikasi Hari Ini'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(notificationServiceProvider)
                                  .cancelAllNotifications();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua notifikasi dimatikan'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.notifications_off_outlined),
                            label: const Text('Matikan Semua Notifikasi'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bedtime_outlined),
                      title: const Text('Target tidur'),
                      subtitle: Text(targetSleep),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _pickTimeSetting(context, ref,
                          key: 'targetSleep', initialValue: targetSleep),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.wb_twilight_outlined),
                      title: const Text('Target bangun'),
                      subtitle: Text(targetWake),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _pickTimeSetting(context, ref,
                          key: 'targetWake', initialValue: targetWake),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.restart_alt),
                      title: const Text('Reset jadwal ke default'),
                      subtitle: const Text(
                          'Jadwal aktif dinonaktifkan lalu default dimasukkan ulang.'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmAction(
                        context,
                        title: 'Reset jadwal?',
                        message:
                            'Semua jadwal aktif akan dinonaktifkan lalu jadwal default dimasukkan lagi. Riwayat lama tetap aman.',
                        onConfirm: () async {
                          await ref
                              .read(scheduleRepositoryProvider)
                              .resetSchedulesToDefault();
                          if (!context.mounted) return;
                          refreshMainProviders(ref);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_sweep_outlined),
                      title: const Text('Hapus semua checklist'),
                      subtitle: const Text(
                          'Riwayat progress dan mode harian akan dihapus permanen.'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmAction(
                        context,
                        title: 'Hapus checklist?',
                        message:
                            'Semua data checklist dan riwayat akan dihapus permanen dari database lokal.',
                        onConfirm: () async {
                          await ref
                              .read(scheduleRepositoryProvider)
                              .clearChecklistData();
                          if (!context.mounted) return;
                          refreshMainProviders(ref);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      key: TutorialKeys.settingsTutorialButton,
                      leading: const Icon(Icons.school_outlined),
                      title: const Text('Tampilkan Tutorial Lagi'),
                      subtitle: const Text(
                          'Lihat kembali panduan singkat penggunaan aplikasi.'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => ref
                          .read(guidedTutorialRequestProvider.notifier)
                          .start(),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Tentang aplikasi'),
                      subtitle: Text(
                          'Daily Schedule v1.0 - Offline personal schedule/checklist app dengan Flutter + Drift + SQLite.'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editTextSetting(
    BuildContext context,
    WidgetRef ref, {
    required String key,
    required String title,
    required String initialValue,
  }) async {
    var input = initialValue;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          initialValue: initialValue,
          autofocus: true,
          onChanged: (value) => input = value,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, input.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      await WidgetsBinding.instance.endOfFrame;
      if (!context.mounted) return;
      await ref.read(scheduleRepositoryProvider).setSetting(key, result);
      if (!context.mounted) return;
      refreshMainProviders(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Setelan disimpan')));
      }
    }
  }

  Future<void> _pickTimeSetting(
    BuildContext context,
    WidgetRef ref, {
    required String key,
    required String initialValue,
  }) async {
    final result = await showTimePicker(
      context: context,
      initialTime: AppTimeUtils.toTimeOfDay(initialValue),
    );
    if (result == null || !context.mounted) return;
    await ref
        .read(scheduleRepositoryProvider)
        .setSetting(key, AppTimeUtils.fromTimeOfDay(result));
    if (!context.mounted) return;
    refreshMainProviders(ref);
  }

  Future<void> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ya')),
        ],
      ),
    );
    if (result == true && context.mounted) {
      await onConfirm();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Berhasil')));
      }
    }
  }
}
