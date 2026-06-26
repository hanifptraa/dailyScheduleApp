import 'package:flutter/material.dart';

import 'guided_tutorial_step.dart';

class GuidedTutorialOverlay extends StatelessWidget {
  const GuidedTutorialOverlay({
    super.key,
    required this.step,
    required this.currentIndex,
    required this.totalSteps,
    required this.targetRect,
    required this.canGoPrevious,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
  });

  final GuidedTutorialStep step;
  final int currentIndex;
  final int totalSteps;
  final Rect? targetRect;
  final bool canGoPrevious;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bounds = Rect.fromLTWH(
              6,
              media.padding.top + 6,
              constraints.maxWidth - 12,
              constraints.maxHeight -
                  media.padding.top -
                  media.padding.bottom -
                  12,
            );
            final highlightedTarget = _fitTargetToBounds(targetRect, bounds);
            final tooltipWidth =
                constraints.maxWidth > 460 ? 420.0 : constraints.maxWidth - 32;
            final safeTop = media.padding.top + 16;
            final safeBottom = constraints.maxHeight - media.padding.bottom;
            final top = _tooltipTop(
              target: highlightedTarget,
              screenHeight: constraints.maxHeight,
              safeTop: safeTop,
              safeBottom: safeBottom,
            );
            final left = _tooltipLeft(
              target: highlightedTarget,
              screenWidth: constraints.maxWidth,
              tooltipWidth: tooltipWidth,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TutorialScrimPainter(
                      targetRect: highlightedTarget,
                      color: Colors.black.withValues(alpha: 0.66),
                    ),
                  ),
                ),
                if (highlightedTarget != null)
                  Positioned.fromRect(
                    rect: highlightedTarget,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: top,
                  left: left,
                  width: tooltipWidth,
                  child: _TutorialCard(
                    step: step,
                    currentIndex: currentIndex,
                    totalSteps: totalSteps,
                    canGoPrevious: canGoPrevious,
                    onNext: onNext,
                    onPrevious: onPrevious,
                    onSkip: onSkip,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Rect? _fitTargetToBounds(Rect? rect, Rect bounds) {
    if (rect == null || rect.isEmpty) return null;
    final fitted = rect.inflate(4).intersect(bounds);
    if (fitted.width <= 2 || fitted.height <= 2) return null;
    return fitted;
  }

  double _tooltipTop({
    required Rect? target,
    required double screenHeight,
    required double safeTop,
    required double safeBottom,
  }) {
    const estimatedHeight = 250.0;
    const gap = 14.0;
    if (target == null) return (screenHeight - estimatedHeight) / 2;

    final below = target.bottom + gap;
    if (below + estimatedHeight <= safeBottom) return below;

    final above = target.top - gap - estimatedHeight;
    if (above >= safeTop) return above;

    final fallback = safeBottom - estimatedHeight - 12;
    return fallback.clamp(safeTop, safeBottom - 80).toDouble();
  }

  double _tooltipLeft({
    required Rect? target,
    required double screenWidth,
    required double tooltipWidth,
  }) {
    final maxLeft =
        (screenWidth - tooltipWidth - 16).clamp(16, screenWidth).toDouble();
    if (target == null) {
      return ((screenWidth - tooltipWidth) / 2).clamp(16, maxLeft).toDouble();
    }
    final centered = target.center.dx - tooltipWidth / 2;
    return centered.clamp(16, maxLeft).toDouble();
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.step,
    required this.currentIndex,
    required this.totalSteps,
    required this.canGoPrevious,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
  });

  final GuidedTutorialStep step;
  final int currentIndex;
  final int totalSteps;
  final bool canGoPrevious;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 12,
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${currentIndex + 1}/$totalSteps',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onSkip,
                  child: const Text('Lewati'),
                ),
              ],
            ),
            if (step.preview != GuidedTutorialPreview.none) ...[
              const SizedBox(height: 12),
              _StepPreview(kind: step.preview),
            ],
            const SizedBox(height: 10),
            Text(
              step.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: canGoPrevious ? onPrevious : null,
                  child: const Text('Sebelumnya'),
                ),
                FilledButton(
                  onPressed: onNext,
                  child: const Text('Lanjut'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepPreview extends StatelessWidget {
  const _StepPreview({required this.kind});

  final GuidedTutorialPreview kind;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: switch (kind) {
        GuidedTutorialPreview.addDataMenu => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PreviewTile(
                icon: Icons.event_available_outlined,
                title: 'Tambah Hari / Mode Baru',
                subtitle: 'Buat pola jadwal baru.',
              ),
              SizedBox(height: 8),
              _PreviewTile(
                icon: Icons.playlist_add_outlined,
                title: 'Tambah Jadwal Baru',
                subtitle: 'Buat kegiatan pada mode terpilih.',
              ),
            ],
          ),
        GuidedTutorialPreview.scheduleForm => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PreviewField(
                  icon: Icons.task_alt_outlined, label: 'Nama kegiatan'),
              SizedBox(height: 6),
              _PreviewField(icon: Icons.schedule, label: 'Jam mulai & selesai'),
              SizedBox(height: 6),
              _PreviewField(icon: Icons.sell_outlined, label: 'Kategori'),
              SizedBox(height: 6),
              _PreviewField(
                  icon: Icons.event_note_outlined, label: 'Mode hari'),
              SizedBox(height: 6),
              _PreviewField(
                  icon: Icons.notifications_active_outlined,
                  label: 'Notifikasi'),
            ],
          ),
        GuidedTutorialPreview.none => const SizedBox.shrink(),
      },
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
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
      children: [
        Icon(icon, color: scheme.primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewField extends StatelessWidget {
  const _PreviewField({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _TutorialScrimPainter extends CustomPainter {
  const _TutorialScrimPainter({
    required this.targetRect,
    required this.color,
  });

  final Rect? targetRect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()..addRect(Offset.zero & size);
    final target = targetRect;
    if (target != null) {
      overlay.addRRect(
        RRect.fromRectAndRadius(target, const Radius.circular(12)),
      );
      overlay.fillType = PathFillType.evenOdd;
    }

    canvas.drawPath(overlay, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TutorialScrimPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect || oldDelegate.color != color;
  }
}
