import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/app_providers.dart';
import 'screens/intro/animated_intro_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/schedule_management/schedule_management_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/statistics/statistics_screen.dart';
import 'screens/today/today_screen.dart';
import 'theme/app_theme.dart';
import 'tutorial/guided_tutorial_controller.dart';
import 'tutorial/guided_tutorial_overlay.dart';
import 'tutorial/tutorial_keys.dart';

class DailyScheduleApp extends ConsumerWidget {
  const DailyScheduleApp({super.key, this.initialThemeMode = ThemeMode.light});

  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).value ?? initialThemeMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Schedule',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const AnimatedIntroGate(),
    );
  }
}

class AnimatedIntroGate extends StatefulWidget {
  const AnimatedIntroGate({super.key});

  @override
  State<AnimatedIntroGate> createState() => _AnimatedIntroGateState();
}

class _AnimatedIntroGateState extends State<AnimatedIntroGate> {
  var _showIntro = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _showIntro
          ? AnimatedIntroScreen(
              key: const ValueKey('animated-intro'),
              onFinished: () {
                if (!mounted) return;
                setState(() => _showIntro = false);
              },
            )
          : const AppShell(key: ValueKey('app-shell')),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const _screens = [
    TodayScreen(),
    ScheduleManagementScreen(),
    StatisticsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  late final GuidedTutorialController _tutorialController;
  Rect? _targetRect;
  var _promptChecked = false;
  var _isPromptShowing = false;

  @override
  void initState() {
    super.initState();
    _tutorialController = GuidedTutorialController(
      ref: ref,
      onChanged: _onTutorialChanged,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowTutorialPrompt();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(guidedTutorialRequestProvider, (previous, next) {
      if (previous == null || next == previous) return;
      _startTutorial();
    });

    final index = ref.watch(navigationIndexProvider);
    final isTutorialActive = _tutorialController.isActive;

    return PopScope(
      canPop: !isTutorialActive,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _tutorialController.isActive) {
          _confirmSkipTutorial();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: IndexedStack(index: index, children: _screens),
            bottomNavigationBar: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: isTutorialActive
                  ? null
                  : (value) => ref
                      .read(navigationIndexProvider.notifier)
                      .setIndex(value),
              destinations: [
                NavigationDestination(
                  key: TutorialKeys.todayTab,
                  icon: const Icon(Icons.today_outlined),
                  selectedIcon: const Icon(Icons.today),
                  label: 'Hari Ini',
                ),
                NavigationDestination(
                  key: TutorialKeys.scheduleTab,
                  icon: const Icon(Icons.view_timeline_outlined),
                  selectedIcon: const Icon(Icons.view_timeline),
                  label: 'Jadwal',
                ),
                NavigationDestination(
                  key: TutorialKeys.statisticsTab,
                  icon: const Icon(Icons.insights_outlined),
                  selectedIcon: const Icon(Icons.insights),
                  label: 'Statistik',
                ),
                NavigationDestination(
                  key: TutorialKeys.historyTab,
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history),
                  label: 'Riwayat',
                ),
                NavigationDestination(
                  key: TutorialKeys.settingsTab,
                  icon: const Icon(Icons.tune_outlined),
                  selectedIcon: const Icon(Icons.tune),
                  label: 'Setelan',
                ),
              ],
            ),
          ),
          if (isTutorialActive)
            GuidedTutorialOverlay(
              step: _tutorialController.currentStep,
              currentIndex: _tutorialController.currentIndex,
              totalSteps: GuidedTutorialController.steps.length,
              targetRect: _targetRect,
              canGoPrevious: !_tutorialController.isFirstStep,
              onNext: _handleTutorialNext,
              onPrevious: _handleTutorialPrevious,
              onSkip: _confirmSkipTutorial,
            ),
        ],
      ),
    );
  }

  Future<void> _maybeShowTutorialPrompt() async {
    if (_promptChecked || _isPromptShowing || !mounted) return;
    _promptChecked = true;
    final completed =
        await ref.read(scheduleRepositoryProvider).isGuidedTutorialCompleted();
    if (completed || !mounted) return;

    _isPromptShowing = true;
    final shouldStart = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mau lihat tutorial singkat?'),
        content: const Text(
          'Tutorial ini akan menunjukkan cara memakai fitur utama aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Lewati'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Mulai Tutorial'),
          ),
        ],
      ),
    );
    _isPromptShowing = false;
    if (!mounted) return;

    if (shouldStart == true) {
      await _startTutorial();
    } else if (shouldStart == false) {
      final confirmed = await _showSkipConfirmation();
      if (confirmed) {
        await ref.read(scheduleRepositoryProvider).completeGuidedTutorial();
        ref.invalidate(settingsProvider);
      } else if (mounted) {
        _promptChecked = false;
        await _maybeShowTutorialPrompt();
      }
    }
  }

  Future<void> _startTutorial() async {
    if (!mounted) return;
    await _tutorialController.start();
    await _refreshTargetRect();
  }

  Future<void> _handleTutorialNext() async {
    if (_tutorialController.isLastStep) {
      await _finishTutorial();
      return;
    }
    await _tutorialController.next();
    await _refreshTargetRect();
  }

  Future<void> _handleTutorialPrevious() async {
    await _tutorialController.previous();
    await _refreshTargetRect();
  }

  Future<void> _finishTutorial() async {
    if (!mounted) return;
    final done = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tutorial selesai'),
        content: const Text(
          'Sekarang kamu sudah tahu cara memakai fitur utama aplikasi.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Mulai Pakai App'),
          ),
        ],
      ),
    );
    if (done != true || !mounted) return;
    await ref.read(scheduleRepositoryProvider).completeGuidedTutorial();
    ref.invalidate(settingsProvider);
    _tutorialController.stop();
  }

  Future<void> _confirmSkipTutorial() async {
    final confirmed = await _showSkipConfirmation();
    if (!confirmed || !mounted) return;
    await ref.read(scheduleRepositoryProvider).completeGuidedTutorial();
    ref.invalidate(settingsProvider);
    _tutorialController.stop();
  }

  Future<bool> _showSkipConfirmation() async {
    if (!mounted) return false;
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Lewati tutorial?'),
            content: const Text(
              'Kamu masih bisa membuka tutorial lagi dari Setelan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Lewati Tutorial'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _onTutorialChanged() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTargetRect();
    });
  }

  Future<void> _refreshTargetRect() async {
    if (!_tutorialController.isActive || !mounted) return;

    Rect? rect;
    for (var attempt = 0; attempt < 8; attempt++) {
      rect = _readTargetRect(_tutorialController.currentStep.targetKey);
      if (rect != null) break;
      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(const Duration(milliseconds: 40));
      if (!_tutorialController.isActive || !mounted) return;
    }

    if (!mounted) return;
    setState(() => _targetRect = rect);
  }

  Rect? _readTargetRect(GlobalKey? key) {
    final context = key?.currentContext;
    if (context == null) return null;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;
    final offset = renderObject.localToGlobal(Offset.zero);
    return offset & renderObject.size;
  }
}
