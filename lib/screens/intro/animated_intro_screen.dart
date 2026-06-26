import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedIntroScreen extends StatefulWidget {
  const AnimatedIntroScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<AnimatedIntroScreen> createState() => _AnimatedIntroScreenState();
}

class _AnimatedIntroScreenState extends State<AnimatedIntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentOffset;
  Timer? _finishTimer;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    );
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.55, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1).animate(curve);
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.9, curve: Curves.easeOut),
    );
    _contentOffset = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.9, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
    _finishTimer = Timer(const Duration(milliseconds: 5500), _finish);
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    if (!mounted || _finished) return;
    _finished = true;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: const _ScheduleLogo(),
                  ),
                ),
                const SizedBox(height: 28),
                FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentOffset,
                    child: Column(
                      children: [
                        Text(
                          'Daily Schedule',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Atur hari. Jaga disiplin.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: scheme.primary,
                            backgroundColor: scheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleLogo extends StatelessWidget {
  const _ScheduleLogo();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 58,
            color: scheme.onPrimaryContainer,
          ),
          Positioned(
            right: 22,
            bottom: 22,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.primaryContainer, width: 3),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 16,
                color: scheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
