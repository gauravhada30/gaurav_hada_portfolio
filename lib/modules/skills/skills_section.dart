import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/section_header.dart';
import '../../widgets/scroll_reveal.dart';

class SkillsSection extends StatelessWidget {
  final ValueNotifier<String> activeSectionNotifier;
  final ScrollController scrollController;

  const SkillsSection({
    super.key,
    required this.activeSectionNotifier,
    required this.scrollController,
  });

  // Each category uses asset images where available, falls back to emoji
  static const _categories = [
    {
      'name': 'Flutter & Mobile',
      'assetIcon': 'assets/images/icon_flutter.png',
      'color': 0xFF54C5F8,
      'skills': [
        {'name': 'Flutter SDK', 'asset': 'assets/images/icon_flutter.png'},
        {'name': 'Dart', 'asset': ''},
        {'name': 'Android', 'asset': ''},
        {'name': 'iOS / Swift', 'asset': 'assets/images/icon_ios.png'},
        {'name': 'Material 3 UI', 'asset': ''},
        {'name': 'Platform Channels', 'asset': ''},
        {'name': 'Responsive Design', 'asset': ''},
      ],
    },
    {
      'name': 'Backend & Cloud',
      'assetIcon': 'assets/images/icon_firebase.png',
      'color': 0xFFFFCA28,
      'skills': [
        {'name': 'Firebase Auth', 'asset': 'assets/images/icon_firebase.png'},
        {'name': 'Cloud Firestore', 'asset': 'assets/images/icon_firebase.png'},
        {'name': 'FCM Push', 'asset': 'assets/images/icon_firebase.png'},
        {'name': 'REST APIs', 'asset': ''},
        {'name': 'Razorpay / Stripe', 'asset': ''},
        {'name': 'Crashlytics', 'asset': ''},
      ],
    },
    {
      'name': 'Architecture & State',
      'assetIcon': 'assets/images/icon_architecture.png',
      'color': 0xFF6366F1,
      'skills': [
        {'name': 'GetX', 'asset': ''},
        {'name': 'Riverpod', 'asset': ''},
        {'name': 'BLoC Pattern', 'asset': ''},
        {'name': 'Clean Architecture', 'asset': 'assets/images/icon_architecture.png'},
        {'name': 'MVVM / MVC', 'asset': ''},
        {'name': 'Dependency Injection', 'asset': ''},
      ],
    },
    {
      'name': 'DevOps & Tools',
      'assetIcon': 'assets/images/icon_devops.png',
      'color': 0xFF10B981,
      'skills': [
        {'name': 'Git & GitHub', 'asset': ''},
        {'name': 'GitHub Actions CI/CD', 'asset': 'assets/images/icon_devops.png'},
        {'name': 'Play Console', 'asset': 'assets/images/icon_play_store.png'},
        {'name': 'App Store Connect', 'asset': 'assets/images/icon_app_store.png'},
        {'name': 'Figma UI/UX', 'asset': 'assets/images/icon_figma.png'},
        {'name': 'Jira & Agile', 'asset': ''},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final padding = Responsive.horizontalPadding(context);
    final cols = isMobile ? 1 : (isTablet ? 2 : 2);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: isMobile ? 70 : 100,
      ),
      child: Column(
        children: [
          const SectionHeader(
            tag: 'TECH STACK',
            title: 'Skills & Technologies',
            subtitle:
                'End-to-end Flutter development across mobile, backend, and DevOps',
          ),
          const SizedBox(height: 50),
          _buildGrid(context, cols, isMobile),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, int cols, bool isMobile) {
    final rows = <Widget>[];
    for (int i = 0; i < _categories.length; i += cols) {
      final rowItems = _categories.sublist(
        i,
        (i + cols).clamp(0, _categories.length),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          // Only use IntrinsicHeight on desktop (multi-column) to equalise heights.
          // On mobile (single column) avoid it to prevent fixed-height overflow.
          child: isMobile
              ? Column(
                  children: rowItems.asMap().entries.map((e) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: e.key < rowItems.length - 1 ? 20 : 0,
                      ),
                      child: _SkillCard(
                        category: _categories[i + e.key],
                        index: i + e.key,
                        activeSectionNotifier: activeSectionNotifier,
                        scrollController: scrollController,
                      ),
                    );
                  }).toList(),
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...rowItems.asMap().entries.map((e) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: e.key < rowItems.length - 1 ? 20 : 0,
                              ),
                              child: _SkillCard(
                                category: _categories[i + e.key],
                                index: i + e.key,
                                activeSectionNotifier: activeSectionNotifier,
                                scrollController: scrollController,
                              ),
                            ),
                          )),
                      if (rowItems.length < cols)
                        ...List.generate(
                          cols - rowItems.length,
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
  final Map<String, dynamic> category;
  final int index;
  final ValueNotifier<String> activeSectionNotifier;
  final ScrollController scrollController;

  const _SkillCard({
    required this.category,
    required this.index,
    required this.activeSectionNotifier,
    required this.scrollController,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final accent = Color(cat['color'] as int);
    final skillsList = cat['skills'] as List<Map<String, String>>;
    final categoryAsset = cat['assetIcon'] as String? ?? '';

    return ScrollReveal(
      scrollController: widget.scrollController,
      delay: (widget.index % 2) * 80,
      child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _hovered ? AppColors.cardHover : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered ? accent.withAlpha(120) : AppColors.border,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: accent.withAlpha(25),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // KEY FIX: prevents overflow
              children: [
                // Card header with real asset image
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: categoryAsset.isNotEmpty
                          ? Image.asset(
                              categoryAsset,
                              width: 22,
                              height: 22,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Text(
                                cat['emoji'] as String? ?? '🔧',
                                style: const TextStyle(fontSize: 20),
                              ),
                            )
                          : Text(
                              cat['emoji'] as String? ?? '🔧',
                              style: const TextStyle(fontSize: 20),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cat['name'] as String,
                        style: TextStyle(
                          color: _hovered
                              ? const Color(0xFFF1F1F3)
                              : const Color(0xFFE5E7EB),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Skill chips with asset image
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skillsList.map((skill) {
                    return _SkillChip(
                      name: skill['name']!,
                      assetPath: skill['asset']!,
                      accent: accent,
                      parentHovered: _hovered,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class _SkillChip extends StatefulWidget {
  final String name;
  final String assetPath;
  final Color accent;
  final bool parentHovered;

  const _SkillChip({
    required this.name,
    required this.assetPath,
    required this.accent,
    required this.parentHovered,
  });

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
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _hovered ? widget.accent.withAlpha(20) : AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? widget.accent.withAlpha(80) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use asset image if provided, else accent-colored dot
            if (widget.assetPath.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.asset(
                  widget.assetPath,
                  width: 13,
                  height: 13,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.accent.withAlpha(180),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? widget.accent.withAlpha(200)
                        : const Color(0xFF4B5563),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Text(
              widget.name,
              style: TextStyle(
                color: _hovered ? widget.accent : const Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
