import 'package:flutter/material.dart';

/// A widget that reveals its child with an animation as soon as it
/// enters the visible viewport. Much faster than VisibilityDetector
/// because it checks RenderObject position directly on every scroll tick.
///
/// Usage:
/// ```dart
/// ScrollReveal(
///   scrollController: _scrollController,
///   child: MyCard(),
/// )
/// ```
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  /// How far below the viewport bottom the widget must enter before animating.
  /// Negative = widget enters from below, triggers when [offsetTrigger]px still
  /// below the fold. 0 = trigger exactly when edge enters viewport.
  final double offsetTrigger;

  /// Stagger delay per item in a list. Pass [index] and a base [staggerMs] to
  /// auto-calculate the delay.
  final int delay;

  /// Animation style
  final ScrollRevealStyle style;

  const ScrollReveal({
    super.key,
    required this.child,
    required this.scrollController,
    this.offsetTrigger = 80,
    this.delay = 0,
    this.style = ScrollRevealStyle.fadeSlideUp,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

enum ScrollRevealStyle {
  fadeSlideUp,
  fadeSlideLeft,
  fadeSlideRight,
  fadeScale,
  fadeSlideDown,
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    final slideBegin = switch (widget.style) {
      ScrollRevealStyle.fadeSlideUp => const Offset(0, 0.18),
      ScrollRevealStyle.fadeSlideDown => const Offset(0, -0.18),
      ScrollRevealStyle.fadeSlideLeft => const Offset(0.18, 0),
      ScrollRevealStyle.fadeSlideRight => const Offset(-0.18, 0),
      ScrollRevealStyle.fadeScale => Offset.zero,
    };

    _slide = Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );

    _scale = Tween<double>(
      begin: widget.style == ScrollRevealStyle.fadeScale ? 0.92 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    // Attach scroll listener
    widget.scrollController.addListener(_onScroll);

    // Also check immediately (element may already be visible on load)
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_revealed || !mounted) return;
    final ro = context.findRenderObject();
    if (ro == null || ro is! RenderBox || !ro.hasSize) return;
    final pos = ro.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;

    // Trigger when the top edge of the widget is within [screenH + offsetTrigger] from top
    if (pos.dy < screenH + widget.offsetTrigger) {
      setState(() => _revealed = true);
      if (widget.delay > 0) {
        Future.delayed(Duration(milliseconds: widget.delay), () {
          if (mounted) _ctrl.forward();
        });
      } else {
        _ctrl.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}
