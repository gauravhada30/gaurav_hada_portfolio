import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../models/project_model.dart';
import '../../widgets/section_header.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsSection extends StatelessWidget {
  final ValueNotifier<String> activeSectionNotifier;

  const ProjectsSection({super.key, required this.activeSectionNotifier});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final padding = Responsive.horizontalPadding(context);

    int cols = isMobile ? 1 : (isTablet ? 2 : 3);

    return Container(
      width: double.infinity,
      color: AppColors.surfaceLight,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: isMobile ? 80 : 120,
      ),
      child: Column(
        children: [
          const SectionHeader(
            tag: 'SELECTED WORK',
            title: 'Featured Projects',
            subtitle:
                'A selection of apps built focusing on performance, UI/UX, and scalability',
          ),
          const SizedBox(height: 60),
          _buildGrid(cols, isMobile),
        ],
      ),
    );
  }

  Widget _buildGrid(int cols, bool isMobile) {
    if (cols == 1) {
      return Column(
        children: PortfolioData.projects
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _ProjectCard(
                  project: e.value,
                  index: e.key,
                  activeSectionNotifier: activeSectionNotifier,
                ),
              ),
            )
            .toList(),
      );
    }

    final List<Widget> gridRows = [];
    for (int i = 0; i < PortfolioData.projects.length; i += cols) {
      final rowItems = PortfolioData.projects.sublist(
        i,
        (i + cols).clamp(0, PortfolioData.projects.length),
      );

      gridRows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SizedBox(
            height: isMobile ? 580 : 560,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...rowItems.asMap().entries.map((e) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: e.key < rowItems.length - 1 ? 24 : 0,
                      ),
                      child: _ProjectCard(
                        project: e.value,
                        index: i + e.key,
                        activeSectionNotifier: activeSectionNotifier,
                      ),
                    ),
                  );
                }),
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

    return Column(children: gridRows);
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;
  final ValueNotifier<String> activeSectionNotifier;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.activeSectionNotifier,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
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
    if ((widget.activeSectionNotifier.value == 'projects' ||
            widget.activeSectionNotifier.value == 'contact' ||
            widget.activeSectionNotifier.value == 'skills') &&
        !_isVisible) {
      if (mounted) setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;

    int colorValue = 0xFFD4AF37;
    try {
      if (p.accentColor.startsWith('0x')) {
        colorValue = int.parse(p.accentColor);
      }
    } catch (_) {}

    final accent = Color(colorValue);

    return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -8.0 : 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _hovered ? accent.withAlpha(50) : AppColors.border,
                width: 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: accent.withAlpha(20),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
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
              borderRadius: BorderRadius.circular(23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Container
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent.withAlpha(15), accent.withAlpha(5)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: _hovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          p.emoji,
                          style: const TextStyle(
                            fontSize: 80,
                            fontFamilyFallback: [
                              'Apple Color Emoji',
                              'Segoe UI Emoji',
                              'Noto Color Emoji',
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Divider(height: 1, color: AppColors.borderLight),

                  // Content Area
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Live Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (p.liveUrl != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withAlpha(15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.gold.withAlpha(30),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.outbound_rounded,
                                  color: AppColors.gold,
                                  size: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          p.description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),

                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: p.tags
                              .take(3)
                              .map((t) => _ProjectTag(t))
                              .toList(),
                        ),
                        const SizedBox(height: 24),

                        // View Code / Live Links
                        Row(
                          children: [
                            if (p.liveUrl != null)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: _ProjectButton(
                                    label: 'Live App',
                                    icon: Icons.outbound_rounded,
                                    onTap: () => _launchUrl(p.liveUrl!),
                                  ),
                                ),
                              ),
                            if (p.githubUrl != null)
                              Expanded(
                                child: _ProjectButton(
                                  label: 'Source',
                                  icon: Icons.code_rounded,
                                  onTap: () => _launchUrl(p.githubUrl!),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ProjectTag extends StatelessWidget {
  final String label;
  const _ProjectTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProjectButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ProjectButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ProjectButton> createState() => _ProjectButtonState();
}

class _ProjectButtonState extends State<_ProjectButton> {
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.darkAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.darkAccent : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _hovered ? Colors.white : AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? Colors.white : AppColors.textPrimary,
                  fontSize: 13,
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
