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
          _ModeFilterBar(
            current: filter,
            modes: modeSuggestions,
            onChanged: (mode) =>
                ref.read(scheduleModeFilterProvider.notifier).setMode(mode),
            onManage: () => _openModeManager(
              context,
              ref,
              current: filter,
              modes: modeSuggestions,
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

  void _openModeManager(
    BuildContext context,
    WidgetRef ref, {
    required ScheduleModeOption current,
    required List<ScheduleModeOption> modes,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (sheetContext) => _ModeManagerSheet(
        modes: modes,
        onRename: (mode) async {
          await _renameMode(context, ref, mode);
          if (sheetContext.mounted) Navigator.pop(sheetContext);
        },
        onDelete: (mode) async {
          await _deleteMode(context, ref, mode, current);
          if (sheetContext.mounted) Navigator.pop(sheetContext);
        },
      ),
    );
  }

  Future<void> _renameMode(
      BuildContext context, WidgetRef ref, ScheduleModeOption mode) async {
    final controller = TextEditingController(text: mode.label);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah nama hari'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 30,
          decoration: const InputDecoration(labelText: 'Nama hari/mode'),
        ),
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

    if (result == null || result.isEmpty || !context.mounted) return;
    final newMode = ScheduleModeOption(code: result, label: result);
    await ref
        .read(scheduleRepositoryProvider)
        .renameScheduleMode(oldMode: mode, newMode: newMode);
    if (!context.mounted) return;
    ref.read(scheduleModeFilterProvider.notifier).setMode(newMode);
    refreshMainProviders(ref);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Nama hari diperbarui')));
  }

  Future<void> _deleteMode(BuildContext context, WidgetRef ref,
      ScheduleModeOption mode, ScheduleModeOption current) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus mode hari?'),
        content: Text(
            'Semua jadwal aktif pada "${mode.label}" akan dinonaktifkan. Riwayat lama tetap tersimpan.'),
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

    if (result != true || !context.mounted) return;
    await ref.read(scheduleRepositoryProvider).deleteScheduleMode(mode);
    if (!context.mounted) return;
    if (current.code == mode.code) {
      ref
          .read(scheduleModeFilterProvider.notifier)
          .setMode(ScheduleModeOption.regular);
    }
    refreshMainProviders(ref);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Mode hari dihapus')));
  }
}

class _ModeFilterBar extends StatelessWidget {
  const _ModeFilterBar({
    required this.current,
    required this.modes,
    required this.onChanged,
    required this.onManage,
  });

  final ScheduleModeOption current;
  final List<ScheduleModeOption> modes;
  final ValueChanged<ScheduleModeOption> onChanged;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final allModes = [
      if (!modes.any((item) => item.code == current.code)) current,
      ...modes,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final mode in allModes) ...[
                    ChoiceChip(
                      label: Text(mode.label),
                      selected: mode.code == current.code,
                      onSelected: (_) => onChanged(mode),
                      avatar: Icon(
                        mode.code == current.code
                            ? Icons.check_circle
                            : Icons.event_note_outlined,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Kelola mode hari',
            onPressed: onManage,
            icon: const Icon(Icons.edit_calendar_outlined),
          ),
        ],
      ),
    );
  }
}

class _ModeManagerSheet extends StatelessWidget {
  const _ModeManagerSheet({
    required this.modes,
    required this.onRename,
    required this.onDelete,
  });

  final List<ScheduleModeOption> modes;
  final ValueChanged<ScheduleModeOption> onRename;
  final ValueChanged<ScheduleModeOption> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kelola Mode Hari',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            'Ubah nama atau hapus mode hari yang sudah tidak dipakai.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          for (final mode in modes)
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_note_outlined),
                title: Text(mode.label,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: 'Ubah nama',
                      onPressed: () => onRename(mode),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'Hapus mode hari',
                      onPressed: () => onDelete(mode),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
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
                  CategoryBadges(value: item.category),
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
  late final List<String> _selectedCategories;
  bool _isSaving = false;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _categoryController = TextEditingController();
    _modeController = TextEditingController(text: widget.initialMode.label);
    _selectedCategories =
        parseCategories(item?.category ?? defaultCategories.first);
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
    final scheme = Theme.of(context).colorScheme;

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
              const SizedBox(height: 6),
              Text(
                'Isi bagian jadwal untuk kegiatan dan waktu. Bagian mode hari dipakai untuk membuat atau memilih nama hari seperti Hari Biasa, Hari Basket, atau nama custom lain.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              _SectionLabel(
                icon: Icons.task_alt_outlined,
                title: 'Tambah jadwal / kegiatan',
                subtitle:
                    'Nama aktivitas, catatan, jam mulai, dan jam selesai.',
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 18),
              _SectionLabel(
                icon: Icons.sell_outlined,
                title: 'Kategori',
                subtitle:
                    'Pilih maksimal $maxCategoriesPerSchedule kategori. Nama custom maksimal $maxCategoryNameLength karakter.',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Kategori custom',
                        prefixIcon: Icon(Icons.sell_outlined),
                      ),
                      maxLength: maxCategoryNameLength,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Tambah kategori custom',
                    onPressed: _isSaving ? null : _addCustomCategory,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              _CategoryChoiceChips(
                values: widget.categorySuggestions.take(12).toList(),
                selected: _selectedCategories,
                onSelected: _isSaving ? null : _toggleCategory,
              ),
              const SizedBox(height: 18),
              _SectionLabel(
                icon: Icons.event_available_outlined,
                title: 'Tambah hari / mode jadwal',
                subtitle:
                    'Pilih mode yang sudah ada atau ketik nama baru untuk membuat hari lain.',
              ),
              const SizedBox(height: 10),
              _ModeChoiceChips(
                modes: widget.modeSuggestions,
                currentLabel: _modeController.text,
                onSelected: _isSaving
                    ? null
                    : (value) => setState(() => _modeController.text = value),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _modeController,
                decoration: const InputDecoration(
                    labelText: 'Nama hari/mode custom',
                    prefixIcon: Icon(Icons.event_available_outlined)),
                maxLength: 30,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Mode jadwal tidak boleh kosong'
                    : null,
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

  void _toggleCategory(String value) {
    final category = normalizeCategoryName(value);
    if (category.isEmpty) return;
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else if (_selectedCategories.length < maxCategoriesPerSchedule) {
        _selectedCategories.add(category);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Maksimal $maxCategoriesPerSchedule kategori per jadwal')));
      }
    });
  }

  void _addCustomCategory() {
    final category = normalizeCategoryName(_categoryController.text);
    if (category.isEmpty) return;
    _toggleCategory(category);
    _categoryController.clear();
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
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih minimal satu kategori')));
      return;
    }
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
      category: encodeCategories(_selectedCategories),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: scheme.primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChoiceChips extends StatelessWidget {
  const _CategoryChoiceChips({
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final List<String> values;
  final List<String> selected;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (values.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: values.map((value) {
        final isSelected = selected.contains(value);
        return FilterChip(
          label: Text(value),
          selected: isSelected,
          onSelected: onSelected == null ? null : (_) => onSelected!(value),
          selectedColor: scheme.primaryContainer,
          checkmarkColor: scheme.onPrimaryContainer,
          labelStyle: TextStyle(
            color: isSelected ? scheme.onPrimaryContainer : null,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}

class _ModeChoiceChips extends StatelessWidget {
  const _ModeChoiceChips({
    required this.modes,
    required this.currentLabel,
    required this.onSelected,
  });

  final List<ScheduleModeOption> modes;
  final String currentLabel;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: modes.map((mode) {
        final selected = mode.label.toLowerCase() == currentLabel.toLowerCase();
        return ChoiceChip(
          label: Text(mode.label),
          selected: selected,
          onSelected:
              onSelected == null ? null : (_) => onSelected!(mode.label),
          selectedColor: scheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected ? scheme.onPrimaryContainer : null,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}
