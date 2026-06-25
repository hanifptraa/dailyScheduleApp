import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../utils/time_utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: asyncSettings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Gagal memuat settings: $error')),
        data: (settings) {
          final userName = settings['userName'] ?? 'Hanif';
          final themeMode = settings['themeMode'] ?? 'system';
          final targetSleep = settings['targetSleep'] ?? '21:00';
          final targetWake = settings['targetWake'] ?? '03:00';

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Nama user'),
                  subtitle: Text(userName),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _editTextSetting(context, ref,
                      key: 'userName',
                      title: 'Nama user',
                      initialValue: userName),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    initialValue: themeMode,
                    decoration:
                        const InputDecoration(labelText: 'Tema aplikasi'),
                    items: const [
                      DropdownMenuItem(
                          value: 'system', child: Text('Ikuti sistem')),
                      DropdownMenuItem(
                          value: 'light', child: Text('Light mode')),
                      DropdownMenuItem(value: 'dark', child: Text('Dark mode')),
                    ],
                    onChanged: (value) async {
                      if (value == null) return;
                      await ref
                          .read(scheduleRepositoryProvider)
                          .setSetting('themeMode', value);
                      refreshMainProviders(ref);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bedtime),
                      title: const Text('Target tidur'),
                      subtitle: Text(targetSleep),
                      onTap: () => _pickTimeSetting(context, ref,
                          key: 'targetSleep', initialValue: targetSleep),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.wb_twilight),
                      title: const Text('Target bangun'),
                      subtitle: Text(targetWake),
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
                          'Jadwal aktif akan diganti default. Riwayat lama tetap aman.'),
                      onTap: () => _confirmAction(
                        context,
                        title: 'Reset jadwal?',
                        message:
                            'Semua jadwal aktif akan dinonaktifkan lalu jadwal default dimasukkan lagi.',
                        onConfirm: () async {
                          await ref
                              .read(scheduleRepositoryProvider)
                              .resetSchedulesToDefault();
                          refreshMainProviders(ref);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_sweep),
                      title: const Text('Hapus semua data checklist'),
                      subtitle: const Text(
                          'Riwayat progress dan mode harian akan dihapus.'),
                      onTap: () => _confirmAction(
                        context,
                        title: 'Hapus checklist?',
                        message:
                            'Semua data checklist dan history akan dihapus permanen dari database lokal.',
                        onConfirm: () async {
                          await ref
                              .read(scheduleRepositoryProvider)
                              .clearChecklistData();
                          refreshMainProviders(ref);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Tentang aplikasi'),
                  subtitle: Text(
                      'Daily Schedule v1.0 • Offline personal schedule/checklist app dengan Flutter + Drift + SQLite.'),
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
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );
    controller.dispose();

    if (result != null && result.isNotEmpty) {
      await ref.read(scheduleRepositoryProvider).setSetting(key, result);
      refreshMainProviders(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Settings disimpan')));
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
    if (result == null) return;
    await ref
        .read(scheduleRepositoryProvider)
        .setSetting(key, AppTimeUtils.fromTimeOfDay(result));
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
    if (result == true) {
      await onConfirm();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Berhasil')));
      }
    }
  }
}
