import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';
import '../../widgets/scroll_reveal.dart';

class AboutSection extends StatelessWidget {
  final ScrollController scrollController;
  const AboutSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.horizontalPadding(context);

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
            tag: 'WHO I AM',
            title: 'About Me',
            subtitle:
                'Flutter Developer · Firebase Architect · AI-Augmented Developer',
          ),
          const SizedBox(height: 50),
          isMobile ? _buildMobile(context) : _buildDesktop(context),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildBio()),
        const SizedBox(width: 60),
        Expanded(flex: 5, child: _buildRightCol()),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        _buildBio(),
        const SizedBox(height: 40),
        _buildRightCol(),
      ],
    );
  }

  Widget _buildBio() {
    return ScrollReveal(
      scrollController: scrollController,
      delay: 50,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Short intro with highlight
        RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 15,
              height: 1.85,
            ),
            children: [
              TextSpan(text: 'I\'m a passionate '),
              TextSpan(
                text: 'Flutter Developer',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text:
                    ' with 2+ years shipping production iOS & Android apps. I specialize in '
                    'building complete digital products — from scalable ',
              ),
              TextSpan(
                text: 'Firebase backends',
                style: TextStyle(
                  color: Color(0xFFF59E0B),
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'REST API integrations',
                style: TextStyle(
                  color: Color(0xFF54C5F8),
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text:
                    ' to pixel-perfect UI/UX and Play Store deployments.\n\nI leverage cutting-edge ',
              ),
              TextSpan(
                text: 'AI tools',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text:
                    ' (Cursor, Copilot, Claude, Gemini) to dramatically accelerate delivery without sacrificing enterprise-level code quality.',
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

        const SizedBox(height: 20),

        // What I do — feature list
        const Text(
          'WHAT I BUILD',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 14),
        _buildFeatureList([
          {'asset': 'assets/images/icon_flutter.png', 'text': 'Cross-platform iOS & Android apps with Flutter'},
          {'asset': 'assets/images/icon_firebase.png', 'text': 'Realtime Firebase backends with Firestore & FCM'},
          {'asset': 'assets/images/icon_architecture.png', 'text': 'Clean Architecture with GetX, Riverpod & BLoC'},
          {'icon': '💳', 'text': 'Payment integrations (Razorpay, Stripe)'},
          {'asset': 'assets/images/icon_ai_brain.png', 'text': 'AI-augmented development workflows'},
          {'asset': 'assets/images/icon_play_store.png', 'text': 'Play Store & App Store deployments'},
        ]),

        const SizedBox(height: 28),

        // Contact chips
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _ContactChip(
              Icons.email_outlined,
              PortfolioData.email,
              const Color(0xFFD4AF37),
              onTap: () => _launchUrl('mailto:${PortfolioData.email}'),
            ),
            _ContactChip(
              Icons.phone_outlined,
              PortfolioData.phone,
              const Color(0xFF10B981),
              onTap: () => _launchUrl('tel:${PortfolioData.phone.replaceAll('-', '')}'),
            ),
          ],
        ),
      ],
    ));
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildFeatureList(List<Map<String, String>> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  item.containsKey('asset')
                      ? Image.asset(
                          item['asset']!,
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                        )
                      : Text(item['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['text']!,
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRightCol() {
    return ScrollReveal(
      scrollController: scrollController,
      delay: 100,
      child: Column(
      children: [
        // Education card
        _EducationCard(),
        const SizedBox(height: 16),

        // Tech feature cards
        _TechHighlightCard(
          asset: 'assets/images/icon_architecture.png',
          title: 'Architecture Expert',
          subtitle: 'GetX · Riverpod · BLoC · Clean Architecture · MVVM',
          color: const Color(0xFF6366F1),
        ),
        const SizedBox(height: 12),
        _TechHighlightCard(
          asset: 'assets/images/icon_figma.png',
          title: 'UI/UX Focused',
          subtitle: 'Material 3 · Custom Animations · Responsive Design · Figma',
          color: const Color(0xFFEC4899),
        ),
      ],
    ));
  }
}

class _EducationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/iiit_kota.png',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Text('🎓', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioData.degree,
                  style: const TextStyle(
                    color: Color(0xFFF1F1F3),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'IIIT Kota',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CGPA: ${PortfolioData.cgpa}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '2020 – 2024',
                      style: TextStyle(
                          color: Color(0xFF4B5563), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechHighlightCard extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;
  final Color color;

  const _TechHighlightCard({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(
              asset,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF1F1F3),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withAlpha(200),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;
  const _ContactChip(this.icon, this.label, this.iconColor, {required this.onTap});

  @override
  State<_ContactChip> createState() => _ContactChipState();
}

class _ContactChipState extends State<_ContactChip> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceLight.withAlpha(200) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? widget.iconColor.withAlpha(100) : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.iconColor.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.iconColor, size: 15),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? Colors.white : const Color(0xFF9CA3AF),
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
}

