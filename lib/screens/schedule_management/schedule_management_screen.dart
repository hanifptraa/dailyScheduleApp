import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/app_database.dart';
import '../../models/schedule_mode.dart';
import '../../providers/app_providers.dart';
import '../../utils/time_utils.dart';
import '../../widgets/category_badge.dart';
import '../../widgets/empty_state.dart';

class ScheduleManagementScreen extends ConsumerWidget {
  const ScheduleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(scheduleModeFilterProvider);
    final asyncItems = ref.watch(scheduleItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Schedule')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: DropdownButtonFormField<ScheduleModeType>(
              initialValue: filter,
              decoration:
                  const InputDecoration(labelText: 'Filter mode jadwal'),
              items: ScheduleModeType.values
                  .map((mode) =>
                      DropdownMenuItem(value: mode, child: Text(mode.label)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(scheduleModeFilterProvider.notifier).setMode(value);
                }
              },
            ),
          ),
          Expanded(
            child: asyncItems.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Gagal memuat jadwal: $error')),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: Icons.playlist_add,
                    title: 'Jadwal kosong',
                    message:
                        'Tekan tombol Tambah untuk membuat jadwal pada mode ini.',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          title: Text(item.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                    label: Text(
                                        '${item.startTime} - ${item.endTime}')),
                                CategoryBadge(label: item.category),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                _openForm(context, ref, item);
                              } else if (value == 'delete') {
                                await _confirmDelete(context, ref, item);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Nonaktifkan/Hapus')),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ScheduleItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus jadwal?'),
        content: Text(
            'Jadwal "${item.title}" akan dinonaktifkan. Riwayat lama tetap aman.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (result == true) {
      await ref
          .read(scheduleRepositoryProvider)
          .softDeleteScheduleItem(item.id);
      refreshMainProviders(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal dinonaktifkan')));
      }
    }
  }

  void _openForm(BuildContext context, WidgetRef ref, ScheduleItem? item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ScheduleFormSheet(item: item),
    );
  }
}

class ScheduleFormSheet extends ConsumerStatefulWidget {
  const ScheduleFormSheet({super.key, this.item});

  final ScheduleItem? item;

  @override
  ConsumerState<ScheduleFormSheet> createState() => _ScheduleFormSheetState();
}

class _ScheduleFormSheetState extends ConsumerState<ScheduleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late String _category;
  late ScheduleModeType _mode;
  late bool _isActive;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _start = item == null
        ? const TimeOfDay(hour: 8, minute: 0)
        : AppTimeUtils.toTimeOfDay(item.startTime);
    _end = item == null
        ? const TimeOfDay(hour: 9, minute: 0)
        : AppTimeUtils.toTimeOfDay(item.endTime);
    _category = item?.category ?? defaultCategories.first;
    _mode = item == null
        ? ref.read(scheduleModeFilterProvider)
        : ScheduleModeType.fromCode(item.scheduleMode);
    _isActive = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_isEdit ? 'Edit Jadwal' : 'Tambah Jadwal',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Nama jadwal/kegiatan'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama kegiatan tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Deskripsi/catatan opsional'),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async => _pickTime(isStart: true),
                      icon: const Icon(Icons.schedule),
                      label:
                          Text('Mulai ${AppTimeUtils.fromTimeOfDay(_start)}'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async => _pickTime(isStart: false),
                      icon: const Icon(Icons.schedule),
                      label:
                          Text('Selesai ${AppTimeUtils.fromTimeOfDay(_end)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: defaultCategories
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(
                    () => _category = value ?? defaultCategories.first),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ScheduleModeType>(
                initialValue: _mode,
                decoration: const InputDecoration(labelText: 'Mode jadwal'),
                items: ScheduleModeType.values
                    .map((mode) =>
                        DropdownMenuItem(value: mode, child: Text(mode.label)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _mode = value ?? ScheduleModeType.regular),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktif'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Jadwal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime({required bool isStart}) async {
    final result = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (result != null) {
      setState(() {
        if (isStart) {
          _start = result;
        } else {
          _end = result;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final start = AppTimeUtils.fromTimeOfDay(_start);
    final end = AppTimeUtils.fromTimeOfDay(_end);
    if (!AppTimeUtils.isValidRange(start, end)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Jam mulai tidak boleh lebih besar dari jam selesai')));
      return;
    }

    final repo = ref.read(scheduleRepositoryProvider);
    if (_isEdit) {
      await repo.updateScheduleItem(
        id: widget.item!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: start,
        endTime: end,
        category: _category,
        mode: _mode,
        isActive: _isActive,
      );
    } else {
      await repo.createScheduleItem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: start,
        endTime: end,
        category: _category,
        mode: _mode,
      );
    }

    ref.read(scheduleModeFilterProvider.notifier).setMode(_mode);
    refreshMainProviders(ref);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit
              ? 'Jadwal berhasil diperbarui'
              : 'Jadwal berhasil ditambahkan')));
    }
  }
}
