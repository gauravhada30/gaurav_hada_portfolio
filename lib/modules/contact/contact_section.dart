import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/section_header.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static const _links = [
    (
      'hadagaurav56@gmail.com',
      Icons.email_outlined,
      'mailto:hadagaurav56@gmail.com',
    ),
    ('+91-9001852825', Icons.phone_outlined, 'tel:+919001852825'),
    (
      'linkedin.com/in/gaurav-hada',
      Icons.work_outline,
      'https://linkedin.com/in/gaurav-hada',
    ),
    (
      'github.com/gauravhada30',
      Icons.code_rounded,
      'https://github.com/gauravhada30',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.horizontalPadding(context);

    return Column(
      children: [
        // Main contact section
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: isMobile ? 80 : 120,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.borderLight)),
          ),
          child: Column(
            children: [
              const SectionHeader(
                tag: 'GET IN TOUCH',
                title: "Let's Build Something",
                subtitle:
                    "Open for Flutter dev roles, startup opportunities, and freelance projects",
              ),
              const SizedBox(height: 60),

              // Elegant Call-To-Action Card
              Container(
                constraints: const BoxConstraints(maxWidth: 680),
                padding: EdgeInsets.all(isMobile ? 32 : 48),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.gold.withAlpha(40)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(10),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.handshake_rounded,
                        size: 36,
                        color: AppColors.amber,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Ready to craft your next big app?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "From robust Flutter front-ends to scalable Firebase backends, "
                      "I bring aesthetic design and high-performance engineering together.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),
                    GestureDetector(
                      onTap: () => _launch('mailto:hadagaurav56@gmail.com'),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkAccent,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkAccent.withAlpha(40),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Send an Email',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              const SizedBox(height: 50),

              // Contact links row/grid
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _links.map((l) => _ContactCard(l)).toList(),
              ),
            ],
          ),
        ),

        // Deep Footer
        Container(
          width: double.infinity,
          color: AppColors.darkAccent, // Dark charcoal footer
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gaurav',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.gold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Hada',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '© ${DateTime.now().year} Gaurav Hada. Crafted with Flutter & AI-driven architecture.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(150),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactCard extends StatefulWidget {
  final (String, IconData, String) data;
  const _ContactCard(this.data);

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final (label, icon, url) = widget.data;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launch(url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..translate(0.0, _hovered ? -3.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceLight : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.darkAccent : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.darkAccent.withAlpha(10),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _hovered
                    ? AppColors.darkAccent
                    : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: _hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
