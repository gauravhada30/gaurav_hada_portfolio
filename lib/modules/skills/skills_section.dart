import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsSection extends StatelessWidget {
  final ValueNotifier<String> activeSectionNotifier;

  const SkillsSection({super.key, required this.activeSectionNotifier});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final padding = Responsive.horizontalPadding(context);

    int crossCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return Container(
      width: double.infinity,
      color: AppColors.surfaceLight,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: isMobile ? 80 : 0,
      ),
      child: Column(
        children: [
          const SectionHeader(
            tag: 'TECH STACK',
            title: 'Technical Skills',
            subtitle:
                'Core competencies across front-end, back-end, and design components',
          ),
          const SizedBox(height: 60),
          _buildGrid(crossCount, isMobile),
        ],
      ),
    );
  }

  Widget _buildGrid(int crossCount, bool isMobile) {
    if (crossCount == 1) {
      return Column(
        children: PortfolioData.skills
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _SkillCard(
                  category: e.value,
                  index: e.key,
                  activeSectionNotifier: activeSectionNotifier,
                ),
              ),
            )
            .toList(),
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < PortfolioData.skills.length; i += crossCount) {
      final rowItems = PortfolioData.skills.sublist(
        i,
        (i + crossCount).clamp(0, PortfolioData.skills.length),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            height: isMobile ? 600 : 540,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...rowItems.asMap().entries.map((e) {
                  final idx = i + e.key;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: e.key < rowItems.length - 1 ? 20 : 0,
                      ),
                      child: _SkillCard(
                        category: e.value,
                        index: idx,
                        activeSectionNotifier: activeSectionNotifier,
                      ),
                    ),
                  );
                }),
                if (rowItems.length < crossCount)
                  ...List.generate(
                    crossCount - rowItems.length,
                    (_) => const Expanded(child: SizedBox()),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _SkillCard extends StatefulWidget {
  final dynamic category;
  final int index;
  final ValueNotifier<String> activeSectionNotifier;

  const _SkillCard({
    required this.category,
    required this.index,
    required this.activeSectionNotifier,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
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
    if ((widget.activeSectionNotifier.value == 'skills' ||
            widget.activeSectionNotifier.value == 'contact') &&
        !_isVisible) {
      if (mounted) setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;

    return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -5.0 : 0.0),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? AppColors.gold.withAlpha(80)
                    : AppColors.border,
                width: 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(10),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Text(
                        cat.emoji ?? '⭐',
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamilyFallback: [
                            'Apple Color Emoji',
                            'Segoe UI Emoji',
                            'Noto Color Emoji',
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        cat.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: (cat.skills as List)
                      .map<Widget>((skill) => _SkillChip(skill as String))
                      .toList(),
                ),
              ],
            ),
          ),
        )
        .animate(target: _isVisible ? 1 : 0)
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: 100 * (widget.index % 3)),
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOutBack,
          duration: 600.ms,
        )
        .blurXY(begin: 10, end: 0, duration: 500.ms)
        .slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }
}

class _SkillChip extends StatefulWidget {
  final String label;
  const _SkillChip(this.label);

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.darkAccent : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? AppColors.darkAccent : AppColors.border,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hovered ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
