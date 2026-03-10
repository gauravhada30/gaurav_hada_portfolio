import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import '../../data/portfolio_data.dart';

class HomeSection extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;

  const HomeSection({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;

  int _titleIndex = 0;
  final List<String> _titles = [
    'Flutter Engineer',
    'AI-Augmented Developer',
    'Mobile Product Builder',
    'Firebase Integrator',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), _cycleTitle);
  }

  void _cycleTitle() {
    if (!mounted) return;
    setState(() => _titleIndex = (_titleIndex + 1) % _titles.length);
    Future.delayed(const Duration(seconds: 3), _cycleTitle);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _scrollTo(String key) {
    final ctx = widget.sectionKeys[key]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.horizontalPadding(context);
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenH),
      color: AppColors.background,
      child: Stack(
        children: [
          // Elegant golden backlight blob
          Positioned(
            top: 100,
            right: 0,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Opacity(
                opacity: 0.15 + 0.1 * _pulseController.value,
                child: Container(
                  width: 800,
                  height: 800,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0x30F59E0B),
                        Colors.transparent,
                      ], // Amber glow
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Pattern overlay (optional soft dots)
          Positioned.fill(
            child: CustomPaint(painter: _ElegantDotGridPainter()),
          ),

          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: isMobile ? 80 : 120,
            ),
            child: isMobile ? _buildMobile(context) : _buildDesktop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 11, child: _buildText(context)),
        const SizedBox(width: 80),
        Expanded(flex: 9, child: _buildPhotoCard(context)),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPhotoCard(context, isMobile: true),
        const SizedBox(height: 50),
        _buildText(context),
      ],
    );
  }

  Widget _buildText(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Welcome tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.gold.withAlpha(15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.gold.withAlpha(40)),
          ),
          child: const Text(
            'SOFTWARE ENGINEER',
            style: TextStyle(
              color: AppColors.amber,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.5),

        const SizedBox(height: 24),

        // Greeting
        Text(
          "Let's craft the",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 40 : 64,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.1,
            letterSpacing: -1.5,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Text(
              "future with ",
              style: TextStyle(
                fontSize: isMobile ? 40 : 64,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.1,
                letterSpacing: -1.5,
              ),
            ),
            ShaderMask(
              shaderCallback: (b) => AppColors.heroGradient.createShader(b),
              child: Text(
                "Flutter",
                style: TextStyle(
                  fontSize: isMobile ? 40 : 64,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

        const SizedBox(height: 20),

        // Animated role
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: DefaultTextStyle(
            key: ValueKey(_titleIndex),
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              fontFamily: 'Plus Jakarta Sans',
            ),
            child: Text(_titles[_titleIndex]),
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 24),

        // Bio
        Text(
          "I'm Gaurav Hada, a Flutter Engineer bridging the gap between pixel-perfect design and "
          "robust mobile architecture. I turn complex ideas into elegant, "
          "scalable digital products powered by modern AI-augmented workflows.",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 15 : 17,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

        const SizedBox(height: 36),

        // CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _SolidGoldenButton(
              label: 'View Projects',
              onTap: () => _scrollTo('projects'),
            ),
            _ElegantOutlineButton(
              label: 'Contact Me',
              onTap: () => _scrollTo('contact'),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

        const SizedBox(height: 48),

        // Trusted / Stats simplified
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            _buildMiniStat('2+', 'Years Exp'),
            Container(
              width: 1,
              height: 30,
              color: AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 24),
            ),
            _buildMiniStat('10+', 'Apps Built'),
            Container(
              width: 1,
              height: 30,
              color: AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 24),
            ),
            _buildMiniStat('5K+', 'Downloads'),
          ],
        ).animate().fadeIn(delay: 750.ms),
      ],
    );
  }

  Widget _buildMiniStat(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(BuildContext context, {bool isMobile = false}) {
    final size = isMobile ? 260.0 : 380.0;
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, (_floatController.value - 0.5) * 12),
        child: child,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Elegant glow behind the image
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              width: size + 20,
              height: size + 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(
                      (30 + 20 * _pulseController.value).toInt(),
                    ),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),

          // Image Container
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: AppColors.goldLight.withAlpha(150),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceLight,
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating Badge: Available for Work
          Positioned(
            bottom: 20,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Available for work',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subtle tech icon float
          _SubtleIconFloat(
            icon: Icons.code_rounded,
            xOffset: -size / 2.2,
            yOffset: -size / 4,
            delay: 0,
            floatCtrl: _floatController,
          ),
          _SubtleIconFloat(
            icon: Icons.api_rounded,
            xOffset: size / 2.2,
            yOffset: -size / 3,
            delay: 500,
            floatCtrl: _floatController,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _SubtleIconFloat extends StatelessWidget {
  final IconData icon;
  final double xOffset, yOffset;
  final int delay;
  final AnimationController floatCtrl;

  const _SubtleIconFloat({
    required this.icon,
    required this.xOffset,
    required this.yOffset,
    required this.delay,
    required this.floatCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: AnimatedBuilder(
        animation: floatCtrl,
        builder: (_, child) => Transform.translate(
          offset: Offset(
            xOffset,
            yOffset + (floatCtrl.value - 0.5) * 15 * (delay == 0 ? 1 : -1),
          ),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.amber, size: 20),
        ),
      ),
    );
  }
}

// ── Elegant Buttons ──────────────────────────────────────

class _SolidGoldenButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SolidGoldenButton({required this.label, required this.onTap});

  @override
  State<_SolidGoldenButton> createState() => _SolidGoldenButtonState();
}

class _SolidGoldenButtonState extends State<_SolidGoldenButton> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.darkAccent,
              borderRadius: BorderRadius.circular(100),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.darkAccent.withAlpha(40),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ElegantOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _ElegantOutlineButton({required this.label, required this.onTap});

  @override
  State<_ElegantOutlineButton> createState() => _ElegantOutlineButtonState();
}

class _ElegantOutlineButtonState extends State<_ElegantOutlineButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Painters ──────────────────────────────────────
class _ElegantDotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withAlpha(120)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
