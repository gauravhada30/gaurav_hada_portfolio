import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';
import '../../widgets/scroll_reveal.dart';

class ContactSection extends StatelessWidget {
  final ScrollController scrollController;
  const ContactSection({super.key, required this.scrollController});

  static final _links = [
    (
      PortfolioData.email,
      Icons.email_outlined,
      'mailto:${PortfolioData.email}',
    ),
    (PortfolioData.phone, Icons.phone_outlined, 'tel:${PortfolioData.phone}'),
    (
      'linkedin.com/gaurav-hada',
      Icons.work_outline,
      PortfolioData.linkedIn,
    ),
    (
      'github.com/gauravhada30',
      Icons.code_rounded,
      PortfolioData.github,
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
            vertical: isMobile ? 70 : 100,
          ),
          color: AppColors.background,
          child: Column(
            children: [
              const SectionHeader(
                tag: 'GET IN TOUCH',
                title: "Let's Build Something",
                subtitle:
                    "Open for Flutter dev roles, startup opportunities, and freelance projects",
              ),
              const SizedBox(height: 50),

              // CTA Card with glow
              ScrollReveal(
                scrollController: scrollController,
                delay: 100,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 640),
                  padding: EdgeInsets.all(isMobile ? 28 : 44),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.gold.withAlpha(60)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(20),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Glowing icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withAlpha(80),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.handshake_rounded,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        "Ready to craft your next big app?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "From robust Flutter front-ends to scalable Firebase backends, "
                        "I bring aesthetic design and high-performance engineering together.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _SendEmailButton(
                          onTap: () => _launch('mailto:hadagaurav56@gmail.com')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 44),

              // Contact links
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _links.asMap().entries.map((e) => ScrollReveal(
                      scrollController: scrollController,
                      delay: e.key * 80,
                      child: _ContactCard(e.value),
                    )).toList(),
              ),
            ],
          ),
        ),

        // Footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              // Logo
              ShaderMask(
                shaderCallback: (b) =>
                    AppColors.primaryGradient.createShader(b),
                child: const Text(
                  'Gaurav Hada.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© ${DateTime.now().year} Gaurav Hada · Crafted with Flutter & AI-driven architecture',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              // Tech pills
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: ['Flutter', 'Firebase', 'Dart', 'GetX', 'Riverpod']
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
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

class _SendEmailButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SendEmailButton({required this.onTap});

  @override
  State<_SendEmailButton> createState() => _SendEmailButtonState();
}

class _SendEmailButtonState extends State<_SendEmailButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(100),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(50),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Send an Email',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform:
                    Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          transform: Matrix4.translationValues(0.0, _hovered ? -3.0 : 0.0, 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceLight : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered ? AppColors.gold.withAlpha(80) : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _hovered ? AppColors.gold : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: _hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 13,
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
