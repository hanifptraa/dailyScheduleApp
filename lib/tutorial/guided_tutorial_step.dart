import 'package:flutter/material.dart';

enum GuidedTutorialPreview { none, addDataMenu, scheduleForm }

class GuidedTutorialStep {
  const GuidedTutorialStep({
    required this.title,
    required this.description,
    required this.navigationIndex,
    this.targetKey,
    this.preview = GuidedTutorialPreview.none,
  });

  final String title;
  final String description;
  final int navigationIndex;
  final GlobalKey? targetKey;
  final GuidedTutorialPreview preview;
}
