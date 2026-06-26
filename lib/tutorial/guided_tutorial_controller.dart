import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'guided_tutorial_step.dart';
import 'tutorial_keys.dart';

final guidedTutorialRequestProvider =
    NotifierProvider<GuidedTutorialRequestNotifier, int>(
  GuidedTutorialRequestNotifier.new,
);

class GuidedTutorialRequestNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void start() {
    state++;
  }
}

class GuidedTutorialController {
  GuidedTutorialController({
    required this.ref,
    required this.onChanged,
  });

  final WidgetRef ref;
  final VoidCallback onChanged;

  int currentIndex = 0;
  bool isActive = false;

  static final steps = <GuidedTutorialStep>[
    GuidedTutorialStep(
      title: 'Hari Ini',
      description:
          'Ini halaman utama untuk melihat agenda hari ini. Jadwal awal hanyalah contoh, jadi kamu bebas menyesuaikannya dengan rutinitasmu.',
      navigationIndex: 0,
      targetKey: TutorialKeys.todayTab,
    ),
    GuidedTutorialStep(
      title: 'Progress Harian',
      description:
          'Bagian ini menunjukkan berapa kegiatan yang sudah selesai dan persentase progress harianmu.',
      navigationIndex: 0,
      targetKey: TutorialKeys.todayProgress,
    ),
    GuidedTutorialStep(
      title: 'Mode Hari',
      description:
          'Mode hari bawaan bernama Daily Schedule (example), yaitu contoh jadwal pelajar muslim yang disiplin. Kamu bisa menggantinya atau membuat mode lain sesuai rutinitasmu.',
      navigationIndex: 0,
      targetKey: TutorialKeys.todayModePicker,
    ),
    GuidedTutorialStep(
      title: 'Agenda Checklist',
      description:
          'Centang kegiatan yang sudah selesai. Progress akan berubah otomatis dan tersimpan ke riwayat.',
      navigationIndex: 0,
      targetKey: TutorialKeys.todayAgenda,
    ),
    GuidedTutorialStep(
      title: 'Jadwal',
      description:
          'Di tab Jadwal, kamu bisa melihat agenda berdasarkan mode hari dan mengatur kegiatan yang aktif.',
      navigationIndex: 1,
      targetKey: TutorialKeys.scheduleTab,
    ),
    GuidedTutorialStep(
      title: 'Tambah Jadwal',
      description:
          'Tombol Tambah membuka pilihan tambah mode atau tambah jadwal. Di form jadwal, isi nama kegiatan, jam, kategori, mode hari, dan notifikasi. Tekan tahan kategori atau mode custom untuk menghapusnya.',
      navigationIndex: 1,
      targetKey: TutorialKeys.scheduleAddButton,
      preview: GuidedTutorialPreview.scheduleForm,
    ),
    GuidedTutorialStep(
      title: 'Edit / Nonaktifkan',
      description:
          'Gunakan menu titik tiga untuk mengedit atau menonaktifkan jadwal. Riwayat lama tetap aman meski jadwal berubah.',
      navigationIndex: 1,
      targetKey: TutorialKeys.scheduleCardMenu,
    ),
    GuidedTutorialStep(
      title: 'Statistik & Riwayat',
      description:
          'Statistik membantu mengevaluasi konsistensi, sedangkan Riwayat menyimpan progress hari sebelumnya. Tekan tahan riwayat jika perlu menghapus data pada tanggal tertentu.',
      navigationIndex: 2,
      targetKey: TutorialKeys.statisticsTab,
    ),
    GuidedTutorialStep(
      title: 'Setelan',
      description:
          'Di Setelan, kamu bisa mengatur tema, notifikasi, target tidur/bangun, reset jadwal, hapus checklist, dan membuka tutorial lagi.',
      navigationIndex: 4,
      targetKey: TutorialKeys.settingsTab,
    ),
  ];

  GuidedTutorialStep get currentStep => steps[currentIndex];
  bool get isFirstStep => currentIndex == 0;
  bool get isLastStep => currentIndex == steps.length - 1;

  Future<void> start() async {
    isActive = true;
    currentIndex = 0;
    await _syncNavigation();
    onChanged();
  }

  Future<void> next() async {
    if (!isActive || isLastStep) return;
    currentIndex++;
    await _syncNavigation();
    onChanged();
  }

  Future<void> previous() async {
    if (!isActive || isFirstStep) return;
    currentIndex--;
    await _syncNavigation();
    onChanged();
  }

  void stop() {
    isActive = false;
    onChanged();
  }

  Future<void> _syncNavigation() async {
    ref
        .read(navigationIndexProvider.notifier)
        .setIndex(currentStep.navigationIndex);
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
  }
}
