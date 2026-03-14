import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../models/experience_model.dart';
import '../../widgets/section_header.dart';
import '../../widgets/scroll_reveal.dart';

class ExperienceSection extends StatelessWidget {
  final ScrollController scrollController;
  const ExperienceSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.horizontalPadding(context);

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
            tag: 'MY JOURNEY',
            title: 'Experience',
            subtitle:
                'Professional history building Flutter products for agencies, startups & AI companies',
          ),
          const SizedBox(height: 50),
          ...PortfolioData.experiences.asMap().entries.map(
            (e) => Padding(
              padding: EdgeInsets.only(
                bottom: e.key == PortfolioData.experiences.length - 1 ? 0 : 28,
              ),
              child: _ExperienceCard(
                experience: e.value,
                index: e.key,
                isLast: e.key == PortfolioData.experiences.length - 1,
                scrollController: scrollController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final ExperienceModel experience;
  final int index;
  final bool isLast;
  final ScrollController scrollController;

  const _ExperienceCard({
    required this.experience,
    required this.index,
    required this.isLast,
    required this.scrollController,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  // Maps company to local asset image
  String? _companyAsset(String company) {
    if (company.toLowerCase().contains('deorwine')) return null; // no asset
    if (company.toLowerCase().contains('eravan')) return null;
    if (company.toLowerCase().contains('scale')) return 'assets/images/icon_ai_brain.png';
    return null;
  }

  Widget _companyLogo(ExperienceModel exp, bool isMobile) {
    final asset = _companyAsset(exp.company);
    if (asset != null) {
      return Image.asset(asset, width: 28, height: 28, fit: BoxFit.contain);
    }
    return Text(
      exp.logoEmoji ?? '🏢',
      style: const TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final exp = widget.experience;

    return ScrollReveal(
      scrollController: widget.scrollController,
      delay: widget.index * 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Timeline column (desktop only)
        if (!isMobile)
          SizedBox(
            width: 56,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withAlpha(80),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(20),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(child: _companyLogo(exp, isMobile)),
                ),
                if (!widget.isLast)
                  Container(
                    width: 2,
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withAlpha(120),
                          AppColors.border,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        if (!isMobile) const SizedBox(width: 16),

        // Card
        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _hovered
                    ? AppColors.cardHover
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _hovered
                      ? AppColors.gold.withAlpha(100)
                      : AppColors.border,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withAlpha(15),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // KEY FIX: don't expand vertically
                children: [
                  // Header: logo + role + company
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mobile: show logo inline
                      if (isMobile) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withAlpha(15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.gold.withAlpha(40)),
                          ),
                          child: _companyLogo(exp, isMobile),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp.role,
                              style: const TextStyle(
                                color: Color(0xFFF1F1F3),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Flexible(
                                  child: ShaderMask(
                                    shaderCallback: (b) =>
                                        AppColors.primaryGradient
                                            .createShader(b),
                                    child: Text(
                                      exp.company,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const Text(
                                  '  ·  ',
                                  style: TextStyle(
                                      color: Color(0xFF4B5563),
                                      fontSize: 13),
                                ),
                                Flexible(
                                  child: Text(
                                    exp.duration,
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (exp.isPresent) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.green.withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.green.withAlpha(60),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  color: AppColors.green, size: 6),
                              SizedBox(width: 6),
                              Text(
                                'Current',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bullet points
                  ...exp.points.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6, right: 10),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: AppColors.gold,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              p,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 13,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: exp.tags
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.gold.withAlpha(40),
                              ),
                            ),
                            child: Text(
                              t,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
