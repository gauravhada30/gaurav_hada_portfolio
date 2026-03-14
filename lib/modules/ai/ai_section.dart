import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/section_header.dart';
import '../../widgets/scroll_reveal.dart';

class AiSection extends StatelessWidget {
  final ValueNotifier<String> activeSectionNotifier;
  final ScrollController scrollController;

  const AiSection({
    super.key,
    required this.activeSectionNotifier,
    required this.scrollController,
  });

  static const _tools = [
    {
      'name': 'Cursor IDE',
      'badge': 'Daily Driver',
      'badgeColor': 0xFF6366F1,
      'description':
          'AI-native code editor with codebase-wide context. I use Cursor for multi-file refactors, feature implementation, and live AI pair programming across all Flutter projects.',
      'capabilities': ['Codebase Indexing', 'Multi-file Edits', 'AI Chat', 'Tab Autocomplete'],
      'assetPath': 'assets/images/icon_cursor.png',
      'accent': 0xFF6366F1,
    },
    {
      'name': 'Claude 3.5 Sonnet',
      'badge': 'Architecture',
      'badgeColor': 0xFFD97757,
      'description':
          'Anthropic\'s Claude excels at complex reasoning tasks. I use it for architectural decisions, code review, UI generation from prompts, and complex Flutter widget design.',
      'capabilities': ['System Design', 'UI Generation', 'Code Review', 'Debugging'],
      'assetPath': 'assets/images/icon_claude.png',
      'accent': 0xFFD97757,
    },
    {
      'name': 'ChatGPT-4o',
      'badge': 'Problem Solving',
      'badgeColor': 0xFF10A37F,
      'description':
          'GPT-4o for algorithm design, state management patterns, and explaining complex Dart/Flutter internals. Excellent for researching best practices and edge cases.',
      'capabilities': ['Algorithm Design', 'GetX / BLoC Help', 'API Patterns', 'Documentation'],
      'assetPath': 'assets/images/icon_chatgpt.png',
      'accent': 0xFF10A37F,
    },
    {
      'name': 'GitHub Copilot',
      'badge': 'In-editor',
      'badgeColor': 0xFF1F6FEB,
      'description':
          'Inline AI suggestions directly in VS Code / Android Studio. Accelerates boilerplate, widget scaffolding, and repetitive patterns so I can focus on product-level logic.',
      'capabilities': ['Inline Suggestions', 'Boilerplate Gen', 'Comment-to-Code', 'Test Gen'],
      'assetPath': 'assets/images/icon_github_copilot.png',
      'accent': 0xFF1F6FEB,
    },
    {
      'name': 'Gemini Advanced',
      'badge': 'Google Ecosystem',
      'badgeColor': 0xFF4285F4,
      'description':
          'Google\'s multimodal AI — integrated with Android Studio, Firebase, and Google Cloud. Used for Firebase security rules generation and Play Console optimization.',
      'capabilities': ['Android Studio Bot', 'Firebase Rules', 'Cloud Integration', 'Multimodal'],
      'assetPath': 'assets/images/icon_gemini.png',
      'accent': 0xFF4285F4,
    },
    {
      'name': 'Antigravity',
      'badge': 'Autonomous',
      'badgeColor': 0xFFF59E0B,
      'description':
          'Fully autonomous agentic coding — executes multi-step repository-wide transformations, handles deployments, runs analysis, and writes entire features from a single prompt.',
      'capabilities': ['Autonomous Coding', 'Multi-step Tasks', 'Repo-wide Edits', 'CI/CD'],
      'assetPath': 'assets/images/icon_ai_brain.png',
      'accent': 0xFFF59E0B,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final padding = Responsive.horizontalPadding(context);
    final cols = isMobile ? 1 : (isTablet ? 2 : 3);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: isMobile ? 70 : 100,
      ),
      child: Column(
        children: [
          const SectionHeader(
            tag: 'AI POWERED',
            title: 'AI Tools & Workflows',
            subtitle:
                'How I leverage cutting-edge AI to ship production Flutter apps 5× faster',
          ),
          const SizedBox(height: 16),

          // AI stat ribbon
          _buildAiRibbon().animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),

          const SizedBox(height: 44),

          // Cards grid
          _buildGrid(cols, isMobile),
        ],
      ),
    );
  }

  Widget _buildAiRibbon() {
    final items = [
      {'emoji': '⚡', 'value': '5×', 'label': 'Faster Delivery'},
      {'emoji': '🤖', 'value': '6+', 'label': 'AI Tools Used Daily'},
      {'emoji': '📝', 'value': '1500+', 'label': 'AI Responses Evaluated'},
      {'emoji': '🏆', 'value': '30%', 'label': 'Model Quality Improved'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withAlpha(40)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return Wrap(
              spacing: 20,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: items.map(_buildRibbonItem).toList(),
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              return Expanded(
                child: Row(
                  children: [
                    _buildRibbonItem(item),
                    if (item != items.last)
                      Container(
                        width: 1,
                        height: 36,
                        margin: const EdgeInsets.only(left: 20),
                        color: AppColors.border,
                      ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildRibbonItem(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item['emoji']!, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                child: Text(
                  item['value']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                item['label']!,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(int cols, bool isMobile) {
    final rows = <Widget>[];
    for (int i = 0; i < _tools.length; i += cols) {
      final rowItems = _tools.sublist(
        i,
        (i + cols).clamp(0, _tools.length),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: isMobile
              ? Column(
                  children: rowItems.asMap().entries.map((e) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: e.key < rowItems.length - 1 ? 20 : 0,
                      ),
                      child: _AiToolCard(
                        tool: _tools[i + e.key],
                        index: i + e.key,
                        activeSectionNotifier: activeSectionNotifier,
                        scrollController: scrollController,
                      ),
                    );
                  }).toList(),
                )
              : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...rowItems.asMap().entries.map((e) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: e.key < rowItems.length - 1 ? 20 : 0,
                              ),
                              child: _AiToolCard(
                                tool: _tools[i + e.key],
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
      );
    }
    return Column(children: rows);
  }
}

class _AiToolCard extends StatefulWidget {
  final Map<String, dynamic> tool;
  final int index;
  final ValueNotifier<String> activeSectionNotifier;
  final ScrollController scrollController;

  const _AiToolCard({
    required this.tool,
    required this.index,
    required this.activeSectionNotifier,
    required this.scrollController,
  });

  @override
  State<_AiToolCard> createState() => _AiToolCardState();
}

class _AiToolCardState extends State<_AiToolCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.tool;
    final accent = Color(t['accent'] as int);
    final badge = t['badge'] as String;
    final badgeColor = Color(t['badgeColor'] as int);
    final caps = t['capabilities'] as List<String>;

    return ScrollReveal(
      scrollController: widget.scrollController,
      delay: (widget.index % 3) * 80,
      child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _hovered ? AppColors.cardHover : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered ? accent.withAlpha(120) : AppColors.border,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: accent.withAlpha(30),
                          blurRadius: 28,
                          offset: const Offset(0, 12))
                    ]
                  : [
                      BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        t['assetPath'] as String,
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.smart_toy_rounded,
                          color: accent,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['name'] as String,
                            style: const TextStyle(
                              color: Color(0xFFF1F1F3),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: badgeColor.withAlpha(60)),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  t['description'] as String,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 12),

                // Capabilities
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: caps.map((cap) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withAlpha(15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: accent.withAlpha(40)),
                      ),
                      child: Text(
                        cap,
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
