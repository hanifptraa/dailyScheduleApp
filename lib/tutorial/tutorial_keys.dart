import 'package:flutter/material.dart';

class TutorialKeys {
  const TutorialKeys._();

  static final todayTab = GlobalKey(debugLabel: 'tutorialTodayTab');
  static final scheduleTab = GlobalKey(debugLabel: 'tutorialScheduleTab');
  static final statisticsTab = GlobalKey(debugLabel: 'tutorialStatisticsTab');
  static final historyTab = GlobalKey(debugLabel: 'tutorialHistoryTab');
  static final settingsTab = GlobalKey(debugLabel: 'tutorialSettingsTab');

  static final todayProgress = GlobalKey(debugLabel: 'tutorialTodayProgress');
  static final todayModePicker =
      GlobalKey(debugLabel: 'tutorialTodayModePicker');
  static final todayAgenda = GlobalKey(debugLabel: 'tutorialTodayAgenda');

  static final scheduleModeFilter =
      GlobalKey(debugLabel: 'tutorialScheduleModeFilter');
  static final scheduleModeManageButton =
      GlobalKey(debugLabel: 'tutorialScheduleModeManageButton');
  static final scheduleAddButton =
      GlobalKey(debugLabel: 'tutorialScheduleAddButton');
  static final scheduleCard = GlobalKey(debugLabel: 'tutorialScheduleCard');
  static final scheduleCardMenu =
      GlobalKey(debugLabel: 'tutorialScheduleCardMenu');

  static final settingsTutorialButton =
      GlobalKey(debugLabel: 'tutorialSettingsTutorialButton');
}
