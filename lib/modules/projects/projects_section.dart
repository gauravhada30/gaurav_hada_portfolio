import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../models/project_model.dart';
import '../../widgets/section_header.dart';

import '../../widgets/scroll_reveal.dart';

class ProjectsSection extends StatelessWidget {
  final ValueNotifier<String> activeSectionNotifier;
  final ScrollController scrollController;

  const ProjectsSection({
    super.key,
    required this.activeSectionNotifier,
    required this.scrollController,
  });

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
            tag: 'SELECTED WORK',
            title: 'Featured Projects',
            subtitle:
                'Production-grade Flutter apps spanning e-commerce, iOS/Android, EdTech, and IoT',
          ),
          const SizedBox(height: 50),
          _buildGrid(cols, isMobile),
        ],
      ),
    );
  }

  Widget _buildGrid(int cols, bool isMobile) {
    final rows = <Widget>[];
    for (int i = 0; i < PortfolioData.projects.length; i += cols) {
      final rowItems = PortfolioData.projects.sublist(
        i,
        (i + cols).clamp(0, PortfolioData.projects.length),
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
                      child: _ProjectCard(
                        project: e.value,
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
                              child: _ProjectCard(
                                project: e.value,
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

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;
  final ValueNotifier<String> activeSectionNotifier;
  final ScrollController scrollController;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.activeSectionNotifier,
    required this.scrollController,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final colorHex = p.accentColor.contains('0x')
        ? p.accentColor
        : '0xFF${p.accentColor}';
    final accent = Color(int.tryParse(colorHex) ?? 0xFFD4AF37);

    return ScrollReveal(
      scrollController: widget.scrollController,
      delay: (widget.index % 3) * 80,
      child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
            decoration: BoxDecoration(
              color: _hovered ? AppColors.cardHover : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered ? accent.withAlpha(100) : AppColors.border,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: accent.withAlpha(30),
                        blurRadius: 28,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project image area
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withAlpha(40),
                          accent.withAlpha(10),
                          AppColors.surfaceLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Grid lines
                        Positioned.fill(
                          child: CustomPaint(painter: _GridPainter()),
                        ),
                        Center(
                          child: AnimatedScale(
                            scale: _hovered ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              p.emoji,
                              style: const TextStyle(
                                fontSize: 64,
                                fontFamilyFallback: [
                                  'Apple Color Emoji',
                                  'Segoe UI Emoji',
                                  'Noto Color Emoji',
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Badges
                        Positioned(
                          top: 12,
                          left: 12,
                          child: _PlatformBadge(p.tags),
                        ),
                        if (p.liveUrl != null)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: _LiveBadge(accent),
                          ),
                      ],
                    ),
                  ),

                  // Card content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: const TextStyle(
                            color: Color(0xFFF1F1F3),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.subtitle,
                          style: TextStyle(
                            color: accent.withAlpha(200),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p.description,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: p.tags
                              .take(4)
                              .map((t) => _Tag(t, accent))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (p.liveUrl != null) ...[
                              Expanded(
                                child: _ActionButton(
                                  label: 'View Live',
                                  icon: Icons.open_in_new_rounded,
                                  filled: true,
                                  accent: accent,
                                  onTap: () => _launch(p.liveUrl!),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (p.githubUrl != null)
                              Expanded(
                                child: _ActionButton(
                                  label: 'GitHub',
                                  icon: Icons.code_rounded,
                                  filled: false,
                                  accent: accent,
                                  onTap: () => _launch(p.githubUrl!),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _PlatformBadge extends StatelessWidget {
  final List<String> tags;
  const _PlatformBadge(this.tags);

  @override
  Widget build(BuildContext context) {
    // Show Flutter/Android/iOS if present
    final platformTags = tags
        .where((t) =>
            t.toLowerCase().contains('flutter') ||
            t.toLowerCase().contains('android') ||
            t.toLowerCase().contains('ios'))
        .take(2)
        .toList();
    if (platformTags.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: platformTags.map((t) {
        return Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(120),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            t,
            style: const TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  final Color accent;
  const _LiveBadge(this.accent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text('Live',
              style: TextStyle(
                  color: accent, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color accent;
  const _Tag(this.label, this.accent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final Color accent;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered ? widget.accent : widget.accent.withAlpha(30))
                : (_hovered ? AppColors.surfaceLight : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.filled
                  ? widget.accent.withAlpha(80)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: widget.filled
                    ? (_hovered ? Colors.black87 : widget.accent)
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.filled
                      ? (_hovered ? Colors.black87 : widget.accent)
                      : const Color(0xFF9CA3AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2A3E).withAlpha(60)
      ..strokeWidth = 0.5;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
