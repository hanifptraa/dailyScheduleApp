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
    final asyncModes = ref.watch(scheduleModesProvider);
    final asyncCategories = ref.watch(categoriesProvider);
    final modeSuggestions = asyncModes.value ?? ScheduleModeOption.defaults;
    final categorySuggestions = asyncCategories.value ?? defaultCategories;

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(
          context,
          ref,
          null,
          modeSuggestions: modeSuggestions,
          categorySuggestions: categorySuggestions,
        ),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: _ModeFilter(
              current: filter,
              modes: modeSuggestions,
              onChanged: (mode) =>
                  ref.read(scheduleModeFilterProvider.notifier).setMode(mode),
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ScheduleItemCard(
                        item: item,
                        onEdit: () => _openForm(
                          context,
                          ref,
                          item,
                          modeSuggestions: modeSuggestions,
                          categorySuggestions: categorySuggestions,
                        ),
                        onDelete: () => _confirmDelete(context, ref, item),
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

    if (result == true && context.mounted) {
      await ref
          .read(scheduleRepositoryProvider)
          .softDeleteScheduleItem(item.id);
      if (!context.mounted) return;
      refreshMainProviders(ref);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Jadwal dinonaktifkan')));
    }
  }

  void _openForm(
    BuildContext context,
    WidgetRef ref,
    ScheduleItem? item, {
    required List<ScheduleModeOption> modeSuggestions,
    required List<String> categorySuggestions,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ScheduleFormSheet(
        item: item,
        initialMode: item == null
            ? ref.read(scheduleModeFilterProvider)
            : ScheduleModeOption.fromCode(item.scheduleMode),
        modeSuggestions: modeSuggestions,
        categorySuggestions: categorySuggestions,
        onSave: (draft) async {
          final repo = ref.read(scheduleRepositoryProvider);
          if (item == null) {
            await repo.createScheduleItem(
              title: draft.title,
              description: draft.description,
              startTime: draft.startTime,
              endTime: draft.endTime,
              category: draft.category,
              mode: draft.mode,
            );
          } else {
            await repo.updateScheduleItem(
              id: item.id,
              title: draft.title,
              description: draft.description,
              startTime: draft.startTime,
              endTime: draft.endTime,
              category: draft.category,
              mode: draft.mode,
              isActive: draft.isActive,
            );
          }
          if (!context.mounted) return;
          ref.read(scheduleModeFilterProvider.notifier).setMode(draft.mode);
          refreshMainProviders(ref);
        },
      ),
    );
  }
}

class _ModeFilter extends StatelessWidget {
  const _ModeFilter(
      {required this.current, required this.modes, required this.onChanged});

  final ScheduleModeOption current;
  final List<ScheduleModeOption> modes;
  final ValueChanged<ScheduleModeOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final allModes = [
      if (!modes.any((item) => item.code == current.code)) current,
      ...modes,
    ];

    return DropdownButtonFormField<String>(
      initialValue: current.code,
      decoration: const InputDecoration(
        labelText: 'Filter mode jadwal',
        prefixIcon: Icon(Icons.filter_alt_outlined),
      ),
      items: allModes
          .map((mode) =>
              DropdownMenuItem(value: mode.code, child: Text(mode.label)))
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        onChanged(allModes.firstWhere((mode) => mode.code == value));
      },
    );
  }
}

class _ScheduleItemCard extends StatelessWidget {
  const _ScheduleItemCard(
      {required this.item, required this.onEdit, required this.onDelete});

  final ScheduleItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(item.startTime,
                      style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Icon(Icons.keyboard_arrow_down,
                      size: 16, color: scheme.onPrimaryContainer),
                  const SizedBox(height: 2),
                  Text(item.endTime,
                      style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900)),
                  if (item.description != null &&
                      item.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.description!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CategoryBadge(label: item.category),
                      Chip(
                        avatar: const Icon(Icons.event_note, size: 16),
                        label: Text(
                            ScheduleModeOption.fromCode(item.scheduleMode)
                                .label),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Nonaktifkan')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleFormDraft {
  const ScheduleFormDraft({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.mode,
    required this.isActive,
  });

  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String category;
  final ScheduleModeOption mode;
  final bool isActive;
}

class ScheduleFormSheet extends StatefulWidget {
  const ScheduleFormSheet({
    super.key,
    this.item,
    required this.initialMode,
    required this.modeSuggestions,
    required this.categorySuggestions,
    required this.onSave,
  });

  final ScheduleItem? item;
  final ScheduleModeOption initialMode;
  final List<ScheduleModeOption> modeSuggestions;
  final List<String> categorySuggestions;
  final Future<void> Function(ScheduleFormDraft draft) onSave;

  @override
  State<ScheduleFormSheet> createState() => _ScheduleFormSheetState();
}

class _ScheduleFormSheetState extends State<ScheduleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _modeController;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late bool _isActive;
  bool _isSaving = false;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _categoryController =
        TextEditingController(text: item?.category ?? defaultCategories.first);
    _modeController = TextEditingController(text: widget.initialMode.label);
    _start = item == null
        ? const TimeOfDay(hour: 8, minute: 0)
        : AppTimeUtils.toTimeOfDay(item.startTime);
    _end = item == null
        ? const TimeOfDay(hour: 9, minute: 0)
        : AppTimeUtils.toTimeOfDay(item.endTime);
    _isActive = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _modeController.dispose();
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEdit ? 'Edit Jadwal' : 'Tambah Jadwal',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                  IconButton(
                      onPressed:
                          _isSaving ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: 'Nama kegiatan',
                    prefixIcon: Icon(Icons.task_alt_outlined)),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama kegiatan tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Catatan opsional',
                    prefixIcon: Icon(Icons.notes_outlined)),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () async => _pickTime(isStart: true),
                      icon: const Icon(Icons.schedule),
                      label:
                          Text('Mulai ${AppTimeUtils.fromTimeOfDay(_start)}'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () async => _pickTime(isStart: false),
                      icon: const Icon(Icons.schedule),
                      label:
                          Text('Selesai ${AppTimeUtils.fromTimeOfDay(_end)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                    labelText: 'Kategori custom',
                    prefixIcon: Icon(Icons.sell_outlined)),
                maxLength: 60,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Kategori tidak boleh kosong'
                    : null,
              ),
              _SuggestionChips(
                values: widget.categorySuggestions.take(10).toList(),
                onSelected: _isSaving
                    ? null
                    : (value) =>
                        setState(() => _categoryController.text = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _modeController,
                decoration: const InputDecoration(
                    labelText: 'Mode/hari jadwal',
                    prefixIcon: Icon(Icons.event_available_outlined)),
                maxLength: 30,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Mode jadwal tidak boleh kosong'
                    : null,
              ),
              _SuggestionChips(
                values:
                    widget.modeSuggestions.map((mode) => mode.label).toList(),
                onSelected: _isSaving
                    ? null
                    : (value) => setState(() => _modeController.text = value),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktif'),
                  value: _isActive,
                  onChanged: _isSaving
                      ? null
                      : (value) => setState(() => _isActive = value),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving
                      ? 'Menyimpan...'
                      : _isEdit
                          ? 'Simpan Perubahan'
                          : 'Simpan Jadwal'),
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
    if (!mounted || result == null) return;
    setState(() {
      if (isStart) {
        _start = result;
      } else {
        _end = result;
      }
    });
  }

  ScheduleModeOption _resolveMode() {
    final value = ScheduleModeOption.normalizeCustomCode(_modeController.text);
    for (final mode in widget.modeSuggestions) {
      if (mode.label.toLowerCase() == value.toLowerCase() ||
          mode.code.toLowerCase() == value.toLowerCase()) {
        return mode;
      }
    }
    return ScheduleModeOption(code: value, label: value);
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

    setState(() => _isSaving = true);
    final draft = ScheduleFormDraft(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: start,
      endTime: end,
      category: _categoryController.text.trim(),
      mode: _resolveMode(),
      isActive: _isActive,
    );

    try {
      await widget.onSave(draft);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_isEdit
                ? 'Jadwal berhasil diperbarui'
                : 'Jadwal berhasil ditambahkan')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan jadwal: $error')),
      );
    }
  }
}

class _SuggestionChips extends StatelessWidget {
  const _SuggestionChips({required this.values, required this.onSelected});

  final List<String> values;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: values.map((value) {
        return ActionChip(
          label: Text(value),
          onPressed: onSelected == null ? null : () => onSelected!(value),
        );
      }).toList(),
    );
  }
}
