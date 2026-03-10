import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/portfolio_data.dart';
import '../../models/ai_tool_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class AiSection extends StatelessWidget {
  final ValueNotifier<String> activeSectionNotifier;

  const AiSection({super.key, required this.activeSectionNotifier});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final padding = Responsive.horizontalPadding(context);

    // Dynamic grid sizing
    int crossCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.amber, size: 28),
              const SizedBox(width: 16),
              const Text(
                'AI Tools & Workflows',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),

          const SizedBox(height: 16),
          Text(
            'Leveraging the latest in AI to accelerate development, ensure code quality, and build scalable architectures instantly.',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 60),

          // Tools Grid
          ..._buildGrid(crossCount, isMobile),
        ],
      ),
    );
  }

  List<Widget> _buildGrid(int crossCount, bool isMobile) {
    final rows = <Widget>[];
    for (int i = 0; i < PortfolioData.aiTools.length; i += crossCount) {
      final rowItems = PortfolioData.aiTools.sublist(
        i,
        (i + crossCount).clamp(0, PortfolioData.aiTools.length),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SizedBox(
            height: isMobile ? 220 : 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...rowItems.asMap().entries.map((e) {
                  final idx = i + e.key;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: e.key < rowItems.length - 1 ? 24 : 0,
                      ),
                      child: _AiToolCard(
                        tool: e.value,
                        index: idx,
                        crossCount: crossCount,
                        activeSectionNotifier: activeSectionNotifier,
                      ),
                    ),
                  );
                }),
                // Fill empty spaces in the last row if needed
                if (rowItems.length < crossCount)
                  ...List.generate(
                    crossCount - rowItems.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index < (crossCount - rowItems.length - 1)
                              ? 24
                              : 0,
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return rows;
  }
}

class _AiToolCard extends StatefulWidget {
  final AiToolModel tool;
  final int index;
  final int crossCount;
  final ValueNotifier<String> activeSectionNotifier;

  const _AiToolCard({
    required this.tool,
    required this.index,
    required this.crossCount,
    required this.activeSectionNotifier,
  });

  @override
  State<_AiToolCard> createState() => _AiToolCardState();
}

class _AiToolCardState extends State<_AiToolCard> {
  bool _hovered = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _checkVisibility();
    widget.activeSectionNotifier.addListener(_checkVisibility);
  }

  @override
  void dispose() {
    widget.activeSectionNotifier.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    // If user reaches ai section, or scrolls past. We'll use 'skills', 'ai', 'contact' to trigger.
    final sec = widget.activeSectionNotifier.value;
    if ((sec == 'skills' || sec == 'ai' || sec == 'contact') && !_isVisible) {
      if (mounted) setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tool;

    // Convert hex string to color
    final colorValue = int.tryParse('0xFF${t.colorHex}') ?? 0xFFF59E0B;
    final accent = Color(colorValue);

    return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _hovered ? accent.withAlpha(150) : AppColors.borderLight,
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: accent.withAlpha(20),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Bottom right glow based on brand color
                  Positioned(
                    right: -40,
                    bottom: -40,
                    child: AnimatedOpacity(
                      opacity: _hovered ? 0.8 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accent.withAlpha(40),
                              blurRadius: 40,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: accent.withAlpha(20),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(t.icon, color: accent, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                t.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Expanded(
                          child: Text(
                            t.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.6,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(target: _isVisible ? 1 : 0)
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: (100 * (widget.index % widget.crossCount)).toInt()),
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOutBack,
          duration: 600.ms,
        );
  }
}
